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

    override func dataOfType(typeName: String?) throws -> NSData {
        let outError: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
        if let value = fileContents.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            //outError.memory = NSError.errorWithDomain(NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
            return value
        }
        //outError.memory = NSError.errorWithDomain(NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        throw outError
    }

    override func readFromData(data: NSData?, ofType typeName: String?) throws {
        //outError.memory = NSError.errorWithDomain(NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        fileContents = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
    }


}

