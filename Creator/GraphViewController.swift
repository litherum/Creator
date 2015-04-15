//
//  GraphViewController.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class GraphViewController: NSViewController {
    lazy var frame: Frame? = self.fetchFrame()
    lazy var nullNode: NullNode? = self.fetchNullNode()
    var managedObjectContext: NSManagedObjectContext!
    var managedObjectModel: AnyObject!

    @IBOutlet var connectionsView: ConnectionsView!

    enum DragOperation {
        case Move(NodeViewController, NSPoint)
        case Connect(NodeViewController, UInt)
    }
    var dragOperation: DragOperation!

    func fetchFrame() -> Frame? {
        var frameRequest = managedObjectModel.fetchRequestFromTemplateWithName("FrameRequest", substitutionVariables: [:]) as NSFetchRequest!
        var error: NSError?
        let frames = managedObjectContext.executeFetchRequest(frameRequest, error: &error) as! [Frame]!
        if error != nil {
            return nil
        }
        if frames.count == 0 {
            return NSEntityDescription.insertNewObjectForEntityForName("Frame", inManagedObjectContext: managedObjectContext) as? Frame
        } else {
            return frames[0]
        }
    }

    func fetchNullNode() -> NullNode? {
        var nullNodeRequest = managedObjectModel.fetchRequestFromTemplateWithName("NullNodeRequest", substitutionVariables: [:]) as NSFetchRequest!
        var error: NSError?
        let nullNodes = managedObjectContext.executeFetchRequest(nullNodeRequest, error: &error) as! [NullNode]!
        if error != nil {
            return nil
        }
        if nullNodes.count == 0 {
            var result = NSEntityDescription.insertNewObjectForEntityForName("NullNode", inManagedObjectContext: managedObjectContext) as? NullNode
            result!.frame = frame!
            return result
        } else {
            return nullNodes[0]
        }
    }

    func createConstantBufferNode() {
        var newBufferNode : ConstantBufferNode = NSEntityDescription.insertNewObjectForEntityForName("ConstantBufferNode", inManagedObjectContext: managedObjectContext) as! ConstantBufferNode
        newBufferNode.populate(nullNode!, context: managedObjectContext)
        newBufferNode.positionX = 13
        newBufferNode.positionY = 17
        newBufferNode.payload = "test".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        newBufferNode.frame = frame!
        addView(newBufferNode)
    }

    func populate() {
        var nodeRequest = managedObjectModel.fetchRequestFromTemplateWithName("NodeRequest", substitutionVariables: [:]) as NSFetchRequest!
        var error: NSError?
        let nodes = managedObjectContext.executeFetchRequest(nodeRequest, error: &error) as! [Node]!
        if error != nil {
            return
        }
        for node in nodes {
            if node.frame == frame {
                addView(node)
            }
        }
        //println("Ambiguities: \(findViewsWithAmbiguousLayouts())")
    }

    func addView(node: Node) {
        let nodeViewController = NodeViewController(nibName: "NodeViewController", bundle: nil) as NodeViewController!
        (nodeViewController.view as! NodeView).graphViewController = self
        addChildViewController(nodeViewController)
        view.addSubview(nodeViewController.view)
        nodeViewController.leadingConstraint = NSLayoutConstraint(item: nodeViewController.view, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: CGFloat(node.positionX))
        nodeViewController.topConstraint = NSLayoutConstraint(item: nodeViewController.view, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: CGFloat(node.positionY))
        view.addConstraint(nodeViewController.leadingConstraint)
        view.addConstraint(nodeViewController.topConstraint)

        for i in node.inputs {
            nodeViewController.addInputOutputView("aaa", alignment: .LeftTextAlignment, stackView: nodeViewController.inputsView)
        }
        for o in node.outputs {
            nodeViewController.addInputOutputView("aaa", alignment: .RightTextAlignment, stackView: nodeViewController.outputsView)
        }
        
        nodeViewController.node = node
        //println("Ambiguities: \(findViewsWithAmbiguousLayouts())")
    }

    override func mouseDown(theEvent: NSEvent) {
        var hit = view.hitTest(view.superview!.convertPoint(theEvent.locationInWindow, fromView: nil)) as NSView!
        // This search kind of blows. The hit test already knows what was hit.
        for child in childViewControllers {
            if let c = child as? NodeViewController {
                if hit == c.titleView {
                    let currentMouseLocation = theEvent.locationInWindow
                    var draggingStartPoint = NSPoint()
                    draggingStartPoint.x = c.leadingConstraint.constant
                    draggingStartPoint.y = c.topConstraint.constant
                    draggingStartPoint.x -= currentMouseLocation.x
                    draggingStartPoint.y += currentMouseLocation.y
                    dragOperation = .Move(c, draggingStartPoint)
                    return
                } else {
                    // See if we are dragging from a connection point
                    var j: UInt = 0
                    for input in c.inputsView.views {
                        if let i = input as? NSView {
                            if hit == i {
                                dragOperation = .Connect(c, j)
                                return
                            }
                            ++j
                        }
                    }
                }
            }
        }
    }

    override func mouseDragged(theEvent: NSEvent) {
        if let op = dragOperation {
            switch op {
                case .Move(let draggingNodeViewController, let draggingStartPoint):
                    let currentMouseLocation = theEvent.locationInWindow
                    draggingNodeViewController.leadingConstraint.constant = draggingStartPoint.x + currentMouseLocation.x
                    draggingNodeViewController.topConstraint.constant = draggingStartPoint.y - currentMouseLocation.y
                    draggingNodeViewController.node.positionX = Float(draggingNodeViewController.leadingConstraint.constant)
                    draggingNodeViewController.node.positionY = Float(draggingNodeViewController.topConstraint.constant)
                    connectionsView.setNeedsDisplayInRect(connectionsView.bounds)
                case .Connect(let startNodeViewController, let startNodeIndex):
                    let mouseLocation = connectionsView.convertPoint(theEvent.locationInWindow, fromView: nil)
                    if connectionsView.connectionInFlight != nil {
                        connectionsView.connectionInFlight!.1 = mouseLocation
                    } else {
                        connectionsView.connectionInFlight = (Connection(startNodeViewControllerInput: startNodeViewController, startIndexInput: startNodeIndex, endNodeViewControllerInput: startNodeViewController, endIndexInput: startNodeIndex), mouseLocation)
                    }
                    connectionsView.setNeedsDisplayInRect(connectionsView.bounds)
            }
        }
    }

    override func mouseUp(theEvent: NSEvent) {
        if let op = dragOperation {
            switch op {
                case .Move:
                    dragOperation = nil
                    return
                case .Connect(let startNodeViewController, let startNodeIndex):
                    connectionsView.connectionInFlight = nil
                    connectionsView.setNeedsDisplayInRect(connectionsView.bounds)
                    var hit = view.hitTest(view.superview!.convertPoint(theEvent.locationInWindow, fromView: nil)) as NSView!
                    for child in childViewControllers {
                        if let c = child as? NodeViewController {
                            var i: UInt = 0
                            for output in c.outputsView.views {
                                if let o = output as? NSView {
                                    if hit == o {
                                        connectionsView.connections.append(Connection(startNodeViewControllerInput: startNodeViewController, startIndexInput: startNodeIndex, endNodeViewControllerInput: c, endIndexInput: i))
                                        connectionsView.setNeedsDisplayInRect(connectionsView.bounds)

                                        var edge = NSEntityDescription.insertNewObjectForEntityForName("Edge", inManagedObjectContext: managedObjectContext) as! Edge
                                        edge.source = startNodeViewController.node
                                        edge.destination = c.node
                                        startNodeViewController.node.mutableOrderedSetValueForKey("inputs")[Int(startNodeIndex)] = edge
                                        c.node.mutableOrderedSetValueForKey("outputs")[Int(i)] = edge
                                        dragOperation = nil
                                        return
                                    }
                                    ++i
                                }
                            }
                        }
                    }
            }
        }
    }

    func findViewsWithAmbiguousLayoutsHelper(v: NSView) -> [NSView] {
        var result: [NSView] = []
        if v.hasAmbiguousLayout {
            result.append(v)
        }
        for c in v.subviews {
            result.extend(findViewsWithAmbiguousLayoutsHelper(c as! NSView))
        }
        return result
    }
    func findViewsWithAmbiguousLayouts() -> [NSView] {
        view.updateConstraints()
        view.layoutSubtreeIfNeeded()
        return findViewsWithAmbiguousLayoutsHelper(view)
    }
}