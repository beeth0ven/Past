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
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LocationHandlerType, CoreDataHanderType {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupCoreData { [unowned self] in self.locationManager.startUpdatingLocation() }
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        backgrounUpdateLocationIfAvailable()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
       foregrounUpdateLocationIfAvailable()
    }
    
    func didUpdateLocations(locations: [CLLocation]) {
        Pin.insert(location: locations.last!)
    }
}
