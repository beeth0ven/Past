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
class AppDelegate: UIResponder, UIApplicationDelegate, LocationHandlerType, CoreDataHandlerType {
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Configuration.setRegion(.China)
        Configuration.setSandboxEnabled(true)

        monitoringVisit(didMonitor: { Period.updateFromVisit($0) })
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
