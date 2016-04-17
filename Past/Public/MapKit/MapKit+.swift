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

extension CLVisit {
    enum Option: Int, CustomStringConvertible {
        case Arrival
        case Departure
        
        var description: String {
            switch self {
            case .Arrival:
                return "Arrived"
            case .Departure:
                return "Leaved"
            }
        }
    }
    
    var option: Option {
        if departureDate == NSDate.distantFuture() {
            return .Arrival
        } else if arrivalDate == NSDate.distantPast() {
            return .Departure
        }
        fatalError("Visit option should be either arrive or departure.")
    }
    
    var date: NSDate {
        switch option {
        case .Arrival:
            return arrivalDate
        case .Departure:
            return departureDate
        }
    }
}

extension CLLocationManager {
    func requestAlwaysAuthorizationIfNeeded() {
        if CLLocationManager.authorizationStatus() == .NotDetermined {  requestAlwaysAuthorization() }
    }
}