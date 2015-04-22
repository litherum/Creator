//
//  File.swift
//  Creator
//
//  Created by Litherum on 4/17/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class NodeTitleTextField: NSTextField {
    weak var graphViewController: GraphViewController!
    weak var nodeViewController: NodeViewController!
    var dragging: Bool = false

    override func mouseDown(theEvent: NSEvent) {
        graphViewController.nodeTitleMouseDown(nodeViewController, mouseLocation: theEvent.locationInWindow)
        dragging = true
    }

    override func mouseUp(theEvent: NSEvent) {
        if dragging {
            graphViewController.nodeTitleMouseUp(nodeViewController, mouseLocation: theEvent.locationInWindow)
            dragging = false
        }
        if theEvent.clickCount == 2 {
            nodeViewController.showDetails()
        }
    }
}