//
//  PlaceInfo.swift
//  Past
//
//  Created by luojie on 16/4/24.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData
import MapKit


class PlaceInfo: RootObject {

    static func insert(placemark placemark: CLPlacemark ,inContext context: NSManagedObjectContextType = Context.Main) -> PlaceInfo? {
        guard let name = placemark.name else { return nil }
        let placeInfo = PlaceInfo.insert()
        placeInfo.name = name
        return placeInfo
    }
}
