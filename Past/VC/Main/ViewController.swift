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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        NSManagedObject.Context.createContext()
        
        observe(identifier: .ManagedObjectContextDidChange,
                didReceiveNotification: { (_) in
                    print("UpdateUI")
        })
    }
    
    @IBAction func addPin(sender: UIBarButtonItem) {
        Pin.insert()
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        Pin.get(sortOption: .By(key: "date", ascending: false),
                didGet: { pins in
                    pins.forEach { print("pin date: \($0.date!)") }
                    print("pin count: \(pins.count)")
                    
        })
    }
    
}
