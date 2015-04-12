//
//  NodeView.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class GraphView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func resizeWithOldSuperviewSize(oldBoundsSize: NSSize) {
        super.resizeWithOldSuperviewSize(oldBoundsSize)
    }
    override func setFrameOrigin(newOrigin: NSPoint) {
        super.setFrameOrigin(newOrigin)
        println("Set GraphView frame origin to \(newOrigin)")
    }
    override func setFrameSize(newSize: NSSize) {
        println("Set GraphView frame size to \(newSize)")
        super.setFrameSize(newSize)
    }
    override func setBoundsOrigin(newOrigin: NSPoint) {
        super.setBoundsOrigin(newOrigin)
        println("Set GraphView bounds origin to \(newOrigin)")
    }
    override func setBoundsSize(newSize: NSSize) {
        super.setBoundsSize(newSize)
        println("Set GraphView bounds size to \(newSize)")
    }
    override func addConstraint(constraint: NSLayoutConstraint) {
        super.addConstraint(constraint)
        println("Adding constraint to GraphView")
    }

    /*override func drawRect(dirtyRect: NSRect) {
        NSColor.greenColor().set()
        NSBezierPath.fillRect(bounds)
    }*/
}
