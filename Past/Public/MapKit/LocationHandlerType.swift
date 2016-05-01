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
    
    func setupLocationService() {
        
        locationManager
            .rx_didVisit
            .subscribeNext { [unowned self] visit in
                switch visit.option {
                case .Arrival:
                    self.locationManager.stopMonitoringSignificantLocationChanges()
                default:
                    self.locationManager.startMonitoringSignificantLocationChanges()
                }
            }
            .addDisposableTo(disposeBag)
        
        locationManager
            .rx_didVisit
            .subscribeNext(Period.updateFromVisit)
            .addDisposableTo(disposeBag)
        
        locationManager
            .rx_didUpdateLocations
            .subscribeNext(Period.updateFromLocations)
            .addDisposableTo(disposeBag)
        
        locationManager.requestAlwaysAuthorizationIfNeeded()
        locationManager.startMonitoringVisits()
    }
    
    func monitoringVisit(didMonitor didMonitor: (CLVisit) -> Void) {
        locationManager.rx_didVisit
            .subscribeNext(didMonitor)
            .addDisposableTo(disposeBag)
        locationManager.requestAlwaysAuthorizationIfNeeded()
        locationManager.startMonitoringVisits()
    }
    
    func updatingLocations(didUpdate didUpdate: ([CLLocation]) -> Void) {
        locationManager.rx_didUpdateLocations
            .subscribeNext(didUpdate)
            .addDisposableTo(disposeBag)
        locationManager.requestAlwaysAuthorizationIfNeeded()
        locationManager.stopUpdatingLocation()
    }
    
    func monitoringSignificantLocationChange(didMonitor didMonitor: (CLLocation) -> Void) {
        locationManager.rx_didUpdateLocations
            .subscribeNext { didMonitor($0.first!) }
            .addDisposableTo(disposeBag)
        locationManager.requestAlwaysAuthorizationIfNeeded()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func stopMonitoringSignificantLocationChanges() {
        locationManager.stopMonitoringSignificantLocationChanges()
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
