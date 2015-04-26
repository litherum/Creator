//
//  FragmentShaderDetailsOutputRowViewController.swift
//  Creator
//
//  Created by Litherum on 4/25/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class FragmentShaderDetailsOutputRowViewController: NSViewController {
    weak var fragmentShaderDetailsViewController: FragmentShaderDetailsViewController!
    var index: Int = 0
    @IBOutlet var nameTextField: NSTextField!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, fragmentShaderDetailsViewController: FragmentShaderDetailsViewController, index: Int) {
        self.fragmentShaderDetailsViewController = fragmentShaderDetailsViewController
        self.index = index
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @IBAction func deleteRow(sender: NSButton) {
        fragmentShaderDetailsViewController.deleteRow(index)
    }

    @IBAction func nameModified(sender: NSTextField) {
        fragmentShaderDetailsViewController.renameOutput(index, newName: sender.stringValue)
    }
}
