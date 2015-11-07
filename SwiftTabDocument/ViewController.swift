//
//  ViewController.swift
//  SwiftTabDocument
//
//  Created by Scott Horn on 8/06/2014.
//  Copyright (c) 2014 Scott Horn. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var document : Document?
    var textView : NSTextView {
        return ((self.view as! NSScrollView).documentView) as! NSTextView
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)!
    }
    
    convenience init(document: Document) {
        self.init(nibName: "View", bundle: nil)
        self.document = document
        
        textView.bind("value", toObject: document, withKeyPath: "fileContents", options: nil)
    }
    
    override func loadView() {
        super.loadView()
    }
}
