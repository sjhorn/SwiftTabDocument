//
//  Document.swift
//  SwiftTabDocument
//
//  Created by Scott Horn on 4/06/2014.
//  Copyright (c) 2014 Scott Horn. All rights reserved.
//

import Cocoa

class Document: NSDocument, MMTabBarItem {
    var hasCloseButton : Bool = true
    var fileContents : NSString = NSString()
    var viewController : ViewController?

    override class func autosavesInPlace() -> Bool {
        return false
    }

    override func makeWindowControllers() {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: HMDocumentNeedWindowNotification, object: self))
    }    

    override func dataOfType(typeName: String?, error outError: NSErrorPointer) -> NSData? {
        //outError.memory = NSError.errorWithDomain(NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        return fileContents.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    }

    override func readFromData(data: NSData?, ofType typeName: String?, error outError: NSErrorPointer) -> Bool {
        //outError.memory = NSError.errorWithDomain(NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        fileContents = NSString(data: data, encoding: NSUTF8StringEncoding) as String
        return true
    }


}

