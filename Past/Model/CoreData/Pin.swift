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
    
    static func insert(location location: CLLocation ,inContext context: NSManagedObject.Context = .Main) -> Pin? {
        
        let pin = Pin.insert(inContext: context)
        pin.coordinate = location.coordinate.toMap
        pin.creationDate = location.timestamp
        print("Pin: \(pin.coordinate)")
        return pin
    }
    
    static func getFromCoordinate(coordinate: CLLocationCoordinate2D, inContext context: NSManagedObject.Context = .Main) -> Pin {

        let predicate = NSPredicate(aroundCoordinate: coordinate)
        let matches = Pin.get(predicate: predicate, context: context)
        if matches.count > 0 {
            return matches.sort(>).first!
        } else {
            let pin = Pin.insert(inContext: context)
            pin.coordinate = coordinate
            return pin
        }
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
            getPlaceInfoIfNeeded()
        }
    }
    
    func getPlaceInfoIfNeeded() {
        if placeInfo == nil {
            CLGeocoder.getPlacemarksFrom(
                annotation: self,
                didGet:  { [weak self] placemarks in
                    guard let placemark = placemarks.first else { return }
                    self?.placeInfo = PlaceInfo.insert(placemark: placemark)
                }
            )
        }
    }
    
    var title: String? {
        switch option {
        case .Stay:
            return placeInfo?.name
        case .Transition:
            return creationDate!.detail
        }
    }
    
}

func >(left: Pin, right: Pin) -> Bool {
    guard let leftStayPeriods = left.stayPeriods,
        rightStayPeriods = right.stayPeriods else { return true }
    return leftStayPeriods.count > rightStayPeriods.count
}
