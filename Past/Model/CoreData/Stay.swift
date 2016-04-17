//
//  Stay.swift
//  Past
//
//  Created by luojie on 16/4/17.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData
import MapKit


class Stay: Pin {

    static func insert(visit visit: CLVisit ,inContext context: NSManagedObject.Context = .Main) -> Stay {

        let stay = Stay.insert(inContext: context)
        stay.latitude = visit.coordinate.chineseLatitude
        stay.longitude = visit.coordinate.chineseLongitude
        stay.date = visit.date
        stay.option = visit.option
        print("Stay: \(stay.coordinate)")
        return stay
    }
    
    override var title: String? {
        return date!.detail + "--" + option.description
    }
}

extension Stay {
    var option: CLVisit.Option {
        get { return CLVisit.Option(rawValue: optionRawValue!.integerValue)! }
        set { optionRawValue = newValue.rawValue }
    }
}
