//
//  FragmentShaderDetailsViewController.swift
//  Creator
//
//  Created by Litherum on 4/25/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class FrameDetailsViewController: NSViewController {
    weak var nodeViewController: NodeViewController!
    var node: Frame!
    @IBOutlet var selectedInputPopup: NSPopUpButton!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, nodeViewController: NodeViewController, node: Frame) {
        self.nodeViewController = nodeViewController
        self.node = node
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @IBAction func addInput(sender: NSButton) {
        let newIndex = node.inputs.count
        nodeViewController.addInput("Pass")
        addPopupItem(newIndex)
    }

    @IBAction func deleteSelectedInput(sender: NSButton) {
        let selectedInput = selectedInputPopup.indexOfSelectedItem
        selectedInputPopup.removeItemAtIndex(selectedInput)
        nodeViewController.deleteInput(selectedInput)
        for i in selectedInput ..< selectedInputPopup.numberOfItems {
            selectedInputPopup.itemAtIndex(i)!.title = "\(i)"
        }
    }

    func addPopupItem(index: Int) {
        // FIXME: Maybe we should be using NSArrayController instead?
        selectedInputPopup.addItemWithTitle("\(selectedInputPopup.numberOfItems)")
    }

    override func viewWillAppear() {
        for i in 0 ..< node.inputs.count {
            addPopupItem(i)
        }
    }
}
