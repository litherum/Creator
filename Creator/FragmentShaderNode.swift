//
//  FragmentShaderNode.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import CoreData

class FragmentShaderNode: Node {
    @NSManaged var source: String
    override func populate(nullNode: NullNode, context: NSManagedObjectContext) {
        populateDummy(nullNode, context: context)
    }
}
