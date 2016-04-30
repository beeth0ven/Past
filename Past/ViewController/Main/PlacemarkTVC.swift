//
//  PlacemarkTVC.swift
//  Past
//
//  Created by luojie on 16/4/30.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit

class PlacemarkTVC: AutoDeselectTableViewController {
    
    var plackmark: Placemark!
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var provinceLabel: UILabel!
    @IBOutlet private weak var subProvinceLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var subCityLabel: UILabel!
    @IBOutlet private weak var streetLabel: UILabel!
    @IBOutlet private weak var subStreetLabel: UILabel!
    @IBOutlet private weak var postalCodeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        nameLabel.text = plackmark.name
        countryLabel.text = plackmark.country
        provinceLabel.text = plackmark.province
        subProvinceLabel.text = plackmark.subProvince
        cityLabel.text = plackmark.city
        subCityLabel.text = plackmark.subCity
        streetLabel.text = plackmark.street
        subStreetLabel.text = plackmark.subStreet
        postalCodeLabel.text = plackmark.postalCode
    }
}
