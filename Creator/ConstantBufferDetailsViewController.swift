//
//  ConstantBufferDetailsViewController.swift
//  Creator
//
//  Created by Litherum on 4/25/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class ConstantBufferDetailsViewController: NSViewController {
    var node: ConstantBufferNode!
    @IBOutlet var statusTextField: NSTextField!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, node: ConstantBufferNode) {
        self.node = node
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @IBAction func chooseFile(sender: NSButton) {
        var openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.beginSheetModalForWindow(view.window!, completionHandler: { (result: Int) in
            self.statusTextField.hidden = false
            if result == NSFileHandlingPanelCancelButton {
                return
            }
            if openPanel.URLs.count != 1 {
                self.statusTextField.stringValue = "Should select exactly one file"
                return
            }
            let data = NSData(contentsOfURL: openPanel.URLs[0] as! NSURL)
            if data == nil {
                self.statusTextField.stringValue = "Could not read file"
                return
            }
            self.node.payload = data!
            self.statusTextField.stringValue = "Success"
        })
    }
}
