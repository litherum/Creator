//
//  GraphViewController.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class GraphViewController: NSViewController {
    lazy var frame : Frame? = self.fetchFrame()
    var managedObjectContext: NSManagedObjectContext!
    var managedObjectModel: AnyObject!

    var draggingNodeViewController: NodeViewController!
    var draggingStartPoint: NSPoint!

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

    func createConstantBufferNode() {
        if let unwrappedFrame = frame {
            var newBufferNode : ConstantBufferNode = NSEntityDescription.insertNewObjectForEntityForName("ConstantBufferNode", inManagedObjectContext: managedObjectContext) as! ConstantBufferNode
            newBufferNode.positionX = 13
            newBufferNode.positionY = 17
            newBufferNode.payload = "test".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            newBufferNode.frame = unwrappedFrame
            addView(newBufferNode)
        }
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

    func addView(node : Node) {
        let nodeViewController = NodeViewController(nibName: "NodeViewController", bundle: nil) as NodeViewController!
        (nodeViewController.view as! NodeView).graphViewController = self
        addChildViewController(nodeViewController)
        view.addSubview(nodeViewController.view)
        nodeViewController.leadingConstraint = NSLayoutConstraint(item: nodeViewController.view, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: CGFloat(node.positionX))
        nodeViewController.topConstraint = NSLayoutConstraint(item: nodeViewController.view, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: CGFloat(node.positionY))
        view.addConstraint(nodeViewController.leadingConstraint)
        view.addConstraint(nodeViewController.topConstraint)
        nodeViewController.node = node
        //println("Ambiguities: \(findViewsWithAmbiguousLayouts())")
    }

    override func viewDidLoad() {
        //println("View did load")
    }

    override func mouseDown(theEvent: NSEvent) {
        var hit = view.hitTest(view.superview!.convertPoint(theEvent.locationInWindow, fromView: nil)) as NSView!
        for child in childViewControllers {
            if let c = child as? NodeViewController {
                if hit == c.titleView {
                    draggingNodeViewController = c
                    let currentMouseLocation = NSEvent.mouseLocation()
                    draggingStartPoint = NSPoint()
                    draggingStartPoint.x = draggingNodeViewController.leadingConstraint.constant
                    draggingStartPoint.y = draggingNodeViewController.topConstraint.constant
                    draggingStartPoint.x -= currentMouseLocation.x
                    draggingStartPoint.y += currentMouseLocation.y
                    break
                }
            }
        }
    }

    override func mouseDragged(theEvent: NSEvent) {
        if draggingNodeViewController != nil && draggingStartPoint != nil {
            let currentMouseLocation = NSEvent.mouseLocation()
            draggingNodeViewController.leadingConstraint.constant = draggingStartPoint.x + currentMouseLocation.x
            draggingNodeViewController.topConstraint.constant = draggingStartPoint.y - currentMouseLocation.y
            draggingNodeViewController.node.positionX = Float(draggingNodeViewController.leadingConstraint.constant)
            draggingNodeViewController.node.positionY = Float(draggingNodeViewController.topConstraint.constant)
        }
    }

    override func mouseUp(theEvent: NSEvent) {
        draggingNodeViewController = nil
        draggingStartPoint = nil
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