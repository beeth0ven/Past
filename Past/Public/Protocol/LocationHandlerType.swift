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

protocol LocationHandlerType {
    func didUpdateLocations(locations: [CLLocation])
}

extension LocationHandlerType where Self: NSObject {
    var locationManager: CLLocationManager {
        if let manager = objc_getAssociatedObject(self, &AssociatedKeys.LocationManager) as? CLLocationManager {
            return manager
        }
        let manager = CLLocationManager()
        manager.rx_didUpdateLocations
            .subscribeNext { [unowned self] locations in
                self.didUpdateLocations(locations)
            }
            .addDisposableTo(disposeBag)
        manager.distanceFilter = 20
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        objc_setAssociatedObject(self, &AssociatedKeys.LocationManager, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return manager
    }
    
    func locationHandleApplicationDidFinishLaunchingWithOptions(launchOptions: [NSObject: AnyObject]?) {
        if launchOptions?[UIApplicationLaunchOptionsLocationKey] != nil {
            locationManager.startMonitoringSignificantLocationChanges()
        } else {
            locationManager.startUpdatingLocation()
            
        }
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
