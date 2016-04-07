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
        
        private static var mainContext: NSManagedObjectContext!
        private static var backgroundContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        
        static func getConext(didGet didGet: () -> Void) {
            if NSManagedObject.Context.mainContext != nil {
                return didGet()
            }
            
            var url = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
            url = url.URLByAppendingPathComponent("CoreDataDocument")
            let document = UIManagedDocument(fileURL: url)
            if !NSFileManager.defaultManager().fileExistsAtPath(url.path!) {
                document.saveToURL(url, forSaveOperation: .ForCreating, completionHandler: { _ in
                    print("CoreDataDocument saveToURL")
                    NSManagedObject.Context.mainContext = document.managedObjectContext
                    didGet()
                    
                })
            } else if document.documentState == UIDocumentState.Closed {
                document.openWithCompletionHandler({ _ in
                    print("CoreDataDocument openWithCompletionHandler")
                    NSManagedObject.Context.mainContext = document.managedObjectContext
                    didGet()
                })
            } else {
                print("CoreDataDocument is opened")
                NSManagedObject.Context.mainContext = document.managedObjectContext
                didGet()
            }
        }
        
    }
}



class CoreDataSource<CL: UITableViewCell ,MO: NSManagedObject>: NSObject, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    weak var tableView: UITableView! { didSet { tableView.dataSource = self; tableView.delegate = self } }
    
    var configureCellForObject:    ((CL, MO) -> Void)?
    
    
    func setup(predicate
        predicate: NSPredicate? = nil,
        sortOption: NSSortDescriptor.Option? = nil,
        context: NSManagedObject.Context = .Main
        ) {
        
        let request = NSFetchRequest(MO)
        request.predicate = predicate
        request.sortDescriptors = sortOption.flatMap { [$0.sortDescriptor] }
        request.fetchBatchSize = 20

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context.value,
            sectionNameKeyPath: nil,
            cacheName: nil)
        try! fetchedResultsController?.performFetch()
        tableView.reloadData()
    }
    
    private var fetchedResultsController: NSFetchedResultsController? { didSet { fetchedResultsController?.delegate = self } }

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
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        print(#function)
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Update:
            let object = fetchedResultsController!.objectAtIndexPath(indexPath!) as! MO
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! CL
            configureCellForObject?(cell, object)
        case .Move:
            tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}










