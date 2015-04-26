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
    @NSManaged var minValue: Float
    @NSManaged var maxValue: Float

    override func populate(nullNode: NullNode, context: NSManagedObjectContext) {
        addNodeToOutputs(nullNode, context: context, name: "value");
    }
}
