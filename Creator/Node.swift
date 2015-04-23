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

    func addNodeToInputs(nullNode: NullNode, context: NSManagedObjectContext, name: String) {
        var edge = NSEntityDescription.insertNewObjectForEntityForName("Edge", inManagedObjectContext: context) as! Edge
        var inputPort = NSEntityDescription.insertNewObjectForEntityForName("InputPort", inManagedObjectContext: context) as! InputPort
        var outputPort = NSEntityDescription.insertNewObjectForEntityForName("OutputPort", inManagedObjectContext: context) as! OutputPort

        inputPort.index = Int32(inputs.count)
        inputPort.title = name
        outputPort.index = Int32(nullNode.outputs.count)
        outputPort.title = ""

        edge.source = inputPort
        edge.destination = outputPort

        mutableOrderedSetValueForKey("inputs").addObject(inputPort)
        nullNode.mutableOrderedSetValueForKey("outputs").addObject(outputPort)
    }

    func addNodeToOutputs(nullNode: NullNode, context: NSManagedObjectContext, name: String) {
        var edge = NSEntityDescription.insertNewObjectForEntityForName("Edge", inManagedObjectContext: context) as! Edge
        var inputPort = NSEntityDescription.insertNewObjectForEntityForName("InputPort", inManagedObjectContext: context) as! InputPort
        var outputPort = NSEntityDescription.insertNewObjectForEntityForName("OutputPort", inManagedObjectContext: context) as! OutputPort

        inputPort.index = Int32(nullNode.inputs.count)
        inputPort.title = ""
        outputPort.index = Int32(outputs.count)
        outputPort.title = name

        edge.source = inputPort
        edge.destination = outputPort

        nullNode.mutableOrderedSetValueForKey("inputs").addObject(inputPort)
        mutableOrderedSetValueForKey("outputs").addObject(outputPort)
    }
}
