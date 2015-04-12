//
//  NodeView.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class NodeView: NSView {
    override func drawRect(dirtyRect: NSRect) {
        NSColor.greenColor().set()
        NSBezierPath.fillRect(bounds)
    }
}
