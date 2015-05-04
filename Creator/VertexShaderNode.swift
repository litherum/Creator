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
    @NSManaged var program: Program?
    var handle: GLuint = 0

    override func populate(nullNode: NullNode, context: NSManagedObjectContext) {
        addPortToOutputs(nullNode, context: context, name: "Next stage");
        let compilationLog = compile()
        if let log = compilationLog {
            println("Could not compile! Log:")
            println(log)
        }
    }

    func glTypeToAttribPointerSizeAndType(type: GLenum) -> (GLint, GLenum) {
        switch type {
            case GLenum(GL_FLOAT):
                return (1, GLenum(GL_FLOAT))
            case GLenum(GL_FLOAT_VEC2):
                return (2, GLenum(GL_FLOAT))
            case GLenum(GL_FLOAT_VEC3):
                return (3, GLenum(GL_FLOAT))
            case GLenum(GL_FLOAT_VEC4):
                return (4, GLenum(GL_FLOAT))
            case GLenum(GL_INT):
                return (1, GLenum(GL_INT))
            case GLenum(GL_INT_VEC2):
                return (2, GLenum(GL_INT))
            case GLenum(GL_INT_VEC3):
                return (3, GLenum(GL_INT))
            case GLenum(GL_INT_VEC4):
                return (4, GLenum(GL_INT))
            case GLenum(GL_UNSIGNED_INT):
                return (1, GLenum(GL_UNSIGNED_INT))
            case GLenum(GL_UNSIGNED_INT_VEC2):
                return (2, GLenum(GL_UNSIGNED_INT))
            case GLenum(GL_UNSIGNED_INT_VEC3):
                return (3, GLenum(GL_UNSIGNED_INT))
            case GLenum(GL_UNSIGNED_INT_VEC4):
                return (4, GLenum(GL_UNSIGNED_INT))
            case GLenum(GL_DOUBLE):
                return (1, GLenum(GL_DOUBLE))
            case GLenum(GL_DOUBLE_VEC2):
                return (2, GLenum(GL_DOUBLE))
            case GLenum(GL_DOUBLE_VEC3):
                return (3, GLenum(GL_DOUBLE))
            case GLenum(GL_DOUBLE_VEC4):
                return (4, GLenum(GL_DOUBLE))
            default:
                return (0, 0)
        }
    }

    override func execute() -> Value {
        if let program = program {
            if program.handle == 0 {
                return .NullValue
            }
            // FIXME: Shadow this state so we don't have to specify it every frame
            glUseProgram(program.handle)
            // FIXME: Keep this VAO around for longer than a frame
            var vertexArray: GLuint = 0
            glGenVertexArrays(1, &vertexArray)
            glBindVertexArray(vertexArray)
            // FIXME: This is slow
            for i in 0 ..< attributeInputPortCount {
                var port = attributeInputPort(i)!
                var index = GLuint(port.glIndex)
                switch port.edge.destination.node.execute() {
                    case .GLuintValue(let i):
                        glBindBuffer(GLenum(GL_ARRAY_BUFFER), i)
                        break
                    default:
                        println("Unexpected value from an attribute")
                        glDeleteVertexArrays(1, &vertexArray)
                        return .NullValue
                }
                glEnableVertexAttribArray(index)
                if port.glSize != 1 {
                    println("Don't know how to deal with attribute arrays")
                    glDeleteVertexArrays(1, &vertexArray)
                    return .NullValue
                }
                let (attribPointerSize, attribPointerType) = glTypeToAttribPointerSizeAndType(GLenum(port.glType))
                glVertexAttribPointer(index, attribPointerSize, attribPointerType, GLboolean(port.attributeNormalized ? 1 : 0), GLsizei(port.attributeStride), UnsafePointer<Void>(COpaquePointer(bitPattern: Word(port.attributeOffset))))
            }
            for i in 0 ..< uniformInputPortCount {
                var port = uniformInputPort(i)!
                var index = GLuint(port.glIndex)
                switch port.edge.destination.node.execute() {
                    // FIXME: Support other types of uniforms
                    case .FloatValue(let f):
                        glUniform1f(program.uniformLocations[index]!, GLfloat(f))
                        break
                    default:
                        println("Unexpected value from a uniform")
                        glDeleteVertexArrays(1, &vertexArray)
                        return .NullValue
                }
            }
            // FIXME: Parameterize these values in the data model
            glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
            glDeleteVertexArrays(1, &vertexArray)
            return .NullValue
        } else {
            return .NullValue
        }
    }

    func compile() -> String? {
        if handle != 0 {
            glDeleteShader(handle)
        }

        handle = glCreateShader(GLenum(GL_VERTEX_SHADER))
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

    func attributeInputPort(index: Int) -> AttributeInputPort? {
        var i = 0
        for input in inputs {
            if let input = input as? AttributeInputPort {
                if i == index {
                    return input
                }
                i++
            }
        }
        return nil
    }

    var attributeInputPortCount: Int {
        get {
            var i = 0
            for input in inputs {
                if let input = input as? AttributeInputPort {
                    i++
                }
            }
            return i
        }
    }

    func uniformInputPort(index: Int) -> UniformInputPort? {
        var i = 0
        for input in inputs {
            if let input = input as? UniformInputPort {
                if i == index {
                    return input
                }
                i++
            }
        }
        return nil
    }

    var uniformInputPortCount: Int {
        get {
            var i = 0
            for input in inputs {
                if let input = input as? UniformInputPort {
                    i++
                }
            }
            return i
        }
    }
}
