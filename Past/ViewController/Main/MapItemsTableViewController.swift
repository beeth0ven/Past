//
//  MapItemsTableViewController.swift
//  Past
//
//  Created by luojie on 16/4/24.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import MapKit

class MapItemsTableViewController: UITableViewController {
    
    var pin: Pin!
    
    private var mapItems = [MKMapItem]() { didSet { tableView.reloadData() } }
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var currentMapItemLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mapItem = MKMapItem.mapItemForCurrentLocation()
        currentMapItemLabel.text = "Current: \(mapItem.name)"
    }
    
    private var searchText : String {
        get { return searchTextField.text ?? "" }
        set { searchTextField.text = newValue }
    }
    
    private func search() {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            
         request.region = MKCoordinateRegion(center: pin.coordinate, span: span)
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler { [weak self] (response, error) in
            guard error == nil else {
                return print(error!.localizedDescription)
            }
            
            self?.mapItems = response!.mapItems
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mapItem = mapItems[indexPath.row]
        let cell = tableView.dequeueReusableCellWithType(UITableViewCell)!
        cell.textLabel?.text = mapItem.name
        cell.detailTextLabel?.text = mapItem.phoneNumber
        return cell
    }
    
}

extension MapItemsTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        search()
        return true
    }
}