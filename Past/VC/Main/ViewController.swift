//
//  ViewController.swift
//  Past
//
//  Created by luojie on 16/3/30.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

class ViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        AppDelegate.locationManager.requestAlwaysAuthorization()
        
        AppDelegate.locationManager.rx_didUpdateLocations
        .subscribeNext { lcations in
            print("rx_didUpdateLocations: \(lcations.last!.coordinate)")
        }
        .addDisposableTo(disposeBag)
        
        AppDelegate.locationManager.startUpdatingLocation()
    }
        
}

