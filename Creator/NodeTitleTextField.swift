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
        graphViewController.nodeTitleMouseDown(nodeViewController, mouseLocation: theEvent.locationInWindow)
    }

    override func mouseUp(theEvent: NSEvent) {
        graphViewController.nodeTitleMouseUp(nodeViewController, mouseLocation: theEvent.locationInWindow)
    }
}