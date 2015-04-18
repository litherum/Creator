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
    var nodeViewControllerToNodeDictionary: [NodeViewController: Node] = [:]
    var nodeToNodeViewControllerDictionary: [Node: NodeViewController] = [:]
    var managedObjectContext: NSManagedObjectContext!
    var managedObjectModel: AnyObject!

    @IBOutlet var connectionsView: ConnectionsView!

    enum DragOperation {
        case Move(Node, NSPoint)
        case Connect(Node, UInt)
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
        nodeViewController.graphViewController = self
        nodeViewControllerToNodeDictionary[nodeViewController] = node
        nodeToNodeViewControllerDictionary[node] = nodeViewController
        addChildViewController(nodeViewController)
        view.addSubview(nodeViewController.view)
        let leadingConstraint = NSLayoutConstraint(item: nodeViewController.view, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: CGFloat(node.positionX))
        let topConstraint = NSLayoutConstraint(item: nodeViewController.view, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: CGFloat(node.positionY))
        view.addConstraint(leadingConstraint)
        view.addConstraint(topConstraint)
        nodeViewController.leadingConstraint = leadingConstraint
        nodeViewController.topConstraint = topConstraint

        for i in 0 ..< node.inputs.count {
            nodeViewController.addInputOutputView("aaa", alignment: .LeftTextAlignment, stackView: nodeViewController.inputsView, index: UInt(i))
        }
        for i in 0 ..< node.outputs.count {
            nodeViewController.addInputOutputView("aaa", alignment: .RightTextAlignment, stackView: nodeViewController.outputsView, index: UInt(i))
        }
    }

    func nodeInputOutputMouseDown(nodeViewController: NodeViewController, index: UInt) {
        dragOperation = .Connect(nodeViewControllerToNodeDictionary[nodeViewController]!, index)
    }

    func nodeInputOutputMouseUp(nodeViewController: NodeViewController, index: UInt) {
        //dragOperation = .Connect(nodeViewControllerToNodeDictionary[nodeViewController]!, index)
        if let dragOperation = dragOperation {
            switch (dragOperation) {
            case .Connect(let node, let index):
                let inputView = nodeToNodeViewControllerDictionary[node]!.view
                let outputView = nodeViewController.view
                let startPoint = connectionsView.convertPoint(NSMakePoint(0, (inputView.bounds.origin.y + inputView.bounds.maxY) / 2), fromView: inputView)
                let endPoint = connectionsView.convertPoint(NSMakePoint(outputView.bounds.maxX, (outputView.bounds.origin.y + outputView.bounds.maxY) / 2), fromView: outputView)
                connectionsView.connections.append(Connection(startPoint: startPoint, endPoint: endPoint))
            default:
                break
            }
        }
        dragOperation = nil
    }

    func nodeTitleMouseDown(nodeViewController: NodeViewController, mouseLocation: NSPoint) {
        var draggingStartPoint = NSPoint(x: nodeViewController.leadingConstraint.constant, y: nodeViewController.topConstraint.constant)
        draggingStartPoint.x -= mouseLocation.x
        draggingStartPoint.y += mouseLocation.y
        dragOperation = .Move(nodeViewControllerToNodeDictionary[nodeViewController]!, draggingStartPoint)
    }

    func nodeTitleMouseUp(nodeViewController: NodeViewController, mouseLocation: NSPoint) {
        dragOperation = nil
    }
/*
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

                                        managedObjectContext.deleteObject(startNodeViewController.node.inputs[Int(startNodeIndex)] as! Edge)
                                        managedObjectContext.deleteObject(c.node.outputs[Int(i)] as! Edge)
                                        var edge = NSEntityDescription.insertNewObjectForEntityForName("Edge", inManagedObjectContext: managedObjectContext) as! Edge
                                        var inputSet = startNodeViewController.node.mutableOrderedSetValueForKey("inputs")
                                        inputSet.removeObjectAtIndex(Int(startNodeIndex))
                                        inputSet.insertObject(edge, atIndex: Int(startNodeIndex))
                                        var outputSet = c.node.mutableOrderedSetValueForKey("outputs")
                                        outputSet.removeObjectAtIndex(Int(i))
                                        outputSet.insertObject(edge, atIndex: Int(i))
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
*/
}