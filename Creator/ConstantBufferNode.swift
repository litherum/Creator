//
//  ConstantBufferNode.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import CoreData
import GLKit

class ConstantBufferNode: Node {
    @NSManaged var payload: NSData
    var handle: GLuint = 0

    override func populate(nullNode: NullNode, context: NSManagedObjectContext) {
        addPortToOutputs(nullNode, context: context, name: "payload");
    }

    func upload() {
        if handle != 0 {
            glDeleteBuffers(1, &handle)
        }

        glGenBuffers(1, &handle)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), handle)
        glBufferData(GLenum(GL_ARRAY_BUFFER), payload.length, payload.bytes, GLenum(GL_STREAM_DRAW))
    }

    override func prepareForDeletion() {
        if handle != 0 {
            glDeleteBuffers(1, &handle)
            handle = 0
        }
    }

    deinit {
        if handle != 0 {
            glDeleteBuffers(1, &handle)
            handle = 0
        }
    }
}
