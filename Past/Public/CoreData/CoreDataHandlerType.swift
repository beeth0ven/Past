//
//  CoreDataHandlerType.swift
//  Past
//
//  Created by luojie on 16/4/7.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataHandlerType {}

extension CoreDataHandlerType {
    func saveManagedObjectContext() {
        let context = NSManagedObject.Context.Main.value
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    func performCoreDataBackgroundTask() {
        print(#function)
        let predicate = NSPredicate(format: "optionRawValue = %@ AND placemark = nil", Period.Option.Stay.rawValue.toNumber)
        let pins = Pin.get(predicate: predicate)
        pins.forEach { $0.getPlacemarkIfNeeded() }
    }
}