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

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    private let dateSource = CoreDataSource<UITableViewCell, Pin>()
    private let mapDelegate = CoreDataMapDelegate<MKPinAnnotationView, Pin>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDateSource()
        setupMapDelegate()
        reloadData()
    }
    
    private func setupDateSource() {
        dateSource.tableView = tableView
        dateSource.configureCellForObject = { cell, pin in
            cell.detailTextLabel?.text = pin.coordinate.description
            cell.textLabel?.text = pin.date?.detail
        }
    }
    
    private func setupMapDelegate() {
        mapDelegate.mapView = mapView
        mapDelegate.configureViewForObject = { view, pin in
            view.canShowCallout = true
            view.draggable = true
            view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            view.rightCalloutAccessoryView?.tintColor = UIColor.redColor()
        }
        mapDelegate.didSelectCalloutAccessoryView = { _, pin in
            pin.delete()
        }
    }
    
    private func reloadData() {
        print(#function)
        dateSource.setup(sortOption: .By(key: "date", ascending: false))
        reloadMapView()
    }
    
    @IBAction func addPin(sender: UIBarButtonItem) {
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        reloadMapView()
    }
    
    private func reloadMapView() {
        let date = NSDate(timeIntervalSinceNow: -12*60*60)
        let predicate = NSPredicate(format: "date > %@", date)
        mapDelegate.setup(
            predicate: predicate,
            sortOption: .By(key: "date", ascending: false)
        )
    }
    


}


extension NSDate {
    var detail: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .MediumStyle
        return dateFormatter.stringFromDate(self)
    }
}
