//
//  NodeViewController.swift
//  Creator
//
//  Created by Litherum on 4/11/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import Cocoa

class NodeViewController: NSViewController {
    var node: Node!
    var nullNode: NullNode!
    var managedObjectContext: NSManagedObjectContext!
    weak var graphViewController: GraphViewController!
    weak var leadingConstraint: NSLayoutConstraint!
    weak var topConstraint: NSLayoutConstraint!
    var draggingStartPoint: NSPoint?
    @IBOutlet var titleView: NodeTitleTextField!
    @IBOutlet var inputsView: NSStackView!
    @IBOutlet var outputsView: NSStackView!
    @IBOutlet var detailsPopover: NSPopover!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, node: Node, nullNode: NullNode, managedObjectContext: NSManagedObjectContext) {
        self.node = node
        self.nullNode = nullNode
        self.managedObjectContext = managedObjectContext
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        titleView.graphViewController = graphViewController
        titleView.nodeViewController = self
        node.nodeViewController = self
    }

    func setShaderSource(source: String) {
        var program: Program?
        if let vertexShaderNode = node as? VertexShaderNode {
            vertexShaderNode.source = source
            let compilationLog = vertexShaderNode.compile()
            if let log = compilationLog {
                println("Could not compile! Log:")
                println(log)
            }
            program = vertexShaderNode.program
        } else if let fragmentShaderNode = node as? FragmentShaderNode {
            fragmentShaderNode.source = source
            let compilationLog = fragmentShaderNode.compile()
            if let log = compilationLog {
                println("Could not compile! Log:")
                println(log)
            }
            program = fragmentShaderNode.program
        }

        if let program = program {
            let linkLog = program.link()
            if let log = linkLog {
                println("Could not link! Log:")
                println(log)
            }

            // FIXME: This algorithm is very slow
            var foundInputs: [InputPort] = []
            program.iterateOverAttributes({(index: GLuint, name: String, size: GLint, type: GLenum) in
                for input in program.vertexShader.inputs {
                    if let input = input as? AttributeInputPort {
                        if input.title == name && GLint(input.glSize) == size && GLenum(input.glType) == type {
                            input.glIndex = Int32(index)
                            foundInputs.append(input)
                            break
                        }
                    }
                }
            })
            program.iterateOverUniforms({(index: GLuint, name: String, size: GLint, type: GLenum) in
                for input in program.vertexShader.inputs {
                    if let input = input as? UniformInputPort {
                        if input.title == name && GLint(input.glSize) == size && GLenum(input.glType) == type {
                            input.glIndex = Int32(index)
                            foundInputs.append(input)
                            break
                        }
                    }
                }
            })
            while true {
                var exhausted = true
                for i in 0 ..< program.vertexShader.inputs.count {
                    if !contains(foundInputs, program.vertexShader.inputs[i] as! InputPort) {
                        deleteInput(i)
                        exhausted = false
                        break
                    }
                }
                if exhausted {
                    break
                }
            }
            program.iterateOverAttributes({(index: GLuint, name: String, size: GLint, type: GLenum) in
                var found = false
                for port in foundInputs {
                    if let port = port as? AttributeInputPort {
                        if port.glIndex == Int32(index) {
                            found = true
                            break
                        }
                    }
                }
                if !found {
                    program.vertexShader.nodeViewController.addAttributeInput(index, name: name, size: size, type: type)
                }
            })
            program.iterateOverUniforms({(index: GLuint, name: String, size: GLint, type: GLenum) in
                var found = false
                for port in foundInputs {
                    if let port = port as? UniformInputPort {
                        if port.glIndex == Int32(index) {
                            found = true
                            break
                        }
                    }
                }
                if !found {
                    program.vertexShader.nodeViewController.addUniformInput(index, name: name, size: size, type: type)
                }
            })
        }
    }

    func addInputOutputView(value: String, input: Bool) {
        var stackView = input ? inputsView : outputsView
        let index = stackView.views.count
        var inputOutputTextField = NodeInputOutputTextField(graphViewController: graphViewController, nodeViewController: self, input: input, index: index, value: value)

        stackView.addView(inputOutputTextField, inGravity: .Center)
    }

    func nodeTitleMouseDown(mouseLocation: NSPoint) {
        var startPoint = NSPoint(x: leadingConstraint.constant, y: topConstraint.constant)
        startPoint.x -= mouseLocation.x
        startPoint.y += mouseLocation.y
        draggingStartPoint = startPoint
    }

    func nodeTitleMouseDragged(mouseLocation: NSPoint) {
        if let startPoint = draggingStartPoint {
            leadingConstraint.constant = startPoint.x + mouseLocation.x
            topConstraint.constant = startPoint.y - mouseLocation.y
            node.positionX = Float(leadingConstraint.constant)
            node.positionY = Float(topConstraint.constant)
            graphViewController.updateEdgeViews()
        }
    }

    func nodeTitleMouseUp(mouseLocation: NSPoint) {
        draggingStartPoint = nil
    }

    func addAttributeInput(glIndex: GLuint, name: String, size: GLint, type: GLenum) {
        let attributeInputPort = node.addPortToInputs(nullNode, context: managedObjectContext, name: name, entityName: "AttributeInputPort") as! AttributeInputPort;
        attributeInputPort.glIndex = Int32(glIndex)
        attributeInputPort.glSize = Int32(size)
        attributeInputPort.glType = Int32(type)
        addInputOutputView(name, input: true)
    }

    func addUniformInput(glIndex: GLuint, name: String, size: GLint, type: GLenum) {
        let uniformInputPort = node.addPortToInputs(nullNode, context: managedObjectContext, name: name, entityName: "UniformInputPort") as! UniformInputPort;
        uniformInputPort.glIndex = Int32(glIndex)
        uniformInputPort.glSize = Int32(size)
        uniformInputPort.glType = Int32(type)
        addInputOutputView(name, input: true)
    }

    func addInput(name: String) {
        addInputOutputView(name, input: true)
        node.addPortToInputs(nullNode, context: managedObjectContext, name: name)
    }

    func deleteInput(index: Int) {
        var inputsSet = node.mutableOrderedSetValueForKey("inputs")
        for i in index ..< node.inputs.count {
            (inputsSet[i] as! InputPort).index--
        }

        var inputPort = inputsSet[index] as! InputPort
        // FIXME: Perhaps we should remove NullNode cycles
        inputPort.edge.source = nullNode.addNullNodeInputPort(managedObjectContext)

        managedObjectContext.deleteObject(inputPort)
        inputsSet.removeObjectAtIndex(index)
        inputsView.removeView(inputsView.views[index] as! NSView)
        graphViewController.redrawConnectionsView()
    }

    func addOutput(name: String) {
        addInputOutputView(name, input: false)
        node.addPortToOutputs(nullNode, context: managedObjectContext, name: name)
    }

    func deleteOutput(index: Int) {
        var outputsSet = node.mutableOrderedSetValueForKey("outputs")
        for i in index ..< node.outputs.count {
            (outputsSet[i] as! OutputPort).index--
        }

        var outputPort = outputsSet[index] as! OutputPort
        // FIXME: Perhaps we should remove NullNode cycles
        outputPort.edge.destination = nullNode.addNullNodeOutputPort(managedObjectContext)

        managedObjectContext.deleteObject(outputPort)
        outputsView.removeView(outputsView.views[index] as! NSView)
        graphViewController.redrawConnectionsView()
    }

    func renameOutput(index: Int, newName: String) {
        (node.outputs[index] as! OutputPort).title = newName
        (outputsView.views[index] as! NodeInputOutputTextField).stringValue = newName
    }

    func showDetails() {
        if let constantFloatNode = node as? ConstantFloatNode {
            detailsPopover.contentViewController = ConstantFloatDetailsViewController(nibName: "ConstantFloatDetailsViewController", bundle: nil, node: constantFloatNode)!
        } else if let vertexShaderNode = node as? VertexShaderNode {
            detailsPopover.contentViewController = VertexShaderDetailsViewController(nibName: "VertexShaderDetailsViewController", bundle: nil, nodeViewController: self, node: vertexShaderNode)!
        } else if let fragmentShaderNode = node as? FragmentShaderNode {
            detailsPopover.contentViewController = FragmentShaderDetailsViewController(nibName: "FragmentShaderDetailsViewController", bundle: nil, nodeViewController: self, node: fragmentShaderNode)!
        } else if let constantBufferNode = node as? ConstantBufferNode {
            detailsPopover.contentViewController = ConstantBufferDetailsViewController(nibName: "ConstantBufferDetailsViewController", bundle: nil, node: constantBufferNode)!
        } else {
            assert(false, "Unknown kind of node")
        }
        detailsPopover.showRelativeToRect(NSZeroRect, ofView: view, preferredEdge: NSMaxXEdge)
    }
}
