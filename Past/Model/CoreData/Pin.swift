//
//  Pin.swift
//  Past
//
//  Created by luojie on 16/4/6.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Pin: RootObject {
    
    static func insertFromLocation(location: CLLocation) -> Pin {
        
        let pin = Pin.insert()
        pin.coordinate = location.coordinate.toMap
        pin.creationDate = location.timestamp
        print("Pin: \(pin.coordinate)")
        return pin
    }
    
    var option: Period.Option {
        get { return Period.Option(rawValue: optionRawValue!.integerValue)! }
        set { optionRawValue = newValue.rawValue }
    }
}

extension Pin: MKAnnotation {
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
            getPlacemarkIfNeeded()
            updateRegion()
        }
    }
    
    private func getPlacemarkIfNeeded() {
        if placemark == nil {
            Placemark.getFromCoordinate(coordinate, didGet: {
                [weak self] placemark in
                self?.placemark = placemark
                })
        }
    }
    
    private func updateRegion() {
        region = Region.getFromCoordinate(coordinate)
    }
    
    var title: String? {
        switch option {
        case .Stay:
            return region?.name ?? placemark?.name
        case .Transition:
            return creationDate!.detail
        }
    }
    
}
