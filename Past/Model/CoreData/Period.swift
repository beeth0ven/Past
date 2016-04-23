//
//  Period.swift
//  Past
//
//  Created by luojie on 16/4/21.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Period: RootObject {
    
    enum Option: Int {
        case Stay
        case Transition
    }
    
    static func insert(visit visit: CLVisit ,inContext context: NSManagedObject.Context = .Main) -> Period {
        
        if visit.option == .Visit {
            let predicate = NSPredicate(format: "arrivalDate = %@", visit.arrivalDate)
            let stays = Period.get(predicate: predicate)
            if let stay = stays.first {
                stay.update(visit: visit)
                return stay
            }
        }
        
        let period = Period.insert(inContext: context)
        period.update(visit: visit)
        print("Stay: \(period.stayPin!.coordinate)")
        return period
    }
    
    var option: Option {
        get { return Option(rawValue: optionRawValue!.integerValue)! }
        set { optionRawValue = newValue.rawValue }
    }
    
    func update(visit visit: CLVisit) {
        if stayPin == nil { stayPin = Pin.insert() }
        stayPin?.coordinate = visit.localizedCoordinate
        arrivalDate = visit.arrivalDate
        departureDate = visit.departureDate
        if visit.option == .Visit { timeInterval = departureDate!.timeIntervalSinceDate(arrivalDate!) }
    }
}

extension Period {
    var title: String {
         return arrivalDate!.detail + " ~~ " + departureDate!.detail
    }
    
    var subTitle: String {
        let date = departureDate != NSDate.distantFuture() ? departureDate! : NSDate()
        let timeInterval = date.timeIntervalSinceDate(arrivalDate!)
        return timeInterval.timeText
    }
}


