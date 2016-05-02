//
//  Date+.swift
//  Past
//
//  Created by luojie on 16/5/2.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation

extension NSDate {
    var detail: String {
        switch self {
        case NSDate.distantPast():
            return "Past"
        case NSDate.distantFuture():
            return "Now"
        default:
            return string(dateStyle: .NoStyle, timeStyle: .ShortStyle)
        }
    }
    
    func string(dateStyle dateStyle: NSDateFormatterStyle, timeStyle: NSDateFormatterStyle) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
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
    
    var timeText: String {
        switch self {
        case 0..<1.0.minutes:
            return String(format: "%i seconds", Int(self))
        case 1.0.minutes..<1.0.hours:
            return String(format: "%i minutes", Int(self/1.0.minutes))
        case 1.0.hours..<1.0.days:
            return String(format: "%.1f hours", self/1.0.hours)
        default:
            return String(format: "%.1f days", self/1.0.days)
        }
    }
}

extension NSDate: Comparable {}

public func ==(left: NSDate, right: NSDate) -> Bool {
    return left.timeIntervalSince1970 == right.timeIntervalSince1970
}
public func <(left: NSDate, right: NSDate) -> Bool {
    return left.timeIntervalSince1970 < right.timeIntervalSince1970
}


