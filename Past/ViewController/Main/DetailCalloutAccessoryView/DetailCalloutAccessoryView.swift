//
//  DetailCalloutAccessoryView.swift
//  Past
//
//  Created by luojie on 16/4/24.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import CoreData
import UberRides

class DetailCalloutAccessoryView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    
    var didSelectAppleMap: (() -> Void)?
    
    @IBAction func openWithAppleMap() {
        didSelectAppleMap?()
    }
}
