//
//  CreateLevel.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 09.01.2023.
//

import Foundation
import SceneKit

extension SceneView{
    func createLevel(){
        for i in 0..<poleLevelSize{
            for j in 0..<poleLevelSize{
                
                let imageMaterial = SCNMaterial()
                imageMaterial.lightingModel = .physicallyBased
                imageMaterial.isDoubleSided = false
                imageMaterial.diffuse.contents = NSImage(named: "FrenchMosaic_512_albedo") //pole1
                imageMaterial.normal.contents = NSImage(named: "FrenchMosaic_512_normal")
                
                let cube: SCNGeometry? = SCNBox(width: 1.0, height: 1.0, length: 1, chamferRadius: 0)
                let node = FloorNode(geometry: cube)
                node.x = i
                node.y = j
                node.geometry?.materials = [imageMaterial]
                
                node.position = SCNVector3Make(CGFloat(i), -1, CGFloat(j))
                scene?.rootNode.addChildNode(node)
            }
        }
    }
}
