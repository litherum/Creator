//
//  NodeDetailsViewController.swift
//  Creator
//
//  Created by Litherum on 4/21/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class VertexShaderDetailsViewController: NSViewController {
    var node: VertexShaderNode!
    @IBOutlet var textView: NSTextView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, node: VertexShaderNode) {
        self.node = node
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewWillAppear() {
        textView.string = node.source
    }

    override func viewWillDisappear() {
        if let s = textView.string {
            node.source = s
            // FIXME: Need to repopulate the node, and possibly repopulate any programs
        }
    }
}