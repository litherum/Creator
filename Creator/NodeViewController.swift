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
    var leadingConstraint: NSLayoutConstraint!
    var topConstraint: NSLayoutConstraint!
    var node: Node!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    func addInputOutputView(value: String, alignment: NSTextAlignment, stackView: NSStackView!) {
        var foo = NSTextField()
        foo.translatesAutoresizingMaskIntoConstraints = false
        foo.selectable = false
        foo.drawsBackground = false
        foo.bezeled = false
        foo.alignment = alignment
        foo.stringValue = value
        stackView.addView(foo, inGravity: .Center)
    }

    override func viewDidLoad() {
    }

    override func viewWillAppear() {
        //view.window?.visualizeConstraints(view.subviews[0].constraints)
    }
}
