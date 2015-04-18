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
    @NSManaged var title: String
    @NSManaged var frame: Frame
    @NSManaged var inputs: NSOrderedSet
    @NSManaged var outputs: NSOrderedSet

    func populate(nullNode: NullNode, context: NSManagedObjectContext) {
    }

    func populateDummy(nullNode: NullNode, context: NSManagedObjectContext) {
        addNodeToInputs(nullNode, context: context, sourceIndex: UInt(0), destinationIndex: UInt(0));
        addNodeToInputs(nullNode, context: context, sourceIndex: UInt(1), destinationIndex: UInt(0));
        addNodeToInputs(nullNode, context: context, sourceIndex: UInt(2), destinationIndex: UInt(0));

        addNodeToOutputs(nullNode, context: context, sourceIndex: UInt(0), destinationIndex: UInt(0));
        addNodeToOutputs(nullNode, context: context, sourceIndex: UInt(0), destinationIndex: UInt(1));
    }

    func addNodeToInputs(node: Node, context: NSManagedObjectContext, sourceIndex: UInt, destinationIndex: UInt) {
        var edge = NSEntityDescription.insertNewObjectForEntityForName("Edge", inManagedObjectContext: context) as! Edge
        edge.source = self
        edge.sourceIndex = Int32(sourceIndex)
        edge.destination = node
        edge.destinationIndex = Int32(destinationIndex)
        mutableOrderedSetValueForKey("inputs").addObject(edge)
    }

    func addNodeToOutputs(node: Node, context: NSManagedObjectContext, sourceIndex: UInt, destinationIndex: UInt) {
        var edge = NSEntityDescription.insertNewObjectForEntityForName("Edge", inManagedObjectContext: context) as! Edge
        edge.source = node
        edge.sourceIndex = Int32(sourceIndex)
        edge.destination = self
        edge.destinationIndex = Int32(destinationIndex)
        mutableOrderedSetValueForKey("outputs").addObject(edge)
    }
}
