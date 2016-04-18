//
//  MapKit+.swift
//  Past
//
//  Created by luojie on 16/4/7.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import MapKit

// MARK: - MapKit

// MARK: - CoreLocation

extension CLLocationCoordinate2D: CustomStringConvertible {
    public var description: String {
        return "latitude: \(latitude) longitude:\(longitude)"
    }
}

extension CLLocationCoordinate2D {
    var chineseLatitude: CLLocationDegrees {
        return latitude - 0.002435
    }
    
    var chineseLongitude: CLLocationDegrees {
        return longitude + 0.00543
    }
}

extension CLLocationManager {
    func requestAlwaysAuthorizationIfNeeded() {
        if CLLocationManager.authorizationStatus() == .NotDetermined {  requestAlwaysAuthorization() }
    }
}