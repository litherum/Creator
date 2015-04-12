//
//  NodeView.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class NodeView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func setFrameOrigin(newOrigin: NSPoint) {
        super.setFrameOrigin(newOrigin)
        println("Set NodeView frame origin to \(newOrigin)")
    }
    override func setFrameSize(newSize: NSSize) {
        super.setFrameSize(newSize)
        println("Set NodeView frame size to \(newSize)")
    }
    override func setBoundsOrigin(newOrigin: NSPoint) {
        super.setBoundsOrigin(newOrigin)
        println("Set NodeView bounds origin to \(newOrigin)")
    }
    override func setBoundsSize(newSize: NSSize) {
        super.setBoundsSize(newSize)
        println("Set NodeView bounds size to \(newSize)")
    }
    override func addConstraint(constraint: NSLayoutConstraint) {
        super.addConstraint(constraint)
        println("Adding constraint to NodeView")
    }

    /*override func drawRect(dirtyRect: NSRect) {
        NSColor.greenColor().set()
        NSBezierPath.fillRect(bounds)
    }*/
}
