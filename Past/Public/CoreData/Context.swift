//
//  Context.swift
//  Past
//
//  Created by luojie on 16/4/1.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import CoreData

enum Context: NSManagedObjectContextType {
    case Main
    
    var value: NSManagedObjectContext {
        switch self {
        case .Main:
            return Context.mainContext
        }
    }
    
    private static var mainContext: NSManagedObjectContext = Context.createMainContext()
    
    static var modelName: String { return "Model" }
}


extension NSURL {
    static func document() -> NSURL {
        return NSFileManager
            .defaultManager()
            .URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            .last!
    }
}

protocol NSManagedObjectContextType {
    static var modelName: String { get }
    static var persistentStoreURL: NSURL { get }
    
    var value: NSManagedObjectContext { get }
}

extension NSManagedObjectContextType {
    
    static func createMainContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }
    
    static var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        try! coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: persistentStoreURL, options: nil)
        return coordinator
    }

    static var managedObjectModel: NSManagedObjectModel {
        let modelURL = NSBundle.mainBundle().URLForResource(modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }

    static var persistentStoreURL: NSURL {
        return NSURL.document().URLByAppendingPathComponent("\(modelName).sqlite")
    }
    
}




