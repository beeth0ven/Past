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

extension NSNotification {
    enum Identifier: String {
        case ManagedObjectContextDidChange
    }
}

extension NSNotification.Identifier {
    func post(object object: AnyObject? = nil) {
        NSNotificationCenter.defaultCenter()
            .postNotificationName(rawValue, object: object)
    }
    
    func observe(disposeBag disposeBag: DisposeBag, didReceiveNotification: (NSNotification) -> Void){
        NSNotificationCenter.defaultCenter()
            .rx_notification(rawValue)
            .subscribeNext(didReceiveNotification)
            .addDisposableTo(disposeBag)
    }
}

extension NSObject {
    func postNotificationWithIdentifier(identifier: NSNotification.Identifier) {
        identifier.post(object: self)
    }
    
    func observeForIdentifier(identifier: NSNotification.Identifier, didReceiveNotification: (NSNotification) -> Void) {
        identifier.observe(disposeBag: disposeBag, didReceiveNotification: didReceiveNotification)
    }
}
