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

    static func insert(location location: CLLocation ,inContext context: NSManagedObject.Context = .Main) -> Pin? {
        if let previousPin = previousPin {
            let previousLocation = CLLocation(latitude: previousPin.coordinate.latitude, longitude: previousPin.coordinate.longitude)
            let distence = location.distanceFromLocation(previousLocation)
            print("distence: \(distence)")
            if distence < LocationConstants.distanceFilter { return nil }
        }
        
        let pin = Pin.insert(inContext: context)
        pin.latitude = location.coordinate.latitude
        pin.longitude = location.coordinate.longitude
        pin.date = location.timestamp
        print("Pin: \(pin.coordinate)")
        return pin
    }
    
    private static var previousPin: Pin? {
        let request = NSFetchRequest(self)
        request.sortDescriptors = [NSSortDescriptor.Option.By(key: "date", ascending: false).sortDescriptor]
        request.fetchLimit = 1
        
        let context = NSManagedObject.Context.Main
        let result = try! context.value.executeFetchRequest(request) as! [Pin]
        print("previousPin date: \(result.first?.date?.detail)")
        return result.first
    }
}

extension Pin: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude!.doubleValue - 0.00244,
            longitude: longitude!.doubleValue + 0.00544
        )
    }
    
    var title: String? {
        return date?.detail
    }
}
