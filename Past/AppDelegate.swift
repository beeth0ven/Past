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
import UberRides

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LocationHandlerType, CoreDataHandlerType, WeatherHandlerType {
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Configuration.setRegion(.China)
        Configuration.setSandboxEnabled(true)
        setupLocationService()
        
        return true
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        saveManagedObjectContext()
        performCoreDataBackgroundTask()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        saveManagedObjectContext()
    }
    
}


