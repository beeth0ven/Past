//
//  Uber+.swift
//  Past
//
//  Created by luojie on 16/4/24.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UberRides
import MapKit

extension RideRequestButton {
    convenience init(dropoffCoordinate: CLLocationCoordinate2D, nickname: String? = nil) {
        self.init()
        requestBehavior = DeeplinkRequestingBehavior()
        colorStyle = .White
        
        let parameterBuilder = RideParametersBuilder()
        parameterBuilder.setProductID(NSUUID().UUIDString)
        let dropoffLocation = CLLocation(coordinate: dropoffCoordinate)
        parameterBuilder.setDropoffLocation(dropoffLocation, nickname: nickname)
        
        rideParameters = parameterBuilder.build()
    }
}