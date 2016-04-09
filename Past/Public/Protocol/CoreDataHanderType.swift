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
        do {
            try NSManagedObject.Context.Main.value.save()
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
}