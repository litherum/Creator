//
//  ConnectionsView.swift
//  Creator
//
//  Created by Litherum on 4/13/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class Connection {
    var startPoint: NSPoint
    var startNode: Node
    var startIndex: UInt
    var endPoint: NSPoint
    var endNode: Node
    var endIndex: UInt
    init(startPointInput: NSPoint, startNodeInput: Node, startIndexInput: UInt, endPointInput: NSPoint, endNodeInput: Node, endIndexInput: UInt) {
        startPoint = startPointInput
        startNode = startNodeInput
        startIndex = startIndexInput
        endPoint = endPointInput
        endNode = endNodeInput
        endIndex = endIndexInput
    }
}

class ConnectionsView: NSView {
    var connections: [Connection] = []
    override func drawRect(dirtyRect: NSRect) {
        NSColor.redColor().set()
        for connection in connections {
            var path = NSBezierPath()
            path.moveToPoint(connection.startPoint)
            path.lineToPoint(connection.endPoint)
            path.stroke()
        }
    }
}
