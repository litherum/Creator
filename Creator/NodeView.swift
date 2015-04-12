//
//  NodeView.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class NodeView: NSView {
    weak var graphViewController: GraphViewController?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func setFrameOrigin(newOrigin: NSPoint) {
        //println("Setting NodeView frame origin to \(newOrigin)")
        super.setFrameOrigin(newOrigin)
    }
    override func setFrameSize(newSize: NSSize) {
        //println("Setting NodeView frame size to \(newSize)")
        super.setFrameSize(newSize)
    }
    override func setBoundsOrigin(newOrigin: NSPoint) {
        //println("Setting NodeView bounds origin to \(newOrigin)")
        super.setBoundsOrigin(newOrigin)
    }
    override func setBoundsSize(newSize: NSSize) {
        //println("Setting NodeView bounds size to \(newSize)")
        super.setBoundsSize(newSize)
    }
    override func addConstraint(constraint: NSLayoutConstraint) {
        //println("Adding constraint to NodeView")
        super.addConstraint(constraint)
    }

    override func drawRect(dirtyRect: NSRect) {
        //NSColor.redColor().set()
        //NSBezierPath.fillRect(bounds)
    }
}
