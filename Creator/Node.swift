//
//  Node.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import CoreData

class Node: NSManagedObject {
    // FIXME: Remove this variable
    weak var nodeViewController: NodeViewController!
    @NSManaged var positionX: Float
    @NSManaged var positionY: Float
    @NSManaged var title: String
    @NSManaged var inputs: NSOrderedSet
    @NSManaged var outputs: NSOrderedSet

    func populate(nullNode: NullNode, context: NSManagedObjectContext) {
    }

    func execute() -> Value {
        return .NullValue
    }

    func addPortToInputs(nullNode: NullNode, context: NSManagedObjectContext, name: String, entityName: String = "InputPort") -> InputPort {
        var edge = NSEntityDescription.insertNewObjectForEntityForName("Edge", inManagedObjectContext: context) as! Edge
        var inputPort = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context) as! InputPort
        var outputPort = nullNode.addNullNodeOutputPort(context)

        inputPort.index = Int32(inputs.count)
        inputPort.title = name

        edge.source = inputPort
        edge.destination = outputPort

        mutableOrderedSetValueForKey("inputs").addObject(inputPort)

        return inputPort
    }

    func addPortToOutputs(nullNode: NullNode, context: NSManagedObjectContext, name: String, entityName: String = "OutputPort") -> OutputPort {
        var edge = NSEntityDescription.insertNewObjectForEntityForName("Edge", inManagedObjectContext: context) as! Edge
        var inputPort = nullNode.addNullNodeInputPort(context)
        var outputPort = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context) as! OutputPort

        outputPort.index = Int32(outputs.count)
        outputPort.title = name

        edge.source = inputPort
        edge.destination = outputPort

        mutableOrderedSetValueForKey("outputs").addObject(outputPort)

        return outputPort
    }
}
