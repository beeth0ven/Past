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
    
    
    
    static func getFromCoordinate(coordinate: CLLocationCoordinate2D) -> Region? {
        let predicate = NSPredicate(aroundCoordinate: coordinate)
        let regions = Region.get(predicate: predicate)
        return regions.sort(>).first
    }

}

func >(left: Region, right: Region) -> Bool {
    return left.pins?.count > right.pins?.count
}