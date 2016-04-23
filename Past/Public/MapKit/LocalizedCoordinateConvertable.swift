//
//  LocalizedCoordinateConvertable.swift
//  Past
//
//  Created by luojie on 16/4/22.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import MapKit


protocol LocalizedCoordinateConvertable {
    var coordinate: CLLocationCoordinate2D { get }
}

extension LocalizedCoordinateConvertable {
    var localizedCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: localizedLatitude, longitude: localizedLongitude)
    }
    
    private var localizedLatitude: CLLocationDegrees {
        return coordinate.latitude  - 0.002435
    }
    
    private var localizedLongitude: CLLocationDegrees {
        return coordinate.longitude  + 0.00543
    }
    
}

extension CLVisit: LocalizedCoordinateConvertable { }
extension CLLocation: LocalizedCoordinateConvertable { }