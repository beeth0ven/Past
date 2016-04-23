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

extension CLVisit {
    enum Option: Int {
        case Arrival
        case Departure
        case Visit
    }
    
    var option: Option {
        let past = NSDate.distantPast() , future = NSDate.distantFuture()
        switch (arrivalDate, departureDate) {
        case (_, future):
            return .Arrival
        case (past, _):
            return .Departure
        default:
            return .Visit
        }
    }
}

extension CLLocationManager {
    func requestAlwaysAuthorizationIfNeeded() {
        if CLLocationManager.authorizationStatus() == .NotDetermined {  requestAlwaysAuthorization() }
    }
}