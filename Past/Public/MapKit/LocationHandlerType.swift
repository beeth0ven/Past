//
//  LocationHandlerType.swift
//  Past
//
//  Created by luojie on 16/4/7.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit

struct LocationConstants {
    static let distanceFilter = 100.0
}

protocol LocationHandlerType { }

extension LocationHandlerType where Self: NSObject {
    var locationManager: CLLocationManager {
        if let manager = objc_getAssociatedObject(self, &AssociatedKeys.LocationManager) as? CLLocationManager {
            return manager
        }
        let manager = CLLocationManager()
        objc_setAssociatedObject(self, &AssociatedKeys.LocationManager, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return manager
    }
    
    func getVisit(didGet didGet: (CLVisit) -> Void) {
        locationManager.rx_didVisit
            .subscribeNext(didGet)
            .addDisposableTo(disposeBag)
        locationManager.requestAlwaysAuthorizationIfNeeded()
        locationManager.startMonitoringVisits()
    }
    
    func getLocations(didGet didGet: ([CLLocation]) -> Void) {
        locationManager.rx_didUpdateLocations
            .subscribeNext(didGet)
            .addDisposableTo(disposeBag)
        locationManager.requestAlwaysAuthorizationIfNeeded()
        locationManager.stopUpdatingLocation()
    }
    
    func backgrounUpdateLocationIfAvailable() {
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            locationManager.stopUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        } else {
            print("Significant location change monitoring is not available.")
        }
    }
    
    func foregrounUpdateLocationIfAvailable() {
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            locationManager.stopMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
        } else {
            print("Significant location change monitoring is not available.")
        }
    }
}

private struct AssociatedKeys {
    static var LocationManager = "LocationManager"
}
