//
//  Edge.swift
//  Creator
//
//  Created by Litherum on 4/17/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import CoreData

class Edge: NSManagedObject {
    @NSManaged var destination: OutputPort
    @NSManaged var source: InputPort
}
