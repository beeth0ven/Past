//
//  Context.swift
//  Past
//
//  Created by luojie on 16/4/1.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import CoreData

extension NSManagedObject {
    enum Context {
        case Main, Background
        
        var value: NSManagedObjectContext! {
            switch self {
            case .Main:
                return Context.mainContext
            case .Background:
                return Context.backgroundContext
            }
        }
        
        private static var mainContext: NSManagedObjectContext! { didSet { contextDidChange() } }
        private static var backgroundContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        
        private static func contextDidChange() {
            NSNotification.Identifier.ManagedObjectContextDidChange.post()
        }
        
        static func createContext() {
            var url = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
            url = url.URLByAppendingPathComponent("CoreDataDocument")
            let document = UIManagedDocument(fileURL: url)
            if !NSFileManager.defaultManager().fileExistsAtPath(url.path!) {
                document.saveToURL(url, forSaveOperation: .ForCreating, completionHandler: { _ in
                    print("CoreDataDocument saveToURL")
                    NSManagedObject.Context.mainContext = document.managedObjectContext
                })
            } else if document.documentState == UIDocumentState.Closed {
                document.openWithCompletionHandler({ _ in
                    print("CoreDataDocument openWithCompletionHandler")
                    NSManagedObject.Context.mainContext = document.managedObjectContext
                })
            } else {
                print("CoreDataDocument is opened")
                NSManagedObject.Context.mainContext = document.managedObjectContext
            }
        }
        
    }
}



class CoreDataSource<CL: UITableViewCell ,MO: NSManagedObject>: NSObject, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController? { didSet { fetchedResultsController?.delegate = self } }
    weak var tableView: UITableView! { didSet { tableView.dataSource = self; tableView.delegate = self } }
    
    var configureCellForObject:    ((CL, MO) -> Void)?
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = fetchedResultsController!.objectAtIndexPath(indexPath) as! MO
        let cell = tableView.dequeueReusableCellWithIdentifier(String(CL)) as! CL
        configureCellForObject?(cell, object)
        return cell
    }
    
    
}
