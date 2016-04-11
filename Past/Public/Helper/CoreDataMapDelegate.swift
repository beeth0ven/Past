//
//  CoreDataMapDelegate.swift
//  Past
//
//  Created by luojie on 16/4/12.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class CoreDataMapDelegate<AV: MKAnnotationView ,MO: NSManagedObject>: NSObject, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    weak var mapView: MKMapView! { didSet { mapView.delegate = self } }
    var configureViewForObject: ((AV, MO) -> Void)?

    func setup(predicate
        predicate: NSPredicate? = nil,
        sortOption: NSSortDescriptor.Option? = nil,
        context: NSManagedObject.Context = .Main
        ) {
        
        let request = NSFetchRequest(MO)
        request.predicate = predicate
        request.sortDescriptors = sortOption.flatMap { [$0.sortDescriptor] }
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context.value,
            sectionNameKeyPath: nil,
            cacheName: nil)
        try! fetchedResultsController?.performFetch()
        mapView.addAnnotations(fetchedResultsController!.fetchedObjects as! [MKAnnotation])
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    private var fetchedResultsController: NSFetchedResultsController? { didSet { fetchedResultsController?.delegate = self } }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        let view = AV(annotation: annotation, reuseIdentifier: String(AV))
        configureViewForObject?(view, annotation as! MO)
        return view
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        print(#function)
        switch type {
        case .Insert:
            let annotation = controller.objectAtIndexPath(newIndexPath!) as! MKAnnotation
            mapView.addAnnotation(annotation)
        case .Update:
            break
        case .Move:
            break
        case .Delete:
            let annotation = controller.objectAtIndexPath(indexPath!) as! MKAnnotation
            mapView.removeAnnotation(annotation)

        }
    }
    
}