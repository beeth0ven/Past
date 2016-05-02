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

class Pin: ManagedObject {
    
    static func insertFromLocation(location: CLLocation) -> Pin {
        let pin = Pin.insertFromCoordinate(location.coordinate.toMap, option: .Transition)
        pin.creationDate = location.timestamp
        return pin
    }
    
    static func insertFromCoordinate(coordinate: CLLocationCoordinate2D, option: Period.Option) -> Pin {
        let pin = Pin.insert()
        pin.option = option
        pin.coordinate = coordinate
        return pin
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
            updateRegionIfNeeded()
        }
    }
    
    func getPlacemarkIfNeeded() {
        guard option == .Stay else { return }
        Placemark.getFromCoordinate(coordinate, didGet: { [weak self] in self?.placemark = $0 })
    }
    
    private func updateRegionIfNeeded() {
        guard option == .Stay else { return }
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

extension Pin {
    func openInMaps() {
        let mkplacmark = MKPlacemark(coordinate: coordinate, addressName: placemark?.name)
        let mapItem = MKMapItem(placemark: mkplacmark)
        mapItem.openInMapsWithLaunchOptions([MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit])
    }
}


