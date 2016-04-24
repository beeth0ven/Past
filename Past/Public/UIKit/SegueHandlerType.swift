//
//  SegueHandlerType.swift
//  niuzhi
//
//  Created by luojie on 15/12/10.
//  Copyright © 2015年 ovfun. All rights reserved.
//

import UIKit

/**

 Every view controller provides a segue identifier
 enum mapping. This protocol defines that structure.
 
 We also want to provide implementation to each view controller that conforms
 to this protocol that helps box / unbox the segue identifier strings to
 segue identifier enums. This is provided in an extension of `SegueHandlerType`.
 */

protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    /**
     An overload of `UIViewController`'s `performSegueWithIdentifier(_:sender:)`
     method that takes in a `SegueIdentifier` enum parameter rather than a
     `String`.
     */
    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegueWithIdentifier(segueIdentifier.rawValue, sender: sender)
    }
    
    
    /**
     A convenience method to map a `StoryboardSegue` to the  segue identifier
     enum that it represents.
     */
    func segueIdentifierFromSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        /*
        Map the segue identifier's string to an enum. It's a programmer error
        if a segue identifier string that's provided doesn't map to one of the
        raw representable values (most likely enum cases).
        */
        guard let identifier = segue.identifier,
            segueIdentifier = SegueIdentifier(rawValue: identifier) else {
                fatalError("Couldn't handle segue identifier \(segue.identifier) for view controller of type\(self.dynamicType).")
        }
        return segueIdentifier
    }
}