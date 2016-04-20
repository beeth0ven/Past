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
        
        if visit.option == .Visit {
            let predicate = NSPredicate(format: " date = %@ ", visit.arrivalDate)
            let stays = Stay.get(predicate: predicate)
            if let stay = stays.first {
                stay.update(visit: visit)
                return stay
            }
        }
        
        let stay = Stay.insert(inContext: context)
        stay.update(visit: visit)
        print("Stay: \(stay.coordinate)")
        return stay
    }
    
    func update(visit visit: CLVisit) {
        latitude = visit.coordinate.chineseLatitude
        longitude = visit.coordinate.chineseLongitude
        arrivalDate = visit.arrivalDate
        departureDate = visit.departureDate
    }
    
    override var title: String? {
        let date = departureDate != NSDate.distantFuture() ? departureDate! : NSDate()
        let timeInterval = date.timeIntervalSinceDate(arrivalDate!)
        return arrivalDate!.detail + " ~~ " + departureDate!.detail + "  " + timeInterval.timeText
    }
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        date = NSDate()
    }
}
