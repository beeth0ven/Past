//
//  CoreData+.swift
//  Past
//
//  Created by luojie on 16/4/6.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import CoreData

extension NSManagedObject {
    static func insert(inContext context: NSManagedObject.Context = .Main) -> Self {
        print(#function)
        print(String(self))
        let entityDescription = NSEntityDescription.entityForName(String(self), inManagedObjectContext: context.value!)!
        return self.init(entity: entityDescription, insertIntoManagedObjectContext: context.value)
    }
}

extension NSFetchRequest {
    convenience init<MO: NSManagedObject>(_ entityType: MO.Type) {
        self.init(entityName: String(MO))
    }
    
    func execute(inContext context: NSManagedObject.Context = .Main) throws -> [AnyObject] {
        return try context.value.executeFetchRequest(self)
    }
}