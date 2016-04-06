//
//  RxCocoa+.swift
//  Past
//
//  Created by luojie on 16/4/6.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension NSObject {
    var disposeBag: DisposeBag {
        if let result = objc_getAssociatedObject(self, &AssociatedKeys.DisposeBag) as? DisposeBag {
            return result
        }
        let result = DisposeBag()
        objc_setAssociatedObject(self, &AssociatedKeys.DisposeBag, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return result
    }
}

private struct AssociatedKeys {
    static var DisposeBag = "DisposeBag"
}

