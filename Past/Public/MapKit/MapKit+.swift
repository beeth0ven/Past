//
//  MapKit+.swift
//  Past
//
//  Created by luojie on 16/4/7.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import MapKit
import Contacts

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
    }
    
    var option: Option {
        return departureDate == NSDate.distantFuture() ? .Arrival : .Departure
    }
}

extension CLLocationManager {
    func requestAlwaysAuthorizationIfNeeded() {
        if CLLocationManager.authorizationStatus() == .NotDetermined {  requestAlwaysAuthorization() }
    }
}

extension CLGeocoder {
    static func getPlacemarksFromCoordinate(
        coordinate: CLLocationCoordinate2D,
        didGet: ([CLPlacemark] -> Void),
        didFail: ((NSError) -> Void)? = nil) {
        
        let geocoder = CLGeocoder()
        let location = CLLocation(coordinate: coordinate.toLocation)
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
    
    func distanceFromCoordinate(coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(coordinate: self)
        let location2 = CLLocation(coordinate: coordinate)
        return location1.distanceFromLocation(location2)
    }
}

extension CLLocation {
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

extension MKPlacemark {
    convenience init(coordinate: CLLocationCoordinate2D, addressName: String?) {
        let addressDictionary = addressName.flatMap { [CNPostalAddressStreetKey: $0] }
        self.init(coordinate: coordinate, addressDictionary: addressDictionary)
    }
}

extension MKCoordinateRegion {
    var minLatitude: CLLocationDegrees {
        return center.latitude - span.latitudeDelta/2
    }
    
    var maxLatitude: CLLocationDegrees {
        return center.latitude + span.latitudeDelta/2
    }
    
    var minLongitude: CLLocationDegrees {
        return center.longitude - span.longitudeDelta/2
    }
    
    var maxLongitude: CLLocationDegrees {
        return center.longitude + span.longitudeDelta/2
    }
}

