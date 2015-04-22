//
//  ConstantFloatNode.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import CoreData

class ConstantFloatNode: Node {
    @NSManaged var payload: Float

    override func populate(nullNode: NullNode, context: NSManagedObjectContext) {
        addNodeToOutputs(nullNode, context: context, name: "value", index: UInt(0));
    }
}
