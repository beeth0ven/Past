//
//  RootObject.swift
//  Past
//
//  Created by luojie on 16/4/21.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData


class ManagedObject: NSManagedObject {

    override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = NSDate()
    }
}
