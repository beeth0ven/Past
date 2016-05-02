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
                case .Departure:
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
}

private struct AssociatedKeys {
    static var LocationManager = "LocationManager"
}
