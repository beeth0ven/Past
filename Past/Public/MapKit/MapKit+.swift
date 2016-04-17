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
    enum Option {
        case Arrival
        case Departure
    }
    
    var option: Option {
        if departureDate == NSDate.distantFuture() {
            return .Arrival
        } else if arrivalDate == NSDate.distantPast() {
            return .Departure
        }
        fatalError("Visit option should be either arrive or departure.")
    }
}