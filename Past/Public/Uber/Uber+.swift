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
    convenience init(dropoffCoordinate: CLLocationCoordinate2D, address: String? = nil) {
        self.init()
        requestBehavior = DeeplinkRequestingBehavior()
        colorStyle = .White
        
        let parameterBuilder = RideParametersBuilder()
        parameterBuilder.setProductID(NSUUID().UUIDString)
        parameterBuilder.setPickupToCurrentLocation()
        let dropoffLocation = CLLocation(coordinate: dropoffCoordinate)
        parameterBuilder.setDropoffLocation(dropoffLocation, address: address)
        
        rideParameters = parameterBuilder.build()
    }
}