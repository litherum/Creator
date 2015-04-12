//
//  GraphViewController.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class GraphViewController: NSViewController {
    var frame : Frame?
    var managedObjectContext: NSManagedObjectContext!
    var managedObjectModel: AnyObject!

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

        var frameRequest = managedObjectModel.fetchRequestFromTemplateWithName("FrameRequest", substitutionVariables: [:]) as NSFetchRequest!
        var error: NSError?
        let frames = managedObjectContext.executeFetchRequest(frameRequest, error: &error) as! [Frame]!
        if error != nil {
            return
        }
        if frames.count == 0 {
            frame = NSEntityDescription.insertNewObjectForEntityForName("Frame", inManagedObjectContext: managedObjectContext) as? Frame
        } else {
            frame = frames[0]
        }

        var nodeRequest = managedObjectModel.fetchRequestFromTemplateWithName("NodeRequest", substitutionVariables: [:]) as NSFetchRequest!
        let nodes = managedObjectContext.executeFetchRequest(nodeRequest, error: &error) as! [Node]!
        if error != nil {
            return
        }
        for node in nodes {
            addView(node)
        }
    }

    func addView(node : Node) {
        var newView = NodeView()
        newView.frame = NSMakeRect(CGFloat(node.positionX), CGFloat(node.positionY), CGFloat(100), CGFloat(100))
        view.subviews.append(newView)

        view.addConstraint(NSLayoutConstraint(item: view, attribute: .Trailing, relatedBy: .GreaterThanOrEqual, toItem: newView, attribute: .Trailing, multiplier: CGFloat(1), constant: CGFloat(0)))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .LessThanOrEqual, toItem: newView, attribute: .Top, multiplier: CGFloat(1), constant: CGFloat(0)))

        println("Done")
    }

    override func viewDidLoad() {
        println("View did load")
    }
}