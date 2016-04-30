//
//  PinViewController.swift
//  Past
//
//  Created by luojie on 16/4/28.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit

class PinTableViewController: AutoDeselectTableViewController {
    
    var pin: Pin!
    
    @IBOutlet weak var regioNameLabel: UILabel!
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
        regioNameLabel.text = pin.region?.name ?? "Empty"
        placemarkNameLable.text = pin.placemark?.name
        
        dateLabel.text = period?.arrivalDate?.string(dateStyle: .FullStyle, timeStyle: .NoStyle)
        arrivalTimeLabel.text = period?.arrivalDate?.detail
        departureTimeLabel.text = period?.departureDate?.detail
        timeIntervalLabel.text = period?.timeIntervalText
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditeRegionName" {
            let esttvc = segue.destinationViewController as! EditeSingleTextTVC
            prepareEditeSingleTextTVCForRegionName(esttvc)
        } else if segue.identifier == "ShowPlacemark" {
            let ptvc = segue.destinationViewController as! PlacemarkTVC
            ptvc.plackmark = pin.placemark
        }
    }
    
    private func prepareEditeSingleTextTVCForRegionName(editeSingleTextTVC: EditeSingleTextTVC) {
        editeSingleTextTVC.keyDisplayName = "Region Name"
        editeSingleTextTVC.value = pin.region?.name
        editeSingleTextTVC.placeholder = "Please Enter a Name!"
        editeSingleTextTVC.didEdite = {
            [unowned self] value in
            switch (self.pin.region, value) {
            case (let region?, let text) where text.isEmpty:
                region.delete()
                print("Remove Region On Pin.")
            case (let region?, let text):
                region.name = text
                print("Rename Region On Pin.")
            case (nil, let text) where text.isEmpty:
                break
            case (nil, let text):
                Region.insertForName(text, coordinate: self.pin.coordinate)
                print("Add Region On Pin.")
            }
            self.regioNameLabel.text = self.pin.region?.name ?? "Empty"

        }
    }
}
