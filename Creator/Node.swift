//
//  Node.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import CoreData

class Node: NSManagedObject {

    @NSManaged var positionX: Float
    @NSManaged var positionY: Float
    @NSManaged var frame: Frame
    @NSManaged var inputs: NSOrderedSet
    @NSManaged var outputs: NSOrderedSet

}
