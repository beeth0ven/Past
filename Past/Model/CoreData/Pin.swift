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
        pin.latitude = location.coordinate.chineseLatitude
        pin.longitude = location.coordinate.chineseLongitude
        pin.creationDate = location.timestamp
        print("Pin: \(pin.coordinate)")
        return pin
    }
    
    var option: Period.Option {
        return Period.Option(rawValue: optionRawValue!.integerValue)!
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
        return creationDate!.detail
    }
    
    var subtitle: String? {
        return coordinate.description
    }
}

