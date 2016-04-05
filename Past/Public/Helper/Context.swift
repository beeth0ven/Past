//
//  Context.swift
//  Past
//
//  Created by luojie on 16/4/1.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    enum Context {
        case Main, Background
        
        var value: NSManagedObjectContext {
            switch self {
            case .Main:
                return Context.mainContext
                
            case .Background:
                return Context.backgroundContext
            }
        }
        
        private static var mainContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        private static var backgroundContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        
    }
    
    static func insert(inContext context: NSManagedObject.Context = .Main) -> Self {
        let entityDescription = NSEntityDescription.entityForName(String(self), inManagedObjectContext: context.value)!
        return self.init(entity: entityDescription, insertIntoManagedObjectContext: context.value)
    }
}

