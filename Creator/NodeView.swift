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
    override var intrinsicContentSize: NSSize {
        return NSMakeSize(CGFloat(100), CGFloat(100))
    }
    override func drawRect(dirtyRect: NSRect) {
        NSColor.greenColor().set()
        NSBezierPath.fillRect(bounds)
    }
}
