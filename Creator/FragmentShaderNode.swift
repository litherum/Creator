//
//  FragmentShaderNode.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import CoreData
import GLKit

class FragmentShaderNode: Node {
    @NSManaged var source: String
    @NSManaged var program: Program
    var handle: GLuint = 0

    override func populate(nullNode: NullNode, context: NSManagedObjectContext) {
        addNodeToInputs(nullNode, context: context, name: "Previous stage", index: UInt(0));

        handle = glCreateShader(GLenum(GL_FRAGMENT_SHADER))
        let data = source.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        var b = UnsafePointer<GLchar>(data.bytes)
        var lineLen = GLint(data.length)
        glShaderSource(handle, GLsizei(1), &b, &lineLen)
        glCompileShader(handle)
        var compileStatus = GL_FALSE
        glGetShaderiv(handle, GLenum(GL_COMPILE_STATUS), &compileStatus)
        if compileStatus == GL_FALSE {
            var logLength: GLint = 0
            glGetShaderiv(handle, GLenum(GL_INFO_LOG_LENGTH), &logLength)
            var buffer = UnsafeMutablePointer<GLchar>.alloc(Int(logLength))
            glGetShaderInfoLog(handle, logLength, nil, buffer)
            let log = NSString(data: NSData(bytes: buffer, length: Int(logLength)), encoding: NSUTF8StringEncoding)!
            println("Could not compile! Log:\n\(log)")
            buffer.dealloc(Int(logLength))
        }
    }

    override func prepareForDeletion() {
        if handle != 0 {
            glDeleteShader(handle)
            handle = 0
        }
    }

    deinit {
        if handle != 0 {
            glDeleteShader(handle)
            handle = 0
        }
    }
}
