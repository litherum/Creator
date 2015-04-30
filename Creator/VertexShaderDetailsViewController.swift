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
    }

    override func viewWillDisappear() {
        if let s = textView.string {
            nodeViewController.setShaderSource(s)
        }
    }

    @IBAction func selectedSize(sender: NSPopUpButton) {
        node.attributeInputPort(vertexAttribTableView.rowForView(sender))!.attributeSize = Int16(sender.indexOfSelectedItem) + 1
    }

    // FIXME: Populate this function
    @IBAction func selectedType(sender: NSPopUpButton) {
        node.attributeInputPort(vertexAttribTableView.rowForView(sender))!.attributeType = typeIndexToType(sender.indexOfSelectedItem)
    }

    @IBAction func selectedNormalized(sender: NSButton) {
        node.attributeInputPort(vertexAttribTableView.rowForView(sender))!.attributeNormalized = sender.state == NSOnState
    }

    @IBAction func selectedStride(sender: NSTextField) {
        node.attributeInputPort(vertexAttribTableView.rowForView(sender))!.attributeStride = sender.intValue
    }

    @IBAction func selectedOffset(sender: NSTextField) {
        node.attributeInputPort(vertexAttribTableView.rowForView(sender))!.attributeOffset = sender.intValue
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if let program = node.program {
            return node.attributeInputPortCount
        } else {
            return 0
        }
    }

    // These need to be kept in sync with the .nib
    func typeIndexToType(index: Int) -> Int32 {
        return [GL_BYTE, GL_UNSIGNED_BYTE, GL_SHORT, GL_UNSIGNED_SHORT, GL_INT, GL_UNSIGNED_INT, GL_HALF_FLOAT, GL_FLOAT, GL_DOUBLE, GL_FIXED, GL_INT_2_10_10_10_REV, GL_UNSIGNED_INT_2_10_10_10_REV][index]
    }

    func typeToTypeIndex(type: Int32) -> Int {
        switch type {
            case GL_BYTE:
                return 0
            case GL_UNSIGNED_BYTE:
                return 1
            case GL_SHORT:
                return 2
            case GL_UNSIGNED_SHORT:
                return 3
            case GL_INT:
                return 4
            case GL_UNSIGNED_INT:
                return 5
            case GL_HALF_FLOAT:
                return 6
            case GL_FLOAT:
                return 7
            case GL_DOUBLE:
                return 8
            case GL_FIXED:
                return 9
            case GL_INT_2_10_10_10_REV:
                return 10
            case GL_UNSIGNED_INT_2_10_10_10_REV:
                return 11
            default:
                return -1
        }
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let program = node.program {
            if tableColumn!.identifier ==  "NameColumn" {
                var view = tableView.makeViewWithIdentifier("Name", owner: self) as! NSTableCellView
                view.textField!.stringValue = node.attributeInputPort(row)!.title
                return view
            } else if tableColumn!.identifier ==  "SizeColumn" {
                var view = tableView.makeViewWithIdentifier("Size", owner: self) as! NSPopUpButton!
                view.selectItemAtIndex(Int(node.attributeInputPort(row)!.attributeSize - 1))
                return view
            } else if tableColumn!.identifier ==  "TypeColumn" {
                var view = tableView.makeViewWithIdentifier("Type", owner: self) as! NSPopUpButton!
                view.selectItemAtIndex(typeToTypeIndex(node.attributeInputPort(row)!.attributeType))
                return view
            } else if tableColumn!.identifier ==  "NormalizedColumn" {
                var view = tableView.makeViewWithIdentifier("Normalized", owner: self) as! NSButton!
                view.state = node.attributeInputPort(row)!.attributeNormalized ? NSOnState : NSOffState
                return view
            } else if tableColumn!.identifier ==  "StrideColumn" {
                var view = tableView.makeViewWithIdentifier("Stride", owner: self) as! NSTextField!
                view.intValue = node.attributeInputPort(row)!.attributeStride
                return view
            } else if tableColumn!.identifier ==  "OffsetColumn" {
                var view = tableView.makeViewWithIdentifier("Offset", owner: self) as! NSTextField!
                view.intValue = node.attributeInputPort(row)!.attributeOffset
                return view
            }
        }
        return nil
    }
}