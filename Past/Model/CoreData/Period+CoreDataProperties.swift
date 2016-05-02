//
//  Period+CoreDataProperties.swift
//  Past
//
//  Created by luojie on 16/5/2.
//  Copyright © 2016年 LuoJie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Period {
    
    @NSManaged var arrivalDate: NSDate!
    @NSManaged var departureDate: NSDate!
    @NSManaged var optionRawValue: NSNumber!
    @NSManaged var timeInterval: NSNumber?
    @NSManaged var isCurrent: NSNumber!
    @NSManaged var next: Period?
    @NSManaged var pins: Set<Pin>
    @NSManaged var previous: Period?

    var option: Option {
        get { return Option(rawValue: optionRawValue!.integerValue)! }
        set { optionRawValue = newValue.rawValue }
    }
    
    var stayPin: Pin? {
        switch option {
        case .Stay:
            return pins.first
        case .Transition:
            return nil
        }
    }
    
    enum Option: Int, CustomStringConvertible {
        case Stay
        case Transition
        
        var description: String {
            switch self {
            case Stay:
                return "🏡"
            case Transition:
                return "🚴"
            }
        }
    }
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        arrivalDate = NSDate.distantPast()
        departureDate = NSDate.distantFuture()
    }
}
