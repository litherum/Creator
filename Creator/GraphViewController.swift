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
    }

    func addView(node : Node) {
        let nodeViewController = NodeViewController(nibName: "NodeViewController", bundle: nil) as NodeViewController!
        view.frame = NSMakeRect(0, 0, NSMaxX(nodeViewController.view.frame), NSMaxY(nodeViewController.view.frame))
        addChildViewController(nodeViewController)
        view.addSubview(nodeViewController.view)

        view.addConstraint(NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: CGFloat(1), constant: NSMaxX(nodeViewController.view.frame)))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: CGFloat(1), constant: NSMaxY(nodeViewController.view.frame)))
        println("Success")
    }

    override func viewDidLoad() {
        println("View did load")
    }
}