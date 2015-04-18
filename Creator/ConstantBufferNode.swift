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
    override func populate(nullNode: NullNode, context: NSManagedObjectContext) {
        addNodeToOutputs(nullNode, context: context, index: UInt(0));
    }
}
