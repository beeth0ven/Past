//
//  Pin.swift
//  Past
//
//  Created by luojie on 16/4/6.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Pin: RootObject {
    
    static func insert(location location: CLLocation ,inContext context: NSManagedObject.Context = .Main) -> Pin? {
        
        let pin = Pin.insert(inContext: context)
        pin.coordinate = location.localizedCoordinate
        pin.creationDate = location.timestamp
        print("Pin: \(pin.coordinate)")
        return pin
    }
    
    var option: Period.Option {
        get { return Period.Option(rawValue: optionRawValue!.integerValue)! }
        set { optionRawValue = newValue.rawValue }
    }
}

extension Pin: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(
                latitude: latitude!.doubleValue,
                longitude: longitude!.doubleValue
            )
        }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
    var title: String? {
        switch option {
        case .Stay:
            let period = stayPeriods!.firstObject as! Period
            
            
            let date = period.departureDate != NSDate.distantFuture() ? period.departureDate! : NSDate()
            let timeInterval = date.timeIntervalSinceDate(period.arrivalDate!)
            return period.arrivalDate!.detail + " ~~ " + period.departureDate!.detail + "  " + timeInterval.timeText
        case .Transition:
            return creationDate!.detail
        }
    }
    
    var subtitle: String? {
        return coordinate.description
    }
}

