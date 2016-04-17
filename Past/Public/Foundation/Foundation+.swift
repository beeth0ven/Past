//
//  Foundation+.swift
//  Past
//
//  Created by luojie on 16/4/6.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension NSDate {
    var detail: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .MediumStyle
        return dateFormatter.stringFromDate(self)
    }
}

extension NSTimeInterval {
    
    var minutes: NSTimeInterval {
        return self * 60
    }
    
    var hours: NSTimeInterval {
        return self * 60 * 60
    }
    
    var days: NSTimeInterval {
        return self * 24 * 60 * 60
    }
    
    var weeks: NSTimeInterval {
        return self * 7 * 24 * 60 * 60
    }
}