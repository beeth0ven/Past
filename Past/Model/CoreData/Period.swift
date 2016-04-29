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
    
    static func updateFromVisit(visit: CLVisit) {
        
        switch visit.option {
        case .Arrival:
            insertFromVisit(visit)
            
        case .Departure:
            insertFromVisit(visit)
            
        case .Visit:
            if let stay = getFromVisit(visit) {
                stay.updateFromVisit(visit)
            } else {
                insertFromVisit(visit)
            }
            
        }
    }
    
    private static func insertFromVisit(visit: CLVisit) {
        let period = Period.insert()
        period.arrivalDate = visit.arrivalDate
        period.departureDate = visit.departureDate
        let pin = Pin.insert()
        pin.coordinate = visit.coordinate.toMap
        pin.period = period
        print("Stay: \(period.stayPin!.coordinate)")
    }
    
    private static func getFromVisit(visit: CLVisit) -> Period? {
        let predicate = NSPredicate(format: "arrivalDate = %@", visit.arrivalDate)
        let stays = Period.get(predicate: predicate)
        return stays.first
    }
    
    private func updateFromVisit(visit: CLVisit) {
        stayPin?.coordinate = visit.coordinate.toMap
        departureDate = visit.departureDate
        timeInterval = departureDate!.timeIntervalSinceDate(arrivalDate!)
    }
    
    var option: Option {
        get { return Option(rawValue: optionRawValue!.integerValue)! }
        set { optionRawValue = newValue.rawValue }
    }
    
    var stayPin: Pin? {
        switch option {
        case .Stay:
            return pins?.firstObject as? Pin
        case .Transition:
            return nil
        }
    }
}

extension Period {
    var title: String {
         return arrivalDate!.detail + " ~~ " + departureDate!.detail
    }
    
    var subTitle: String {
        return timeIntervalText
    }
    
    var timeIntervalText: String {
        let date = departureDate != NSDate.distantFuture() ? departureDate! : NSDate()
        let timeInterval = date.timeIntervalSinceDate(arrivalDate!)
        return timeInterval.timeText
    }
}


