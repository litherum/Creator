//
//  Frame.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import CoreData

class Frame: Node {
    override func execute() -> Value {
        for input in inputs {
            if let fragmentShader = (input as! InputPort).edge.destination.node as? FragmentShaderNode {
                // FIXME: Probably should do something to make sure the correct MRT output goes to the right place
                fragmentShader.execute()
            }
        }
        return .NullValue
    }
}
