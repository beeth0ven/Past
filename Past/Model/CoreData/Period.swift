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

class Period: ManagedObject, WeatherHandlerType {

    static func updateFromVisit(visit: CLVisit) {
        let previousPeriod = currentPeriod
        previousPeriod?.markAsCompletedFromVisit(visit)
        Queue.Main.execute { 
            let newPeriod = insertFromVisit(visit)
            newPeriod.previous = previousPeriod
            print("visit", visit)
            print("previousPeriod:", previousPeriod)
            print("newPeriod", newPeriod)
        }
    }
    
    static func updateFromLocations(locations: [CLLocation]) {
        guard let transionPeriod = currentPeriod
            where transionPeriod.option == .Transition else { return }
        locations
            .filter { $0.timestamp > transionPeriod.arrivalDate }
            .map(Pin.insertFromLocation)
            .forEach { $0.period = transionPeriod }
    }
    
    private static func insertFromVisit(visit: CLVisit) -> Period {
        switch visit.option {
        case .Arrival:
            return insertStayPeriodFromVisit(visit)
        case .Departure:
            return insertTransitionPeriodFromVisit(visit)
        }
    }
    
    private static func insertStayPeriodFromVisit(visit: CLVisit) -> Period {
        let period = Period.insert()
        period.option = .Stay
        period.arrivalDate = visit.arrivalDate
        let pin = Pin.insertFromCoordinate(visit.coordinate.toMap, option: .Stay)
        pin.creationDate = period.arrivalDate
        pin.period = period
        period.updateWeather()
        return period
    }
    
    private static func insertTransitionPeriodFromVisit(visit: CLVisit) -> Period {
        let period = Period.insert()
        period.option = .Transition
        period.arrivalDate = visit.departureDate
        let pin = Pin.insertFromCoordinate(visit.coordinate.toMap, option: .Transition)
        pin.creationDate = period.arrivalDate
        pin.period = period
        period.updateWeather()
        return period
    }
    
    private func updateWeather() {
        guard let coordinate = pins.first?.coordinate else { return }
        getCurrentWeatherForCoordinate(coordinate) { self.weather = $0 }
    }
    
    private static var currentPeriod: Period? {
        let predicate = NSPredicate(format: "isCurrent = YES")
        return Period
            .get(predicate: predicate)
            .sort { $0.creationDate > $1.creationDate }
            .first
    }
    
    private func markAsCompletedFromVisit(visit: CLVisit) {
        switch option {
        case .Stay:
            stayDidFinishFromVisit(visit)
        case .Transition:
            transitionDidFinishFromVisit(visit)
        }
    }
    
    private func stayDidFinishFromVisit(visit: CLVisit) {
        departureDate = visit.departureDate
        stayPin?.coordinate = visit.coordinate.toMap
        isCurrent = false
        updateTimeInterval()
    }
    
    private func transitionDidFinishFromVisit(visit: CLVisit) {
        departureDate = visit.arrivalDate
        let pin = Pin.insertFromCoordinate(visit.coordinate.toMap, option: .Transition)
        pin.creationDate = departureDate
        pin.period = self
        filterBugPins()
        isCurrent = false
        updateTimeInterval()
    }
    
    private func filterBugPins() {
        pins.filter { $0.creationDate > departureDate }
            .forEach { $0.delete() }
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
}

extension Period {
    var title: String {
         return "\(option) \(weather?.description ?? "  ") \(arrivalDate!.detail) ~~ \(departureDate!.detail)"
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
