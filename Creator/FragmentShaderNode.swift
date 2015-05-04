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
    @NSManaged var program: Program?
    var handle: GLuint = 0

    override func populate(nullNode: NullNode, context: NSManagedObjectContext) {
        addPortToInputs(nullNode, context: context, name: "Previous stage");

        compile()
    }

    override func execute() -> Value {
        if let vertexShader = (inputs[0] as! InputPort).edge.destination.node as? VertexShaderNode {
            vertexShader.execute()
            return .NullValue
        } else {
            return .NullValue
        }
    }

    func compile() -> String? {
        if handle != 0 {
            glDeleteShader(handle)
        }

        handle = glCreateShader(GLenum(GL_FRAGMENT_SHADER))
        let data = source.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        var b = UnsafePointer<GLchar>(data.bytes)
        var lineLen = GLint(data.length)
        glShaderSource(handle, GLsizei(1), &b, &lineLen)
        glCompileShader(handle)
        var compileStatus = GL_FALSE
        glGetShaderiv(handle, GLenum(GL_COMPILE_STATUS), &compileStatus)
        if compileStatus == GL_TRUE {
            return nil
        }
        var logLength: GLint = 0
        glGetShaderiv(handle, GLenum(GL_INFO_LOG_LENGTH), &logLength)
        var buffer = Array<GLchar>(count: Int(logLength), repeatedValue: GLchar(0))
        glGetShaderInfoLog(handle, logLength, nil, &buffer)
        return NSString(data: NSData(bytes: &buffer, length: Int(logLength)), encoding: NSUTF8StringEncoding)! as String
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
