//
//  Weather.swift
//  Past
//
//  Created by luojie on 16/5/2.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import SwiftOpenWeatherMapAPI


enum Weather: String, CustomStringConvertible {
    case Clear
    case Clouds
    case Rain
    case Snow
    
    var description: String {
        switch self {
        case Clear:  return "☀️"
        case Clouds: return "☁️"
        case Rain:   return "⛈"
        case Snow:   return "❄️"
        }
    }
}