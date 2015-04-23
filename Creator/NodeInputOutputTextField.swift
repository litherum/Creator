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
    var input: Bool = true
    var index: UInt = 0

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(graphViewController: GraphViewController, nodeViewController: NodeViewController, input: Bool, index: UInt, alignment: NSTextAlignment, value: String) {
        super.init(frame: NSZeroRect)
        translatesAutoresizingMaskIntoConstraints = false
        selectable = false
        drawsBackground = false
        bezeled = false
        self.graphViewController = graphViewController
        self.nodeViewController = nodeViewController
        self.input = input
        self.index = index
        self.alignment = alignment
        self.stringValue = value
    }

    override func mouseDown(theEvent: NSEvent) {
        if input {
            graphViewController.nodeInputOutputMouseDown(nodeViewController, index: index)
        }
    }

    override func mouseUp(theEvent: NSEvent) {
        if input {
            graphViewController.nodeInputOutputMouseUp(nodeViewController, index: index, mouseLocation: theEvent.locationInWindow)
        }
    }
}