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
        addNodeToInputs(nullNode, context: context);
        addNodeToInputs(nullNode, context: context);
        addNodeToInputs(nullNode, context: context);

        addNodeToOutputs(nullNode, context: context);
        addNodeToOutputs(nullNode, context: context);
    }
}
