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
        var foo = NSTextField()
        foo.stringValue = "Foo"
        inputsView.addView(foo, inGravity: .Center)
        //inputsView.addConstraint(NSLayoutConstraint(item: inputsView, attribute: .Leading, relatedBy: .Equal, toItem: foo, attribute: .Leading, multiplier: CGFloat(1), constant: CGFloat(0)))
        //inputsView.addConstraint(NSLayoutConstraint(item: inputsView, attribute: .Trailing, relatedBy: .Equal, toItem: foo, attribute: .Trailing, multiplier: CGFloat(1), constant: CGFloat(0)))
        //inputsView.addConstraint(NSLayoutConstraint(item: inputsView, attribute: .Top, relatedBy: .Equal, toItem: foo, attribute: .Top, multiplier: CGFloat(1), constant: CGFloat(0)))
        //inputsView.addConstraint(NSLayoutConstraint(item: inputsView, attribute: .Bottom, relatedBy: .Equal, toItem: foo, attribute: .Bottom, multiplier: CGFloat(1), constant: CGFloat(0)))

        var bar = NSTextField()
        bar.stringValue = "Bar"
        outputsView.addView(bar, inGravity: .Center)
        //outputsView.addConstraint(NSLayoutConstraint(item: outputsView, attribute: .Leading, relatedBy: .Equal, toItem: bar, attribute: .Leading, multiplier: CGFloat(1), constant: CGFloat(0)))
        //outputsView.addConstraint(NSLayoutConstraint(item: outputsView, attribute: .Trailing, relatedBy: .Equal, toItem: bar, attribute: .Trailing, multiplier: CGFloat(1), constant: CGFloat(0)))
        //outputsView.addConstraint(NSLayoutConstraint(item: outputsView, attribute: .Top, relatedBy: .Equal, toItem: bar, attribute: .Top, multiplier: CGFloat(1), constant: CGFloat(0)))
        //outputsView.addConstraint(NSLayoutConstraint(item: outputsView, attribute: .Bottom, relatedBy: .Equal, toItem: bar, attribute: .Bottom, multiplier: CGFloat(1), constant: CGFloat(0)))
    }
}
