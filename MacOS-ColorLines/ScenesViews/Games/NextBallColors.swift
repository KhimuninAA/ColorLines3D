//
//  NextBallColors.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 11.01.2023.
//

import Foundation
import SceneKit

extension SceneView{
    func findNextBallColors(){
        nextBallColorNodes = [SCNNode]()
        if let infoNode = scene?.rootNode.childNode(withName: "info", recursively: true){
            for i in 0..<3{
                let boxMaterial = SCNMaterial()
                boxMaterial.lightingModel = .physicallyBased
                boxMaterial.isDoubleSided = false
                boxMaterial.diffuse.contents = NSColor(named: "NextBallColorBoxColor")
                
                let boxGeo: SCNGeometry? = SCNBox(width: 0.833, height: 1, length: 0.2, chamferRadius: 0)
                let boxNode = SCNNode(geometry: boxGeo)
                boxNode.geometry?.materials = [boxMaterial]
                boxNode.position = SCNVector3(0, 0.852, -0.3 + CGFloat(i) * 0.3)
                infoNode.addChildNode(boxNode)
                
                let ballMaterial = SCNMaterial()
                ballMaterial.lightingModel = .physicallyBased
                ballMaterial.isDoubleSided = false
                ballMaterial.diffuse.contents = NSColor.white
                
//                let ballMaterial = SCNMaterial()
//                ballMaterial.lightingModel = .physicallyBased
//                ballMaterial.isDoubleSided = false
//                ballMaterial.diffuse.contents = NSColor.white
//                ballMaterial.normal.contents = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_normal")
//                ballMaterial.metalness.contents = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_metallic")
//                ballMaterial.roughness.contents = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_roughness")
//                ballMaterial.ambientOcclusion.contents = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_ao")
                
                let ballGeo: SCNGeometry? = SCNSphere(radius: 0.2)
                let ballNode = SCNNode(geometry: ballGeo)
                ballNode.geometry?.materials = [ballMaterial]
                ballNode.position = SCNVector3(0, 1, 0)
                ballNode.scale = SCNVector3(1, 1, 0.3)
                boxNode.addChildNode(ballNode)
                
                nextBallColorNodes.append(ballNode)
            }
        }
    }
    
    func setNextBallColors(){
        for colorIndex in 0..<nextBallColor.count{
            let colorType = nextBallColor[colorIndex]
            if colorIndex >= 0 && colorIndex < nextBallColorNodes.count{
                nextBallColorNodes[colorIndex].geometry?.materials.first?.diffuse.contents = colorType.color
            }
        }
    }
    
    func newBallColors(){
        nextBallColor = [BallColorType]()
        for _ in 0..<3{
            let colorType = BallColorType.random()
            nextBallColor.append(colorType)
        }
    }
}
