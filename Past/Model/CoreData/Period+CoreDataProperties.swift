//
//  Period+CoreDataProperties.swift
//  Past
//
//  Created by luojie on 16/4/28.
//  Copyright © 2016年 LuoJie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Period {

    @NSManaged var arrivalDate: NSDate?
    @NSManaged var departureDate: NSDate?
    @NSManaged var optionRawValue: NSNumber?
    @NSManaged var timeInterval: NSNumber?
    @NSManaged var next: Period?
    @NSManaged var previous: Period?
    @NSManaged var pins: NSOrderedSet?

}
