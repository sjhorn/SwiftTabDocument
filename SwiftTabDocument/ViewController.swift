//
//  ViewController.swift
//  SwiftTabDocument
//
//  Created by Scott Horn on 8/06/2014.
//  Copyright (c) 2014 Scott Horn. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    let document : Document?
    var textView : NSTextView {
        return ((self.view as NSScrollView).documentView) as NSTextView
    }
    
    init(document: Document) {
        super.init(nibName: "View", bundle: nil)
        self.document = document
    }
    
    override func loadView() {
        super.loadView()
    }
}
