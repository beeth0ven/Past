//
//  AppDelegate.swift
//  Past
//
//  Created by luojie on 16/3/30.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LocationHandlerType {

    var window: UIWindow?

    static let alocationManager = CLLocationManager()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        backgrounUpdateLocationIfAvailable()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
       foregrounUpdateLocationIfAvailable()
    }
}

protocol LocationHandlerType { }
extension LocationHandlerType where Self: NSObject {
    var locationManager: CLLocationManager {
        return AppDelegate.alocationManager
    }
    
    func startUpdatingLocation(didUpdate:(CLLocation) -> Void) {
        locationManager.requestAlwaysAuthorization()
        
        locationManager.rx_didUpdateLocations
            .subscribeNext { lcations in
                didUpdate(lcations.last!)
            }
            .addDisposableTo(disposeBag)
        
        locationManager.startUpdatingLocation()
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
