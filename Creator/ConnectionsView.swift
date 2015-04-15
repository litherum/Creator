//
//  ConnectionsView.swift
//  Creator
//
//  Created by Litherum on 4/13/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class Connection {
    var startNodeViewController: NodeViewController
    var startIndex: UInt
    var endNodeViewController: NodeViewController
    var endIndex: UInt
    init(startNodeViewControllerInput: NodeViewController, startIndexInput: UInt, endNodeViewControllerInput: NodeViewController, endIndexInput: UInt) {
        startNodeViewController = startNodeViewControllerInput
        startIndex = startIndexInput
        endNodeViewController = endNodeViewControllerInput
        endIndex = endIndexInput
    }
}

class ConnectionsView: NSView {
    var connections: [Connection] = []
    var connectionInFlight: (Connection, NSPoint)?
    override func drawRect(dirtyRect: NSRect) {
        NSColor.redColor().set()
        for connection in connections {
            let inputView = connection.startNodeViewController.inputsView.views[Int(connection.startIndex)] as! NSView
            let outputView = connection.endNodeViewController.outputsView.views[Int(connection.endIndex)] as! NSView
            let startPoint = convertPoint(NSMakePoint(0, (inputView.bounds.origin.y + inputView.bounds.maxY) / 2), fromView: inputView)
            let endPoint = convertPoint(NSMakePoint(outputView.bounds.maxX, (outputView.bounds.origin.y + outputView.bounds.maxY) / 2), fromView: outputView)
            var path = NSBezierPath()
            path.moveToPoint(startPoint)
            path.lineToPoint(endPoint)
            path.stroke()
        }
        NSColor.greenColor().set()
        if let c = connectionInFlight {
            let inputView = c.0.startNodeViewController.inputsView.views[Int(c.0.startIndex)] as! NSView
            let startPoint = convertPoint(NSMakePoint(0, (inputView.bounds.origin.y + inputView.bounds.maxY) / 2), fromView: inputView)
            let endPoint = c.1
            var path = NSBezierPath()
            path.moveToPoint(startPoint)
            path.lineToPoint(endPoint)
            path.stroke()
        }
    }
}
