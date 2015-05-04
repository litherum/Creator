//
//  Document.swift
//  Creator
//
//  Created by Litherum on 4/10/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class Document: NSPersistentDocument {
    @IBOutlet var graphViewController: GraphViewController!
    @IBOutlet var resultView: ResultView!

    override init() {
        super.init()
    }

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)

        graphViewController.managedObjectContext = managedObjectContext
        graphViewController.managedObjectModel = managedObjectModel
        graphViewController.populate()

        resultView.document = self
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override var windowNibName: String? {
        return "Document"
    }

    func execute() {
        graphViewController.frame.execute()
    }

    @IBAction func createConstantBufferNode(sender: AnyObject?) {
        graphViewController.createConstantBufferNode()
    }

    @IBAction func createVertexShaderNode(sender: AnyObject?) {
        graphViewController.createVertexShaderNode()
    }

    @IBAction func createFragmentShaderNode(sender: AnyObject?) {
        graphViewController.createFragmentShaderNode()
    }

    @IBAction func createConstantFloatNode(sender: AnyObject?) {
        graphViewController.createConstantFloatNode()
    }
}
