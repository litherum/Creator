//
//  ConstantBufferNode.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import CoreData

class ConstantBufferNode: Node {
    @NSManaged var payload: NSData
    func populate(nullNode: NullNode, context: NSManagedObjectContext) {
        addNodeToInputs(nullNode, context: context, sourceIndex: UInt(0), destinationIndex: UInt(0));
        addNodeToInputs(nullNode, context: context, sourceIndex: UInt(1), destinationIndex: UInt(0));
        addNodeToInputs(nullNode, context: context, sourceIndex: UInt(2), destinationIndex: UInt(0));

        addNodeToOutputs(nullNode, context: context, sourceIndex: UInt(0), destinationIndex: UInt(0));
        addNodeToOutputs(nullNode, context: context, sourceIndex: UInt(0), destinationIndex: UInt(1));
    }
}
