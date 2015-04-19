//
//  ResultView.swift
//  Creator
//
//  Created by Litherum on 4/18/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa
import GLKit

class ResultView: NSOpenGLView {
    override func awakeFromNib() {
        var attributes: [NSOpenGLPixelFormatAttribute] = [UInt32(NSOpenGLPFADoubleBuffer), UInt32(NSOpenGLPFADepthSize), 24, UInt32(NSOpenGLPFAOpenGLProfile), UInt32(NSOpenGLProfileVersion3_2Core), 0]
        pixelFormat = NSOpenGLPixelFormat(attributes: &attributes)
        openGLContext = NSOpenGLContext(format: pixelFormat, shareContext: nil)
        CGLEnable(openGLContext.CGLContextObj, kCGLCECrashOnRemovedFunctions)
        wantsBestResolutionOpenGLSurface = true

        // Context should always be current in our main thread from now on.
        openGLContext.makeCurrentContext()
    }

    override func prepareOpenGL() {
    }

    override func update() {
    }

    override func reshape() {
    }

    override func drawRect(dirtyRect: NSRect) {
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        openGLContext.flushBuffer()
    }
}
