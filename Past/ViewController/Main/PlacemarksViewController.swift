//
//  PlacemarksViewController.swift
//  Past
//
//  Created by luojie on 16/5/22.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit
import CoreData
import UberRides

class PlacemarksViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let dateSource = CoreDataSource<UITableViewCell, Placemark>()
    private let mapDelegate = CoreDataMapDelegate<MKPinAnnotationView, Placemark>()
    
    @IBOutlet weak var mapViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapViewEqualHeightConstraint: NSLayoutConstraint!
    
    private var showMapView: Bool {
        get { return mapViewEqualHeightConstraint.active == true }
        set(show) {
            if show != showMapView {
                mapViewEqualHeightConstraint.active = show
                mapViewBottomConstraint.active = !show
                view.animatedRelayout()
            }
        }
    }
    
    private var predicate: NSPredicate {
        let predicate = NSPredicate(format: "pins.@count > 0")
        if let searchString = searchBar.text where !searchString.isEmpty {
            return  NSPredicate(format: "name contains[cd] %@", searchString) && predicate
        } else {
            return predicate
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOberver()
        setupDateSource()
        setupMapDelegate()
        configureSearchBar()
        configureMapView()
        reloadData()
    }
    
    private func setupOberver() {
        observeForName(UIApplicationDidBecomeActiveNotification) { [unowned self] _ in
            self.dateSource.updateVisibleCells()
        }
    }
    
    private func setupDateSource() {
        dateSource.tableView = tableView
        dateSource.configureCellForObject = { cell, placemark in
            cell.textLabel?.text = placemark.title
            cell.detailTextLabel?.text = placemark.subtitle
        }
    }
    
    private func setupMapDelegate() {
        mapDelegate.mapView = mapView
        mapDelegate.configureViewForObject = { [unowned self] view, placemark in
            view.canShowCallout = true
            view.detailCalloutAccessoryView = self.detailCalloutAccessoryViewForPlacemarkplacemark(placemark)
        }
        mapDelegate.showPolyline = false
    }
    
    private func configureSearchBar() {
        
        searchBar
            .rx_text
            .subscribeNext { [unowned self] _ in self.reloadTableView() }
            .addDisposableTo(disposeBag)
        
        searchBar
            .rx_searchButtonClicked
            .subscribeNext { [unowned self] in self.searchBar.resignFirstResponder() }
            .addDisposableTo(disposeBag)
        
        searchBar
            .rx_cancelButtonClicked
            .subscribeNext { [unowned self] in self.searchBar.resignFirstResponder() }
            .addDisposableTo(disposeBag)
    }
    
    private func configureMapView() {
        observeForName(UIKeyboardWillShowNotification) { [unowned self] _ in
            self.showMapView = false
            self.searchBar.setShowsCancelButton(true, animated: true)
        }
        
        observeForName(UIKeyboardWillHideNotification) { [unowned self] _ in
            self.showMapView = true
            self.searchBar.setShowsCancelButton(false, animated: true)
        }
        
        observeForName(UIKeyboardDidHideNotification) { [unowned self] _ in
            self.reloadMapView()
        }
    }
    
    private func detailCalloutAccessoryViewForPlacemarkplacemark(placemark: Placemark) -> DetailCalloutAccessoryView {
        let detailCalloutAccessoryView = DetailCalloutAccessoryView.viewFromNib()!
        detailCalloutAccessoryView.didSelectAppleMap = { placemark.openInMaps() }
        let unberButton = RideRequestButton(dropoffCoordinate: placemark.coordinate, address: placemark.name)
        detailCalloutAccessoryView.stackView.addArrangedSubview(unberButton)
        return detailCalloutAccessoryView
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        reloadData()
    }
    
    private func reloadData() {
        reloadTableView()
        reloadMapView()
    }
    
    private func reloadTableView() {
        dateSource.setup(predicate: predicate, sortOption: .By(key: "name", ascending: true))
    }
    
    private func reloadMapView() {
        mapDelegate.setup(predicate: predicate)
    }
}
