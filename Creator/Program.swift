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
    var attributeLocations: [GLuint : GLint] = [:]
    var uniformLocations: [GLuint : GLint] = [:]

    class func stringToGLCharArray(string: String) -> Array<GLchar> {
        var result = Array<GLchar>()
        for c in string.utf8 {
            result.append(GLchar(c))
        }
        result.append(0)
        return result
    }

    func link() -> String? {
        if handle != 0 {
            glDeleteProgram(handle)
        }
        attributeLocations = [:]
        uniformLocations = [:]
        handle = glCreateProgram()
        glAttachShader(handle, vertexShader.handle)
        glAttachShader(handle, fragmentShader.handle)
        glLinkProgram(handle)
        var linkStatus = GL_FALSE
        glGetProgramiv(handle, GLenum(GL_LINK_STATUS), &linkStatus)
        if linkStatus == GL_TRUE {
            // FIXME: Indices and locations may be the same thing
            iterateOverAttributes({(index: GLuint, name: String, size: GLint, type: GLenum) in
                var nameArray = Program.stringToGLCharArray(name)
                self.attributeLocations[index] = glGetAttribLocation(self.handle, &nameArray)
            })
            iterateOverUniforms({(index: GLuint, name: String, size: GLint, type: GLenum) in
                var nameArray = Program.stringToGLCharArray(name)
                self.uniformLocations[index] = glGetUniformLocation(self.handle, &nameArray)
            })
            return nil
        }
        var logLength: GLint = 0
        glGetProgramiv(handle, GLenum(GL_INFO_LOG_LENGTH), &logLength)
        var buffer = Array<GLchar>(count: Int(logLength), repeatedValue: GLchar(0))
        glGetProgramInfoLog(handle, logLength, nil, &buffer)
        return NSString(data: NSData(bytes: &buffer, length: Int(logLength)), encoding: NSUTF8StringEncoding)! as String
    }

    var attributeCount: Int {
        get {
            var numAttributes: GLint = 0
            glGetProgramiv(handle, GLenum(GL_ACTIVE_ATTRIBUTES), &numAttributes)
            return Int(numAttributes)
        }
    }

    var uniformCount: Int {
        get {
            var numUniforms: GLint = 0
            glGetProgramiv(handle, GLenum(GL_ACTIVE_UNIFORMS), &numUniforms)
            return Int(numUniforms)
        }
    }

    func attributeName(index: GLuint) -> String {
        var nameLength: GLint = 0
        glGetProgramiv(handle, GLenum(GL_ACTIVE_ATTRIBUTE_MAX_LENGTH), &nameLength)
        var buffer = Array<GLchar>(count: Int(nameLength), repeatedValue: GLchar(0))
        var usedLength: GLsizei = 0
        var size: GLint = 0
        var type: GLenum = 0
        glGetActiveAttrib(handle, index, nameLength, &usedLength, &size, &type, &buffer)
        return NSString(data: NSData(bytes: &buffer, length: Int(usedLength)), encoding: NSUTF8StringEncoding)! as String
    }

    func iterateOverAttributes(callback: (index: GLuint, name: String, size: GLint, type: GLenum) -> Void) {
        var nameLength: GLint = 0
        glGetProgramiv(handle, GLenum(GL_ACTIVE_ATTRIBUTE_MAX_LENGTH), &nameLength)
        var buffer = Array<GLchar>(count: Int(nameLength), repeatedValue: GLchar(0))
        for i in 0 ..< GLuint(attributeCount) {
            var usedLength: GLsizei = 0
            var size: GLint = 0
            var type: GLenum = 0
            glGetActiveAttrib(handle, i, nameLength, &usedLength, &size, &type, &buffer)
            let name = NSString(data: NSData(bytes: &buffer, length: Int(usedLength)), encoding: NSUTF8StringEncoding)! as String
            callback(index: i, name: name, size: size, type: type)
        }
    }

    func iterateOverUniforms(callback: (index: GLuint, name: String, size: GLint, type: GLenum) -> Void) {
        var nameLength: GLint = 0
        glGetProgramiv(handle, GLenum(GL_ACTIVE_UNIFORM_MAX_LENGTH), &nameLength)
        var buffer = Array<GLchar>(count: Int(nameLength), repeatedValue: GLchar(0))
        for i in 0 ..< GLuint(uniformCount) {
            var usedLength: GLsizei = 0
            var size: GLint = 0
            var type: GLenum = 0
            glGetActiveUniform(handle, i, nameLength, &usedLength, &size, &type, &buffer)
            let name = NSString(data: NSData(bytes: &buffer, length: Int(usedLength)), encoding: NSUTF8StringEncoding)! as String
            callback(index: i, name: name, size: size, type: type)
        }
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
