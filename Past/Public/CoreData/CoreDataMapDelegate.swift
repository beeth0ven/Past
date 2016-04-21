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
    var didSelectCalloutAccessoryView: ((UIView, MO) -> Void)?
    
    func setup(predicate
        predicate: NSPredicate? = nil,
        sortOption: NSSortDescriptor.Option? = .By(key: "creationDate", ascending: false),
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
        
        reloadMapView()
    }
    
    private var fetchedResultsController: NSFetchedResultsController? { didSet { fetchedResultsController?.delegate = self } }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        let view = AV(annotation: annotation, reuseIdentifier: String(AV))
        configureViewForObject?(view, annotation as! MO)
        return view
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let lineView = MKPolylineRenderer(overlay: overlay)
        lineView.strokeColor = UIColor.greenColor()
        return lineView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        didSelectCalloutAccessoryView?(control, view.annotation as! MO)
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        reloadMapView()
    }
    
    private func reloadMapView() {
        let annotations = fetchedResultsController!.fetchedObjects as! [MKAnnotation]
        
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(mapView.annotations, animated: true)
        
        var coordinates = annotations.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
    }
}