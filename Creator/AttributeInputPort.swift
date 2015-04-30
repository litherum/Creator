//
//  AttributeInputPort.swift
//  Creator
//
//  Created by Litherum on 4/26/15.
//  Copyright (c) 2015 Litherum. All rights reserved.
//

import CoreData
import GLKit

class AttributeInputPort: InputPort {
    @NSManaged var glIndex: Int32
    @NSManaged var glSize: Int32
    @NSManaged var glType: Int32
    @NSManaged var attributeSize: Int16
    @NSManaged var attributeType: Int32
    @NSManaged var attributeNormalized: Bool
    @NSManaged var attributeStride: Int32
    @NSManaged var attributeOffset: Int32

    override func awakeFromInsert() {
        attributeSize = 4
        attributeType = GL_FLOAT
        attributeNormalized = false
        attributeStride = 0
        attributeOffset = 0
    }
}
