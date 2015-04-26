//
//  ConstantFloatDetailsViewController.swift
//  Creator
//
//  Created by Litherum on 4/25/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class ConstantFloatDetailsViewController: NSViewController {
    var node: ConstantFloatNode!
    @IBOutlet var maxTextField: NSTextField!
    @IBOutlet var slider: NSSlider!
    @IBOutlet var minTextField: NSTextField!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, node: ConstantFloatNode) {
        self.node = node
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewWillAppear() {
        // FIXME: Bindings don't appear to be working :(

        maxTextField.floatValue = node.maxValue
        minTextField.floatValue = node.minValue
        slider.maxValue = Double(node.maxValue)
        slider.minValue = Double(node.minValue)
        slider.floatValue = node.payload
    }

    @IBAction func maxValueSet(sender: NSTextField) {
        node.maxValue = maxTextField.floatValue
        slider.maxValue = Double(node.maxValue)
    }

    @IBAction func minValueSet(sender: NSTextField) {
        node.minValue = minTextField.floatValue
        slider.minValue = Double(node.minValue)
    }

    @IBAction func payloadSet(sender: NSSlider) {
        node.payload = slider.floatValue
    }
}
