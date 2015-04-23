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
        assert(!dragging, "We should only be dragging while the mouse is down")
        nodeViewController.nodeTitleMouseDown(theEvent.locationInWindow)
        dragging = true
    }

    override func mouseDragged(theEvent: NSEvent) {
        assert(dragging, "We should always be dragging while the mouse is down")
        nodeViewController.nodeTitleMouseDragged(theEvent.locationInWindow)
    }

    override func mouseUp(theEvent: NSEvent) {
        assert(dragging, "We should always be dragging while the mouse is down")
        nodeViewController.nodeTitleMouseUp(theEvent.locationInWindow)
        dragging = false
        if theEvent.clickCount == 2 {
            nodeViewController.showDetails()
        }
    }
}