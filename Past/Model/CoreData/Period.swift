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
        return Option(rawValue: optionRawValue!.integerValue)!
    }
    
    func update(visit visit: CLVisit) {
        if stayPin == nil { stayPin = Pin.insert() }
        stayPin!.latitude = visit.coordinate.chineseLatitude
        stayPin!.longitude = visit.coordinate.chineseLongitude
        arrivalDate = visit.arrivalDate
        departureDate = visit.departureDate
        if visit.option == .Visit { timeInterval = departureDate!.timeIntervalSinceDate(arrivalDate!) }
    }
}
extension Period: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        get { return stayPin!.coordinate }
        set { stayPin!.coordinate = newValue }
    }
    
    var title: String? {
        let date = departureDate != NSDate.distantFuture() ? departureDate! : NSDate()
        let timeInterval = date.timeIntervalSinceDate(arrivalDate!)
        return arrivalDate!.detail + " ~~ " + departureDate!.detail + "  " + timeInterval.timeText
    }
    
    var subtitle: String? {
        return coordinate.description
    }
}

