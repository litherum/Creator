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
    var foo : NSTextField!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        for i in 0 ..< 5 {
        foo = NSTextField()
        foo.translatesAutoresizingMaskIntoConstraints = false
        foo.selectable = false
        foo.drawsBackground = false
        foo.bezeled = false
        foo.stringValue = "Foo Foo Foo"
        inputsView.addView(foo, inGravity: .Center)
        }
        //foo.addConstraint(NSLayoutConstraint(item: foo, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: CGFloat(1), constant: CGFloat(150)))
        //foo.addConstraint(NSLayoutConstraint(item: foo, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: CGFloat(1), constant: CGFloat(150)))

        /*var bar = NSTextField()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.stringValue = "Bar"
        outputsView.addView(bar, inGravity: .Center)
        bar.addConstraint(NSLayoutConstraint(item: bar, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: CGFloat(1), constant: CGFloat(150)))
        bar.addConstraint(NSLayoutConstraint(item: bar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: CGFloat(1), constant: CGFloat(150)))*/
    }

    /*override func viewDidAppear() {
        view.window?.visualizeConstraints(foo.constraints)
    }*/
}
