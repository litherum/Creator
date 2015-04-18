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
    var endPoint: NSPoint
    init(startPoint startPointInput: NSPoint, endPoint endPointInput: NSPoint) {
        startPoint = startPointInput
        endPoint = endPointInput
    }
}

class ConnectionsView: NSView {
    var connections: [Connection] = []
    var connectionInFlight: Connection?
    override func drawRect(dirtyRect: NSRect) {
        NSColor.redColor().set()
        for connection in connections {
            var path = NSBezierPath()
            path.moveToPoint(connection.startPoint)
            path.lineToPoint(connection.endPoint)
            path.stroke()
        }
        NSColor.greenColor().set()
        if let c = connectionInFlight {
            var path = NSBezierPath()
            path.moveToPoint(c.startPoint)
            path.lineToPoint(c.endPoint)
            path.stroke()
        }
    }
}
