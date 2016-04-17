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
class AppDelegate: UIResponder, UIApplicationDelegate, LocationHandlerType, CoreDataHandlerType {
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        monitoringVisit(didMonitor: { Stay.insert(visit: $0) })
        return true
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        saveManagedObjectContext()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        saveManagedObjectContext()
    }
    
}
