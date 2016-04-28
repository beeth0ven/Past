//
//  Placemark.swift
//  Past
//
//  Created by luojie on 16/4/28.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData
import MapKit


class Placemark: RootObject {
    
    static func getFromCoordinate(coordinate: CLLocationCoordinate2D, didGet: (Placemark -> Void)) {
        
        let geocoder = CLGeocoder()
        let location = CLLocation(coordinate: coordinate.toLocation)
        geocoder.reverseGeocodeLocation(location) { clplacemarks, error in
            guard let clplacemark = clplacemarks?.first,
            placemark = getFromCLPlacemark(clplacemark) else {
                return
            }
            
            didGet(placemark)
        }
    }
    
    static func getFromCLPlacemark(clplacemark: CLPlacemark) -> Placemark? {
        guard let name = clplacemark.name else { return nil }
        
        let predicate = NSPredicate(format: "name = %@", name)
        let placemarks = Placemark.get(predicate: predicate)
        if let placemark = placemarks.first {
            return placemark
        }
        
        let placemark = Placemark.insert()
        placemark.name = name
        return placemark
    }
}
