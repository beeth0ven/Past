//
//  Period.swift
//  Past
//
//  Created by luojie on 16/4/21.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Period: RootObject {
    
    enum Option: Int {
        case Stay
        case Transition
    }
    
    static func update(visit visit: CLVisit ,inContext context: NSManagedObject.Context = .Main) {
        
        if visit.option == .Visit {
            let predicate = NSPredicate(format: "arrivalDate = %@", visit.arrivalDate)
            let stays = Period.get(predicate: predicate, context: context)
            if let stay = stays.first {
                stay.stayPin?.coordinate = visit.coordinate.toMap
                stay.departureDate = visit.departureDate
                stay.timeInterval = stay.departureDate!.timeIntervalSinceDate(stay.arrivalDate!)
                return
            }
        }
        
        let period = Period.insert(inContext: context)
        period.stayPin = Pin.getFromCoordinate(visit.coordinate.toMap, inContext: context)
        period.arrivalDate = visit.arrivalDate
        period.departureDate = visit.departureDate
        print("Stay: \(period.stayPin!.coordinate)")
    }
    
    var option: Option {
        get { return Option(rawValue: optionRawValue!.integerValue)! }
        set { optionRawValue = newValue.rawValue }
    }
    

    override func prepareForDeletion() {
        super.prepareForDeletion()
        switch option {
        case .Stay:
            if stayPin?.stayPeriods?.count == 1 {
                stayPin?.delete()
            }
        case .Transition:
            break
        }
    }
}

extension Period {
    var title: String {
         return arrivalDate!.detail + " ~~ " + departureDate!.detail
    }
    
    var subTitle: String {
        let date = departureDate != NSDate.distantFuture() ? departureDate! : NSDate()
        let timeInterval = date.timeIntervalSinceDate(arrivalDate!)
        return timeInterval.timeText
    }
}


