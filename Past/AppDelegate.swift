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
class AppDelegate: UIResponder, UIApplicationDelegate, LocationHandable, DisposeBagHasable {

    var window: UIWindow?

    static let alocationManager = CLLocationManager()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.rx_didUpdateLocations
            .subscribeNext { lcations in
                print("Past: \(lcations.last!.coordinate)")
            }
            .addDisposableTo(disposeBag)
        
        locationManager.startUpdatingLocation()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            locationManager.stopUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        } else {
            print("Significant location change monitoring is not available.")
        }
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            locationManager.stopMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
        } else {
            print("Significant location change monitoring is not available.")
        }
    }
}

protocol LocationHandable { }
extension LocationHandable {
    var locationManager: CLLocationManager {
        return AppDelegate.alocationManager
    }
}

protocol DisposeBagHasable { }
extension DisposeBagHasable where Self: NSObject {
    var disposeBag: DisposeBag {
        if let bag = objc_getAssociatedObject(self, &AssociatedKeys.DisposeBag) as? DisposeBag {
            return bag
        }
        let bag = DisposeBag()
        objc_setAssociatedObject(self, &AssociatedKeys.DisposeBag, bag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return bag
    }
}

private struct AssociatedKeys {
    static var DisposeBag = "DisposeBag"
}
