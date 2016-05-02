//
//  Region.swift
//  Past
//
//  Created by luojie on 16/4/28.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData
import MapKit


class Region: RootObject {
    
    static func insertForName(name: String, coordinate: CLLocationCoordinate2D) -> Region {
        let region = Region.insert()
        region.name = name
        region.coordinate = coordinate
        let predicate = NSPredicate(aroundCoordinate: coordinate)
        let pins = Pin.get(predicate: predicate)
        pins.forEach { $0.region = region }
        print("New Region With Pin Count:", pins.count)
        return region
    }
    
    static func getFromCoordinate(coordinate: CLLocationCoordinate2D) -> Region? {
        let predicate = NSPredicate(aroundCoordinate: coordinate)
        let regions = Region.get(predicate: predicate)
        return regions.sort(>).first
    }
    
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
}

func >(left: Region, right: Region) -> Bool {
    return left.pins.count > right.pins.count
}