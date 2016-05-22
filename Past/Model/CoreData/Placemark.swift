//
//  Placemark.swift
//  Past
//
//  Created by luojie on 16/4/28.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Placemark: ManagedObject {
    
    static func getFromCoordinate(
        coordinate: CLLocationCoordinate2D,
        didGet: (Placemark -> Void),
        didFail: (() -> Void)? = nil) {

        CLGeocoder.getPlacemarksFromCoordinate(coordinate, didGet: { clplacemarks in
            guard let clplacemark = clplacemarks.first,
                placemark = getFromCLPlacemark(clplacemark) else {
                    didFail?()
                    return
            }
            
            didGet(placemark)
            }, didFail: { _ in didFail?() })
    }
    
    static func getFromCLPlacemark(clplacemark: CLPlacemark) -> Placemark? {
        guard let name = clplacemark.name else { return nil }
        
        let predicate = NSPredicate(format: "name = %@", name)
        let placemarks = Placemark.get(predicate: predicate)
        if let placemark = placemarks.first {
            return placemark
        }
        
        let placemark = Placemark.insert()
        placemark.parse(clplacemark)
        return placemark
    }
    
    private func parse(clplacemark: CLPlacemark) {
        name = clplacemark.name
        country = clplacemark.country
        province = clplacemark.administrativeArea
        subProvince = clplacemark.subAdministrativeArea
        city = clplacemark.locality
        subCity = clplacemark.subLocality
        street = clplacemark.thoroughfare
        subStreet = clplacemark.subThoroughfare
        postalCode = clplacemark.postalCode
    }
}

extension Placemark: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return firstPin.coordinate
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return "\(pins.count) times"
    }
    
    var firstPin: Pin! {
        let pins = Array(self.pins)
        return pins.sort { $0.creationDate < $1.creationDate }.first!
    }
    
    func openInMaps() {
        firstPin.openInMaps()
    }
}

extension NSPredicate {
    convenience init(placemarkFromRegion region: MKCoordinateRegion) {
        self.init(
            format: "Any %@ < pins.latitude AND Any pins.latitude < %@ AND Any %@ < pins.longitude AND Any pins.longitude < %@",
            region.minLatitude.toNumber,
            region.maxLatitude.toNumber,
            region.minLongitude.toNumber,
            region.maxLongitude.toNumber
        )
    }
}