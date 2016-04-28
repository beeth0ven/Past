//
//  Pin+CoreDataProperties.swift
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

extension Pin {

    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var optionRawValue: NSNumber?
    @NSManaged var placemark: Placemark?
    @NSManaged var period: Period?
    @NSManaged var region: Region?

}
