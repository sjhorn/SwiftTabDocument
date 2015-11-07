//
//  WindowController.swift
//  SwiftTabDocument
//
//  Created by Scott Horn on 4/06/2014.
//  Copyright (c) 2014 Scott Horn. All rights reserved.
//

import Cocoa

var HMWindowControllerCloseTab = "HMWindowControllerCloseTab"
var HMWindowControllerCloseAllTabs = "HMWindowControllerCloseAllTabs"

class WindowController: NSWindowController, NSWindowDelegate, MMTabBarViewDelegate {
    var documents: [Document] = []
    var finishedClosingFunc: (Bool) -> () = { (b) in }
    
    @IBOutlet var tabBar: MMTabBarView?
    @IBOutlet var tabView: NSTabView?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        window!.delegate = self
        for doc in self.documents {
            addViewWithDocument(doc)
        }
        tabBar!.delegate = self
    }
    
    func addViewWithDocument(document: Document) {
        let viewController: ViewController = ViewController(document:document)
        document.viewController = viewController
        
        let item: NSTabViewItem = NSTabViewItem(identifier: document)
        item.bind("label", toObject: document, withKeyPath: "displayName", options: nil)
        
        item.view = viewController.view
        item.initialFirstResponder = viewController.textView
        
        tabView?.addTabViewItem(item)
        tabView?.selectTabViewItem(item)
        
        document.addWindowController(self)
    }
    
    func addDocument(document: Document) {
        documents.append(document)
        if windowLoaded {
            addViewWithDocument(document)
        }
    }
    
    @IBAction func closeDocument(sender: AnyObject) {
        let item: NSTabViewItem? = tabBar?.selectedTabViewItem()
        if item != nil {
            tabView(self.tabView, shouldCloseTabViewItem: item)
        }
    }
    
    func tabView(aTabView: NSTabView!, shouldCloseTabViewItem tabViewItem: NSTabViewItem!) -> (Bool) {
        let doc: Document = tabViewItem.identifier as! Document
        doc.canCloseDocumentWithDelegate(self,
            shouldCloseSelector: "document:shouldClose:contextInfo:",
            contextInfo: &HMWindowControllerCloseTab)
        return false
    }
    
    @IBAction func closeWindow(sender : AnyObject) {
        self.closeAllTabsWithFunc() { closedAll in
            if closedAll {
                self.close()
            }
        }
    }
    
    override func validateMenuItem(menuItem: NSMenuItem) -> Bool {
        switch menuItem.action {
        case "closeDocument:":
            return tabBar?.selectedTabViewItem() != nil
        case "showNextTab:", "showPrevTab:":
            return tabView?.numberOfTabViewItems > 1
        default:
            return true
        }
    }
    
    func tabView(tabView: NSTabView, didSelectTabViewItem tabViewItem: NSTabViewItem?) {
        let document: Document = tabViewItem!.identifier as! Document;
//        setDocument(nil)
        document.addWindowController(self)
        window!.makeFirstResponder(document.viewController?.textView)
    }
    
    func addNewTabToTabView(aTabView: NSTabView) {
        NSApp.sendAction("newDocument:", to: nil, from: self)
    }
    
    func closeAllTabsWithFunc(finishedClosingFunc: (Bool) -> () ) {
        if self.documents.count < 1 {
            finishedClosingFunc(true)
        } else {
            self.finishedClosingFunc = finishedClosingFunc
            (documents[0] as Document).canCloseDocumentWithDelegate(self,
                shouldCloseSelector: "document:shouldClose:contextInfo:",
                contextInfo: &HMWindowControllerCloseAllTabs)
        }
    }
    
    func closeTabWithDocument(document: Document) {
        let tabViewItems : [AnyObject]! = tabView?.tabViewItems
        
        for item in tabViewItems as! [NSTabViewItem] {
            if item.identifier as! Document == document {
                tabView?.removeTabViewItem(item)
                return
            }
        }
    }
    
    func document(document: NSDocument, shouldClose: Bool, contextInfo: UnsafeMutablePointer<Void>) {
        if shouldClose {
            closeTabWithDocument(document as! Document)
            let doc : Document = document as! Document
            documents = documents.filter { $0 != doc }
            doc.removeWindowController(self)
            doc.close()
            if contextInfo == &HMWindowControllerCloseAllTabs {
                if documents.count > 0 {
                    documents[0].canCloseDocumentWithDelegate(self,
                        shouldCloseSelector: "document:shouldClose:contextInfo:",
                        contextInfo: &HMWindowControllerCloseAllTabs)
                } else {
                    finishedClosingFunc(true)
                    finishedClosingFunc = { b in }
                }
            }
        } else {
            if contextInfo == &HMWindowControllerCloseAllTabs {
                finishedClosingFunc(false)
                finishedClosingFunc = { b in }
            }
        }
    }
    
    override func setDocumentEdited(dirtyFlag: Bool) {
        for doc in documents {
            if doc.documentEdited {
                super.setDocumentEdited(true)
                return
            }
        }
        super.setDocumentEdited(false)
    }
    
    @IBAction func showNextTab(sender: AnyObject) {
        let tabView = self.tabView!
        if tabView.indexOfTabViewItem(tabView.selectedTabViewItem!) < tabView.numberOfTabViewItems - 1 {
            tabView.selectNextTabViewItem(self)
        } else {
            tabView.selectFirstTabViewItem(self)
        }
    }
    
    @IBAction func showPrevTab(sender: AnyObject) {
        let tabView = self.tabView!
        if tabView.indexOfTabViewItem(tabView.selectedTabViewItem!) > 0 {
            tabView.selectPreviousTabViewItem(self)
        } else {
            tabView.selectLastTabViewItem(self)
        }
    }
    
}
