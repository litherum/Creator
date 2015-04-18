//
//  NodeViewController.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class NodeViewController: NSViewController {
    weak var graphViewController: GraphViewController!
    weak var leadingConstraint: NSLayoutConstraint!
    weak var topConstraint: NSLayoutConstraint!
    @IBOutlet var titleView: NodeTitleTextField!
    @IBOutlet var inputsView: NSStackView!
    @IBOutlet var outputsView: NSStackView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        titleView.graphViewController = graphViewController
        titleView.nodeViewController = self
    }

    func addInputOutputView(value: String, alignment: NSTextAlignment, stackView: NSStackView!, index: UInt) {
        var inputOutputTextField = NodeInputOutputTextField()
        
        inputOutputTextField.graphViewController = graphViewController
        inputOutputTextField.nodeViewController = self
        inputOutputTextField.index = index

        inputOutputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputOutputTextField.selectable = false
        inputOutputTextField.drawsBackground = false
        inputOutputTextField.bezeled = false
        inputOutputTextField.alignment = alignment
        inputOutputTextField.stringValue = value
        stackView.addView(inputOutputTextField, inGravity: .Center)
    }
}
