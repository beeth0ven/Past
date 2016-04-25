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
        let past = NSDate.distantPast(), future = NSDate.distantFuture()
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

extension CLGeocoder {
    static func getPlacemarksFrom(
        annotation annotation: MKAnnotation,
        didGet: ([CLPlacemark] -> Void),
        didFail: ((NSError) -> Void)? = nil) {
        
        let geocoder = CLGeocoder()
        let location = CLLocation(coordinate: annotation.coordinate.toLocation)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                didFail?(error!)
                return
            }
            
            didGet(placemarks!)
        }
    }
}

extension CLLocationCoordinate2D {
    var toMap: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude  - 0.002435,
            longitude: longitude  + 0.00543
        )
    }
    
    var toLocation: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude  + 0.002435,
            longitude: longitude  - 0.00543
        )
    }
}

extension CLLocation {
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
