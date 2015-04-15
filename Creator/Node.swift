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

    func addNodeToInputs(node: Node, context: NSManagedObjectContext) {
        var edge = NSEntityDescription.insertNewObjectForEntityForName("Edge", inManagedObjectContext: context) as! Edge
        edge.source = self
        edge.destination = node
        mutableOrderedSetValueForKey("inputs").addObject(edge)
    }

    func addNodeToOutputs(node: Node, context: NSManagedObjectContext) {
        var edge = NSEntityDescription.insertNewObjectForEntityForName("Edge", inManagedObjectContext: context) as! Edge
        edge.source = node
        edge.destination = self
        mutableOrderedSetValueForKey("outputs").addObject(edge)
    }
}
