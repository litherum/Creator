//
//  FragmentShaderDetailsViewController.swift
//  Creator
//
//  Created by Litherum on 4/25/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class FragmentShaderDetailsViewController: NSViewController {
    weak var nodeViewController: NodeViewController!
    var node: FragmentShaderNode!
    @IBOutlet var outputRows: NSStackView!
    @IBOutlet var textView: NSTextView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, node: FragmentShaderNode) {
        self.node = node
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @IBAction func addOutput(sender: NSButton) {
        let newIndex = node.outputs.count
        nodeViewController.addOutput("New output")
        addRow(newIndex)
    }

    func checkConsistency() {
        for i in 0 ..< childViewControllers.count {
            assert((childViewControllers[i] as! FragmentShaderDetailsOutputRowViewController).index == i, "Fragment shader details output indices should match up")
        }
    }

    func addRow(index: Int) {
        // FIXME: Maybe we should be using NSArrayController instead?
        var newRowController = FragmentShaderDetailsOutputRowViewController(nibName: "FragmentShaderDetailsOutputRowViewController", bundle: nil, fragmentShaderDetailsViewController: self, index: index)!
        outputRows.addView(newRowController.view, inGravity: .Top)
        
        checkConsistency()

        addChildViewController(newRowController)

        checkConsistency()

        newRowController.nameTextField.stringValue = (node.outputs[index] as! OutputPort).title
    }

    func deleteRow(index: Int) {
        var viewController = childViewControllers[index] as! FragmentShaderDetailsOutputRowViewController
        outputRows.removeView(viewController.view)
        nodeViewController.deleteOutput(index)

        checkConsistency()

        for i in viewController.index ..< childViewControllers.count {
            (childViewControllers[i] as! FragmentShaderDetailsOutputRowViewController).index--
        }
        removeChildViewControllerAtIndex(index)

        checkConsistency()
    }

    func renameOutput(index: Int, newName: String) {
        checkConsistency()
        nodeViewController.renameOutput(index, newName: newName)
        checkConsistency()
    }

    override func viewWillAppear() {
        textView.string = node.source
        for i in 0 ..< node.outputs.count {
            addRow(i)
        }
    }

    override func viewWillDisappear() {
        if let s = textView.string {
            node.source = s
            // FIXME: Need to repopulate the node, and possibly repopulate any programs
        }
    }
}
