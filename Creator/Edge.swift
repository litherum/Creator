//
//  Edge.swift
//  Creator
//
//  Created by Litherum on 4/17/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import CoreData

// Edges' destinations are on the left.
class Edge: NSManagedObject {
    @NSManaged var sourceIndex: Int32
    @NSManaged var destinationIndex: Int32
    @NSManaged var destination: Node
    @NSManaged var source: Node
}
