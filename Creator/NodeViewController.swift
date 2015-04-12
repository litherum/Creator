//
//  NodeViewController.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class NodeViewController: NSViewController {
    @IBOutlet var titleView: NSTextField!
    @IBOutlet var inputsView: NSStackView!
    @IBOutlet var outputsView: NSStackView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        for i in 0 ..< 2 {
            var foo = NSTextField()
            foo.translatesAutoresizingMaskIntoConstraints = false
            foo.selectable = false
            foo.drawsBackground = false
            foo.bezeled = false
            foo.stringValue = "Input"
            inputsView.addView(foo, inGravity: .Center)
        }

        var bar = NSTextField()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.selectable = false
        bar.drawsBackground = false
        bar.bezeled = false
        bar.stringValue = "Output"
        outputsView.addView(bar, inGravity: .Center)
    }
}
