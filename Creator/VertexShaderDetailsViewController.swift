//
//  NodeDetailsViewController.swift
//  Creator
//
//  Created by Litherum on 4/21/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class VertexShaderDetailsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    weak var nodeViewController: NodeViewController!
    var node: VertexShaderNode!
    @IBOutlet var vertexAttribTableView: NSTableView!
    @IBOutlet var textView: NSTextView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, nodeViewController: NodeViewController, node: VertexShaderNode) {
        self.nodeViewController = nodeViewController
        self.node = node
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewWillAppear() {
        textView.string = node.source
        println("\(vertexAttribTableView.superview!.superview!.frame)")
    }

    override func viewWillDisappear() {
        if let s = textView.string {
            nodeViewController.setShaderSource(s)
        }
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return 5
        /*if let program = node.program {
            return program.attributeCount
        } else {
            return 0
        }*/
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        return tableView.makeViewWithIdentifier("Size", owner: self) as! NSView?
    }
}