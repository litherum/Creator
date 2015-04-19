//
//  VertexShaderNode.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import CoreData
import GLKit

class VertexShaderNode: Node {
    @NSManaged var source: String
    var handle: GLuint = 0
    override func populate(nullNode: NullNode, context: NSManagedObjectContext) {
        addNodeToOutputs(nullNode, context: context, name: "Next pipeline stage", index: UInt(0));

        handle = glCreateShader(GLenum(GL_VERTEX_SHADER))
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
            let bufferData = NSData(bytes: buffer, length: Int(logLength))
            let log = NSString(data: bufferData, encoding: NSUTF8StringEncoding)!
            println("Could not compile! Log:\n\(log)")
            buffer.dealloc(Int(logLength))
        } else {
            println("Compilation success!")
        }

        // Once the program has been linked, we can use glGetProgramiv(program, GL_ACTIVE_ATTRIBUTES, &out) to get the number of attributes,
        // then glGetProgramiv(program, GL_ACTIVE_ATTRIBUTE_MAX_LENGTH, &out) and glGetActiveAttrib(program, i, length, nil, &size, &type, &buffer)
        // to get the names of the attributes.
        // Then, we can use glGetProgramiv(program, GL_ACTIVE_UNIFORMS, &out) to get the number of uniforms, and then use
        // glGetProgramiv(program, GL_ACTIVE_UNIFORM_MAX_LENGTH, &out) and glGetActiveUniformName(program, i, length, nil, &length, &buffer)
        // to get the names of the uniforms.
        // Punting support for other types of variables in shaders is okay.
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
