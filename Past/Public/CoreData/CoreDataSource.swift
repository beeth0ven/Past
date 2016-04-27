//
//  CoreDataSource.swift
//  Past
//
//  Created by luojie on 16/4/7.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import CoreData

class CoreDataSource<CL: UITableViewCell ,MO: NSManagedObject>: NSObject, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    weak var tableView: UITableView! { didSet { tableView.dataSource = self; tableView.delegate = self } }
    var configureCellForObject: ((CL, MO) -> Void)?
    var didSelectObject: (MO -> Void)?

    func setup(predicate
        predicate: NSPredicate? = nil,
        sortOption: NSSortDescriptor.Option? = .By(key: "creationDate", ascending: false),
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
        do {
            try fetchedResultsController?.performFetch()
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
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
        let cell = tableView.dequeueReusableCellWithType(CL)!
        configureCellForObject?(cell, object)
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let object = fetchedResultsController!.objectAtIndexPath(indexPath) as! NSManagedObject
            object.delete()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object = fetchedResultsController!.objectAtIndexPath(indexPath) as! MO
        didSelectObject?(object)
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
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Update:
            let object = fetchedResultsController!.objectAtIndexPath(indexPath!) as! MO
            guard let cell = tableView.cellForRowAtIndexPath(indexPath!) as? CL else { return }
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




