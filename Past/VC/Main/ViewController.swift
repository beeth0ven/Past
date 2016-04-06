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
        
        observe(
            identifier: .ManagedObjectContextDidChange,
            didReceiveNotification: { (_) in
                print("UpdateUI")
        })
    }
    
    @IBAction func addPin(sender: UIBarButtonItem) {
        Pin.insert()
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        let request = NSFetchRequest(Pin)
        let pins = try! request.execute()
        
        print("pin count: \(pins.count)")
    }
    
}
