//
//  CoreDataHanderType.swift
//  Past
//
//  Created by luojie on 16/4/7.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataHanderType {}

extension CoreDataHanderType where Self: NSObject {
    /// Need unowned self in didSetup Closure
    func setupCoreData(didSetup didSetup: () -> Void) {
        NSManagedObject.Context.createContextIfNeeded()
        observeForIdentifier(.ManagedObjectContextDidChange, didReceiveNotification: { _ in didSetup() })
    }
}

