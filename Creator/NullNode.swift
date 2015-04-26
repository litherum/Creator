//
//  NullNode.swift
//  Creator
//
//  Created by Litherum on 4/14/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Foundation
import CoreData

class NullNode: Node {
    // Note that the returned OutputPort must be subsequently attached to an edge!
    func addNullNodeOutputPort(context: NSManagedObjectContext) -> OutputPort {
        var newOutputPort = NSEntityDescription.insertNewObjectForEntityForName("OutputPort", inManagedObjectContext: context) as! OutputPort
        newOutputPort.title = ""
        newOutputPort.index = Int32(outputs.count)
        mutableOrderedSetValueForKey("outputs").addObject(newOutputPort)
        return newOutputPort
    }

    // Note that the returned InputPort must be subsequently attached to an edge!
    func addNullNodeInputPort(context: NSManagedObjectContext) -> InputPort {
        var newInputPort = NSEntityDescription.insertNewObjectForEntityForName("InputPort", inManagedObjectContext: context) as! InputPort
        newInputPort.title = ""
        newInputPort.index = Int32(inputs.count)
        mutableOrderedSetValueForKey("inputs").addObject(newInputPort)
        return newInputPort
    }
}
