//
//  WeatherHandlerType.swift
//  Past
//
//  Created by luojie on 16/5/2.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import SwiftOpenWeatherMapAPI
import MapKit

protocol WeatherHandlerType { }

extension WeatherHandlerType where Self: NSObject {
    
    var weatherManager: WAPIManager {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let manager = objc_getAssociatedObject(appDelegate, &AssociatedKeys.WeatherManager) as? WAPIManager {
            return manager
        }
        let manager = WAPIManager(apiKey: "25c2cd40dfd591fde49b1b96a9bea3c4", temperatureFormat: .Celsius)
        objc_setAssociatedObject(appDelegate, &AssociatedKeys.WeatherManager, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return manager
    }
    
    func getCurrentWeatherForCoordinate(coordinate: CLLocationCoordinate2D, didGet: (Weather?) -> Void) {
        weatherManager.currentWeatherByCoordinatesAsJson(coordinate) { result in
            switch result {
            case .Success(let json):
                let weather = Weather(rawValue: json["weather"][0]["main"].stringValue)
                didGet(weather)
                
            case .Error(let errorText):
                didGet(nil); print(errorText)
            }
        }
    }
}

private struct AssociatedKeys {
    static var WeatherManager = "WeatherManager"
}
