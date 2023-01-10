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
        let data = TopList.loadData()
        //data.save()
        
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
        
        let scoreMaterial = SCNMaterial()
        scoreMaterial.lightingModel = .physicallyBased
        scoreMaterial.isDoubleSided = false
        scoreMaterial.diffuse.contents = NSColor.yellow //black
        
        for i in 0..<data.scores.count{
            let score = data.scores[i]
            let scoreLabel: SCNGeometry? = SCNText(string: "\(i+1): \(score)", extrusionDepth: 0.7)
//            if let scoreLabel = scoreLabel as? SCNText{
//                scoreLabel.font = NSFont(name: "Helvatica", size: 0.5)
//            }
            let scoreLabelNode = SCNNode(geometry: scoreLabel)
            scoreLabelNode.geometry?.materials = [scoreMaterial]
            scoreLabelNode.eulerAngles = SCNVector3(x: CGFloat.pi * 1.5, y: -CGFloat.pi * 0.5, z: 0)
            scoreLabelNode.scale = SCNVector3Make( 0.01, 0.01, 0.01);
            scoreLabelNode.position = SCNVector3(1 - CGFloat(i) * 0.5, 0.1, 1 - 2)
            boxNode.addChildNode(scoreLabelNode)
            //scoreLabelNode.eulerAngles = SCNVector3(x: CGFloat.pi * 1.5, y: -CGFloat.pi * 0.5, z: 0)
        }
        
        return boxNode
    }
}
