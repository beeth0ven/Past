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
        stay.arrivalDate = visit.arrivalDate
        stay.departureDate = visit.departureDate
        print("Stay: \(stay.coordinate)")
        return stay
    }
    
    override var title: String? {
        return arrivalDate!.detail + " ~~ " + departureDate!.detail
    }
}
