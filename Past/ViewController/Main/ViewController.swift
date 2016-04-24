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
import CoreData
import UberRides

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    private let dateSource = CoreDataSource<UITableViewCell, Period>()
    private let mapDelegate = CoreDataMapDelegate<MKPinAnnotationView, Pin>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDateSource()
        setupMapDelegate()
        reloadData()
    }
    
    private func setupDateSource() {
        dateSource.tableView = tableView
        dateSource.configureCellForObject = { cell, period in
            cell.textLabel?.text = period.title
            cell.detailTextLabel?.text = period.subTitle
        }
        dateSource.didSelectObject = { [unowned self] period in
            let predicate = NSPredicate(format: "%@ IN stayPeriods", period)
            self.mapDelegate.setup(predicate: predicate)
        }
    }
    
    private func setupMapDelegate() {
        mapDelegate.mapView = mapView
        mapDelegate.configureViewForObject = { view, pin in
            view.canShowCallout = true
            view.draggable = true
            view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            view.detailCalloutAccessoryView = RideRequestButton(dropoffCoordinate: pin.coordinate)
        }
        mapDelegate.didSelectCalloutAccessoryView = {  _, pin in
        }
    }
  
    @IBAction func addPin(sender: UIBarButtonItem) {
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        reloadData()
    }
    
    private func reloadData() {
        reloadTableView()
        reloadMapView()
    }
    
    private func reloadTableView() {
        dateSource.setup()
    }
    
    private func reloadMapView() {
        let date = NSDate(timeIntervalSinceNow: -1.0.days)
        let predicate = NSPredicate(format: "creationDate > %@ AND optionRawValue = %@", date, Period.Option.Stay.rawValue.toNumber)
        mapDelegate.setup(predicate: predicate)
    }
}




