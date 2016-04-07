//
//  Context.swift
//  Past
//
//  Created by luojie on 16/4/1.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import CoreData

extension NSManagedObject {
    enum Context {
        case Main, Background
        
        var value: NSManagedObjectContext! {
            switch self {
            case .Main:
                return Context.mainContext
            case .Background:
                return Context.backgroundContext
            }
        }
        
        private static var mainContext: NSManagedObjectContext! { didSet { contextDidChange() } }
        private static var backgroundContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        
        private static func contextDidChange() {
            NSNotification.Identifier.ManagedObjectContextDidChange.post()
        }
        
        private static var contextCreated = false

        static func createContextIfNeeded() {
            guard !contextCreated else { return }
            contextCreated = true
            
            var url = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
            url = url.URLByAppendingPathComponent("CoreDataDocument")
            let document = UIManagedDocument(fileURL: url)
            if !NSFileManager.defaultManager().fileExistsAtPath(url.path!) {
                document.saveToURL(url, forSaveOperation: .ForCreating, completionHandler: { _ in
                    print("CoreDataDocument saveToURL")
                    NSManagedObject.Context.mainContext = document.managedObjectContext
                })
            } else if document.documentState == UIDocumentState.Closed {
                document.openWithCompletionHandler({ _ in
                    print("CoreDataDocument openWithCompletionHandler")
                    NSManagedObject.Context.mainContext = document.managedObjectContext
                })
            } else {
                print("CoreDataDocument is opened")
                NSManagedObject.Context.mainContext = document.managedObjectContext
            }
        }
        
    }
}







