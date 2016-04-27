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
        case Main
        
        var value: NSManagedObjectContext {
            switch self {
            case .Main:
                return Context.mainContext
            }
        }
        
        private static var managedObjectModel: NSManagedObjectModel = {
            let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
            return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
        
        private static var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
            let url = NSURL.document().URLByAppendingPathComponent("CoreData.sqlite")
            try! coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
            return coordinator
        }()
        
        private static var mainContext: NSManagedObjectContext = {
            let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            context.persistentStoreCoordinator = persistentStoreCoordinator
            return context
        }()
    }
}

extension NSURL {
    static func document() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
    }
}






