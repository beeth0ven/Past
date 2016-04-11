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

class Pin: NSManagedObject {

    static func insert(location location: CLLocation ,inContext context: NSManagedObject.Context = .Main) -> Pin {
        let pin = Pin.insert(inContext: context)
        pin.latitude = location.coordinate.latitude
        pin.longitude = location.coordinate.longitude
        pin.date = location.timestamp
        print("Pin: \(pin.coordinate)")
        return pin
    }
}

extension Pin: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude!.doubleValue - 0.00244,
            longitude: longitude!.doubleValue + 0.00544
        )
    }
}
