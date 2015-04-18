//
//  InputOutputTextField.swift
//  Creator
//
//  Created by Litherum on 4/17/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class NodeInputOutputTextField: NSTextField {
    weak var graphViewController: GraphViewController!
    weak var nodeViewController: NodeViewController!
    var index: UInt = 0

    override func mouseDown(theEvent: NSEvent) {
        graphViewController.nodeInputOutputMouseDown(nodeViewController, index: index)
    }

    override func mouseUp(theEvent: NSEvent) {
        graphViewController.nodeInputOutputMouseUp(nodeViewController, index: index)
    }
}