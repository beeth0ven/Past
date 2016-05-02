//
//  Foundation+.swift
//  Past
//
//  Created by luojie on 16/4/6.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation

extension Int {
    var toNumber: NSNumber {
        return NSNumber(integer: self)
    }
}

extension Double {
    var toNumber: NSNumber {
        return NSNumber(double: self)
    }
}

extension Bool {
    var toNumber: NSNumber {
        return NSNumber(bool: self)
    }
}

extension String {
    var trimedString: String {
        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}

extension Dictionary {
    
    func map<TK, TV>(@noescape transform: (Key, Value) -> (TK, TV) ) -> [TK: TV] {
        var result = [TK: TV]()
        for (key, value) in self {
            let (transformedKey, transformedValue) = transform(key, value)
            result[transformedKey] = transformedValue
        }
        return result
        
    }
    
    func flatMap<TK, TV>(@noescape transform: (Key, Value) -> (TK, TV)? ) -> [TK: TV] {
        var result = [TK: TV]()
        for (key, value) in self {
            if let (transformedKey, transformedValue) = transform(key, value) {
                result[transformedKey] = transformedValue
            }
        }
        return result
    }
    
}
