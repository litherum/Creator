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
        populateDummy(nullNode, context: context)

        handle = glCreateShader(GLenum(GL_VERTEX_SHADER))
        var b = UnsafePointer<GLchar>(source.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!.bytes)
        glShaderSource(handle, GLsizei(1), &b, nil)
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
            println("Success!")
        }
    }

    override func prepareForDeletion() {
        glDeleteShader(handle)
    }
}
