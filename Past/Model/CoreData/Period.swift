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
    
    static func updateFromVisit(visit: CLVisit) {
        let previousPeriod = currentPeriod
        previousPeriod?.markAsCompletedFromVisit(visit)
        let newPeriod = insertFromVisit(visit)
        newPeriod.previous = previousPeriod
        print("previousPeriod:", previousPeriod, "newPeriod", newPeriod)
    }
    
    static func updateFromLocations(locations: [CLLocation]) {
        guard let transionPeriod = currentPeriod
            where transionPeriod.option == .Transition else { return }
        let pins = locations.map(Pin.insertFromLocation)
        pins.forEach { $0.period = transionPeriod }
    }
    
    private static var currentPeriod: Period? {
        let predicate = NSPredicate(format: "isCurrent = %@", true.toNumber)
        return Period.get(predicate: predicate).first
    }
    
    private func markAsCompletedFromVisit(visit: CLVisit) {
        switch option {
        case .Stay:
            stayPin?.coordinate = visit.coordinate.toMap
            departureDate = visit.departureDate
        case .Transition:
            let pin = Pin.insertFromCoordinate(visit.coordinate.toMap, option: .Transition)
            pin.period = self
            departureDate = visit.arrivalDate
        }
        isCurrent = false
        updateTimeInterval()
    }

    private static func insertFromVisit(visit: CLVisit) -> Period {
        let period = Period.insert()
        switch visit.periodOption {
        case .Stay:
            period.option = .Stay
            period.arrivalDate = visit.arrivalDate
            let pin = Pin.insertFromCoordinate(visit.coordinate.toMap, option: .Stay)
            pin.creationDate = period.arrivalDate
            pin.period = period
        case .Transition:
            period.option = .Transition
            period.arrivalDate = visit.departureDate
            let pin = Pin.insertFromCoordinate(visit.coordinate.toMap, option: .Transition)
            pin.creationDate = period.arrivalDate
            pin.period = period
        }
        return period
    }
    
    private func updateTimeInterval() {
        if let
            arrivalDate = arrivalDate,
            departureDate = departureDate where
            arrivalDate != NSDate.distantPast() &&
            departureDate != NSDate.distantFuture() {
            timeInterval = departureDate.timeIntervalSinceDate(arrivalDate)
        }
    }
    
    var option: Option {
        get { return Option(rawValue: optionRawValue!.integerValue)! }
        set { optionRawValue = newValue.rawValue }
    }
    
    var stayPin: Pin? {
        switch option {
        case .Stay:
            return pins?.firstObject as? Pin
        case .Transition:
            return nil
        }
    }
}

extension Period {
    var title: String {
         return arrivalDate!.detail + " ~~ " + departureDate!.detail
    }
    
    var subTitle: String {
        return timeIntervalText
    }
    
    var timeIntervalText: String {
        let date = departureDate != NSDate.distantFuture() ? departureDate! : NSDate()
        let timeInterval = date.timeIntervalSinceDate(arrivalDate!)
        return timeInterval.timeText
    }
}


