//
//  CoreDataHanderType.swift
//  Past
//
//  Created by luojie on 16/4/7.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataHanderType {}

extension CoreDataHanderType {
    func saveManagedObjectContext() {
        let context = NSManagedObject.Context.Main.value
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
}