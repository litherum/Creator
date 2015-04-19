//
//  Program.swift
//  Creator
//
//  Created by Litherum on 4/19/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import CoreData
import GLKit

class Program: NSManagedObject {
    @NSManaged var vertexShader: VertexShaderNode
    @NSManaged var fragmentShader: FragmentShaderNode
    var handle: GLuint = 0

    func populate(nullNode: NullNode, context: NSManagedObjectContext) {
        if vertexShader.handle == 0 || fragmentShader.handle == 0 {
            return
        }
        handle = glCreateProgram()
        glAttachShader(handle, vertexShader.handle)
        glAttachShader(handle, fragmentShader.handle)
        glLinkProgram(handle)
        var linkStatus = GL_FALSE
        glGetProgramiv(handle, GLenum(GL_LINK_STATUS), &linkStatus)
        if linkStatus == GL_FALSE {
            var logLength: GLint = 0
            glGetProgramiv(handle, GLenum(GL_INFO_LOG_LENGTH), &logLength)
            var buffer = UnsafeMutablePointer<GLchar>.alloc(Int(logLength))
            glGetProgramInfoLog(handle, logLength, nil, buffer)
            let log = NSString(data: NSData(bytes: buffer, length: Int(logLength)), encoding: NSUTF8StringEncoding)!
            println("Could not link! Log:\n\(log)")
            buffer.dealloc(Int(logLength))
            return
        }

        var nameLength: GLint = 0
        glGetProgramiv(handle, GLenum(GL_ACTIVE_ATTRIBUTE_MAX_LENGTH), &nameLength)
        var buffer = UnsafeMutablePointer<GLchar>.alloc(Int(nameLength))
        var numAttributes: GLint = 0
        glGetProgramiv(handle, GLenum(GL_ACTIVE_ATTRIBUTES), &numAttributes)
        for i in 0 ..< GLuint(numAttributes) {
            var usedLength: GLsizei = 0
            var size: GLint = 0
            var type: GLenum = 0
            glGetActiveAttrib(handle, i, nameLength, &usedLength, &size, &type, buffer)
            let name = NSString(data: NSData(bytes: buffer, length: Int(usedLength)), encoding: NSUTF8StringEncoding)!
            vertexShader.addNodeToInputs(nullNode, context: context, name: name as String, index: UInt(i));
        }
        buffer.dealloc(Int(nameLength))

        glGetProgramiv(handle, GLenum(GL_ACTIVE_UNIFORM_MAX_LENGTH), &nameLength)
        buffer = UnsafeMutablePointer<GLchar>.alloc(Int(nameLength))
        var numUniforms: GLint = 0
        glGetProgramiv(handle, GLenum(GL_ACTIVE_UNIFORMS), &numUniforms)
        for i in 0 ..< numUniforms {
            var usedLength: GLsizei = 0
            glGetActiveUniformName(handle, GLuint(i), nameLength, &usedLength, buffer)
            let name = NSString(data: NSData(bytes: buffer, length: Int(usedLength)), encoding: NSUTF8StringEncoding)!
            vertexShader.addNodeToInputs(nullNode, context: context, name: name as String, index: UInt(numAttributes + i));
        }
        buffer.dealloc(Int(nameLength))
    }

    override func prepareForDeletion() {
        if handle != 0 {
            glDeleteProgram(handle)
            handle = 0
        }
    }

    deinit {
        if handle != 0 {
            glDeleteProgram(handle)
            handle = 0
        }
    }
}
