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

    func addInputView(value: String, alignment: NSTextAlignment, stackView: NSStackView!) {
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
        addInputView("a", alignment: .LeftTextAlignment, stackView: inputsView)
        addInputView("aa", alignment: .LeftTextAlignment, stackView: inputsView)
        //addInputView("aaa", alignment: .LeftTextAlignment, stackView: inputsView)
        //addInputView("aaaa", alignment: .LeftTextAlignment, stackView: inputsView)
        addInputView("a", alignment: .RightTextAlignment, stackView: outputsView)
        addInputView("aa", alignment: .RightTextAlignment, stackView: outputsView)
        addInputView("aaa", alignment: .RightTextAlignment, stackView: outputsView)
    }

    override func viewWillAppear() {
        //view.window?.visualizeConstraints(view.subviews[0].constraints)
    }
}
