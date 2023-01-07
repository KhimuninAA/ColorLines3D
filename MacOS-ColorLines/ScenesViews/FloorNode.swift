//
//  FloorNode.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 06.01.2023.
//

import Foundation
import SceneKit

class FloorNode: SCNNode{
    var x: Int = 0
    var y: Int = 0
    
    init(geometry: SCNGeometry?) {
        super.init()
        self.geometry = geometry
    }
    /* Xcode required this */
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
