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
    
    private let dateSource = CoreDataSource<UITableViewCell, Stay>()
    private let mapDelegate = CoreDataMapDelegate<MKPinAnnotationView, Stay>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDateSource()
        setupMapDelegate()
        reloadData()
    }
    
    private func setupDateSource() {
        dateSource.tableView = tableView
        dateSource.configureCellForObject = { cell, stay in
            cell.textLabel?.text = stay.title
            cell.detailTextLabel?.text = stay.subtitle
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
        mapDelegate.didSelectCalloutAccessoryView = { _, stay in
            stay.delete()
        }
    }
    
    private func reloadData() {
        reloadTableView()
        reloadMapView()
    }
    
    @IBAction func addPin(sender: UIBarButtonItem) {
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        reloadData()
    }
    
    private func reloadTableView() {
        dateSource.setup()
    }
    
    private func reloadMapView() {
        let date = NSDate(timeIntervalSinceNow: -0.5.days)
        let predicate = NSPredicate(format: "date > %@", date)
        mapDelegate.setup(predicate: predicate)
    }
}


