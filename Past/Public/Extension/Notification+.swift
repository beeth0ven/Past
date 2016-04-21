//
//  Notification+.swift
//  Past
//
//  Created by luojie on 16/4/6.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

let ManagedObjectContextDidChangeNotification = "ManagedObjectContextDidChangeNotification"

extension NSObject {

    func postNotificationForName(name: String) {
        NSNotificationCenter.defaultCenter()
            .postNotificationName(name, object: self)
    }
    
    func observeForName(name: String, didReceiveNotification: (NSNotification) -> Void) {
        NSNotificationCenter.defaultCenter()
            .rx_notification(name)
            .subscribeNext(didReceiveNotification)
            .addDisposableTo(disposeBag)
    }
}

extension NSNotification {
    func post() {
        NSNotificationCenter
        .defaultCenter()
        .postNotification(self)
    }
}