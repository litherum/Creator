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

    override func mouseDown(theEvent: NSEvent) {
        nodeViewController.nodeTitleMouseDown(theEvent.locationInWindow)
    }

    override func mouseDragged(theEvent: NSEvent) {
        nodeViewController.nodeTitleMouseDragged(theEvent.locationInWindow)
    }

    override func mouseUp(theEvent: NSEvent) {
        nodeViewController.nodeTitleMouseUp(theEvent.locationInWindow)
        if theEvent.clickCount == 2 {
            nodeViewController.showDetails()
        }
    }
}