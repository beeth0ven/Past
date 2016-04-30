//
//  Placemark+CoreDataProperties.swift
//  Past
//
//  Created by luojie on 16/4/30.
//  Copyright © 2016年 LuoJie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Placemark {

    @NSManaged var name: String?
    @NSManaged var country: String?
    @NSManaged var province: String?
    @NSManaged var city: String?
    @NSManaged var subCity: String?
    @NSManaged var street: String?
    @NSManaged var subStreet: String?
    @NSManaged var subProvince: String?
    @NSManaged var postalCode: String?
    @NSManaged var pins: NSSet?

}
