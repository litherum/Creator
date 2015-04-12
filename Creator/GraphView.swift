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
        println("init frame \(frameRect)")
        super.init(frame: frameRect)
    }
    required init?(coder: NSCoder) {
        println("init coder")
        super.init(coder: coder)
    }
    override func resizeWithOldSuperviewSize(oldBoundsSize: NSSize) {
        super.resizeWithOldSuperviewSize(oldBoundsSize)
    }
    override func setFrameOrigin(newOrigin: NSPoint) {
        println("Setting GraphView frame origin to \(newOrigin)")
        super.setFrameOrigin(newOrigin)
    }
    override func setFrameSize(newSize: NSSize) {
        println("Setting GraphView frame size to \(newSize)")
        super.setFrameSize(newSize)
    }
    override func setBoundsOrigin(newOrigin: NSPoint) {
        println("Setting GraphView bounds origin to \(newOrigin)")
        super.setBoundsOrigin(newOrigin)
    }
    override func setBoundsSize(newSize: NSSize) {
        println("Setting GraphView bounds size to \(newSize)")
        super.setBoundsSize(newSize)
    }
    override func addConstraint(constraint: NSLayoutConstraint) {
        println("Adding constraint to GraphView")
        super.addConstraint(constraint)
    }

    override func drawRect(dirtyRect: NSRect) {
        //NSColor.greenColor().set()
        //NSBezierPath.fillRect(bounds)
        //NSColor.blackColor().set()
        //NSBezierPath.fillRect(NSMakeRect(0, 0, 50, 45))
    }
}
