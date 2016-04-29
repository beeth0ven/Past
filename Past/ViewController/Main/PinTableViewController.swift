//
//  PinViewController.swift
//  Past
//
//  Created by luojie on 16/4/28.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit

class PinTableViewController: UITableViewController {
    
    var pin: Pin!
    
    @IBOutlet weak var placemarkNameLable: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var timeIntervalLabel: UILabel!
    
    private var period: Period? {
        return pin?.period
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        title = pin.placemark?.name
        placemarkNameLable.text = pin.placemark?.name
        
        dateLabel.text = period?.arrivalDate?.string(dateStyle: .FullStyle, timeStyle: .NoStyle)
        arrivalTimeLabel.text = period?.arrivalDate?.detail
        departureTimeLabel.text = period?.departureDate?.detail
        timeIntervalLabel.text = period?.timeIntervalText
    }
}
