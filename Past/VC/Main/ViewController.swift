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

class ViewController: UIViewController, LocationHandlerType {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let dateSource = CoreDataSource<UITableViewCell, Pin>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCoreData()
        setupDateSource()
    }
    
    private func setupCoreData() {
        NSManagedObject.Context.getConext { [weak self] in
            self?.reloadData()
            self?.startUpdatingLocation { Pin.insert(location: $0) }
        }
    }
    
    private func setupDateSource() {
        dateSource.tableView = tableView
        dateSource.configureCellForObject = { cell, pin in
            cell.textLabel?.text = pin.date?.description
        }
    }
    
    private func reloadData() {
        print(#function)
        dateSource.setup(sortOption: .By(key: "date", ascending: false))
    }
    
    @IBAction func addPin(sender: UIBarButtonItem) {
        Pin.insert()
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        Pin.get(
            sortOption: .By(key: "date", ascending: false),
            didGet: { pins in
                pins.forEach { print("pin date: \($0.date!)") }
                print("pin count: \(pins.count)")
                
        })
    }
    
}
