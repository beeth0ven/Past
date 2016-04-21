//
//  Pin+CoreDataProperties.swift
//  Past
//
//  Created by luojie on 16/4/22.
//  Copyright © 2016年 LuoJie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pin {

    @NSManaged var optionRawValue: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var stayPeriod: Period?
    @NSManaged var transitionPeriod: Period?

}
