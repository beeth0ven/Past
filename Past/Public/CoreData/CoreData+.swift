//
//  CoreData+.swift
//  Past
//
//  Created by luojie on 16/4/6.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import CoreData

extension NSFetchRequest {
    convenience init<MO: NSManagedObject>(_ entityType: MO.Type) {
        self.init(entityName: String(MO))
    }
    
    func execute(inContext context: NSManagedObject.Context = .Main) throws -> [AnyObject] {
        return try context.value.executeFetchRequest(self)
    }
}

protocol ManagedObjectType { }
extension NSManagedObject: ManagedObjectType {}

extension ManagedObjectType where Self: NSManagedObject {
    static func insert(inContext context: NSManagedObject.Context = .Main) -> Self {
        print(#function + String(self))
        let entityDescription = NSEntityDescription.entityForName(String(self), inManagedObjectContext: context.value)!
        return self.init(entity: entityDescription, insertIntoManagedObjectContext: context.value)
    }
    
    func delete() {
        managedObjectContext?.deleteObject(self)
    }
    
    static func get(predicate
        predicate: NSPredicate? = nil,
        sortOption: NSSortDescriptor.Option? = .By(key: "creationDate", ascending: false),
        context: NSManagedObject.Context = .Main
        ) -> [Self] {
        let request = NSFetchRequest(self)
        request.predicate = predicate
        request.sortDescriptors = sortOption.flatMap { [$0.sortDescriptor] }

        return try! context.value.executeFetchRequest(request) as! [Self]
    }
}


extension NSSortDescriptor {
    enum Option {
        case By(key: String, ascending: Bool)
        
        var sortDescriptor: NSSortDescriptor {
            switch self {
            case let .By(key, ascending):
                return NSSortDescriptor(key: key, ascending: ascending)
            }
        }
    }
    
}
