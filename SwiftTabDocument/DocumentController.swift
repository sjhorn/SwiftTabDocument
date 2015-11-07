//
//  DocumentController.swift
//  SwiftTabDocument
//
//  Created by Scott Horn on 4/06/2014.
//  Copyright (c) 2014 Scott Horn. All rights reserved.
//

import Cocoa

let HMDocumentNeedWindowNotification = "DocumentNeedWindowNotification"
var HMDocumentCloseAllWindows = "HMDocumentCloseAllWindows"

class DocumentController : NSDocumentController {
    var windowControllers =  [NSWindowController]()
    var topLeftPoint : NSPoint = NSPoint(x:0, y:0)
    
    var closedDocumentIndex : Int = 0
    var closeAllCompletedBlock : (AnyObject, Bool) -> () = { o, b in return }
    
    override init() {
        super.init()
        NSNotificationCenter
            .defaultCenter()
            .addObserver(self, selector: "handleDocumentNeedWindowNotification:",
                name: HMDocumentNeedWindowNotification, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func handleDocumentNeedWindowNotification(notification : NSNotification) {
        self.mainWindowController().addDocument(notification.object as! Document)
    }
    
    func mainWindowController() -> WindowController {
        let mainWindow : NSWindow? = NSApp?.mainWindow
        if mainWindow == nil {
            return newWindowController()
        } else {
            return mainWindow?.windowController as! WindowController
        }
    }
    
    func newWindowController() -> WindowController {
        let windowController : WindowController = WindowController(windowNibName:"Window")
        windowController.showWindow(self)
        topLeftPoint = windowController.window!.cascadeTopLeftFromPoint(topLeftPoint)
        windowControllers.append(windowController)
        return windowController
    }
    
    @IBAction func newWindow(sender : AnyObject) {
        let windowController : WindowController? = NSApp.mainWindow?.windowController as? WindowController
        if windowController != nil {
            let window : NSWindow? = windowController?.window
            if ((window?.makeFirstResponder(window)) == nil) {
                return // return if we cant finish editing
            }
        }
        let mainWindowController : WindowController = newWindowController()
        mainWindowController.window!.makeKeyAndOrderFront(nil)
        NSApp.sendAction("newDocument:", to:nil, from:self)
    }
    
    func document(doc: NSDocument, shouldClose: Bool, contextInfo: UnsafeMutablePointer<Void>) {
        if contextInfo == &HMDocumentCloseAllWindows {
            if shouldClose {
                closedDocumentIndex += 1
                var nextDoc : Document? = nil
                if documents.count > closedDocumentIndex {
                    nextDoc = documents[closedDocumentIndex] as? Document
                }
                if nextDoc != nil {
                    nextDoc?.canCloseDocumentWithDelegate(self,
                        shouldCloseSelector: "document:shouldClose:contextInfo:",
                        contextInfo: &HMDocumentCloseAllWindows)
                } else {
                    closeAllCompletedBlock(self, true)
                }
                
            } else {
                closeAllCompletedBlock(self, false)
            }
        }
    }


    override func closeAllDocumentsWithDelegate(delegate: AnyObject?, didCloseAllSelector: Selector, contextInfo: UnsafeMutablePointer<Void>) {
        closeAllCompletedBlock = {
            (me : AnyObject, didCloseAll : Bool) -> () in
            HMUtils.delegate(delegate, _something: me, didSomething: didCloseAll, soContinue: contextInfo)
        }
        closedDocumentIndex = 0
        if documents.count > 0 {
            (documents[0] as NSDocument).canCloseDocumentWithDelegate(self,
                shouldCloseSelector: "document:shouldClose:contextInfo:",
                contextInfo: &HMDocumentCloseAllWindows)
        }
    }
    
}
