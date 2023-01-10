//
//  TopListBox.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 10.01.2023.
//

import Foundation
import SceneKit

extension SceneView{
    func ctrateTopListBox() -> SCNNode{
        let imageMaterial = SCNMaterial()
        imageMaterial.lightingModel = .physicallyBased
        imageMaterial.isDoubleSided = false
        imageMaterial.diffuse.contents = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_albedo")
        imageMaterial.normal.contents = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_normal")
        imageMaterial.metalness.contents = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_metallic")
        imageMaterial.roughness.contents = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_roughness")
        imageMaterial.ambientOcclusion.contents = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_ao")
        
        let box: SCNGeometry? = SCNBox(width: 5.0, height: 0.2, length: 3, chamferRadius: 0)
        let boxNode = SCNNode(geometry: box)
        boxNode.geometry?.materials = [imageMaterial]
        boxNode.name = "topListBox"
        return boxNode
    }
}
