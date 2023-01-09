//
//  CreateBall.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 09.01.2023.
//

import Foundation
import SceneKit

extension SceneView{
    func createBall(colorType: BallColorType,x: Int, y: Int){
        let ballGeometry: SCNGeometry? = SCNSphere(radius: 0.5)
        let ballNode = BallNode(geometry: ballGeometry)
        ballNode.name = "ball"
        ballNode.x = x
        ballNode.y = y
        ballNode.colorType = colorType
        
        let imageMaterial = SCNMaterial()
        imageMaterial.lightingModel = .physicallyBased
        imageMaterial.isDoubleSided = false
        imageMaterial.diffuse.contents = colorType.color
        imageMaterial.normal.contents = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_normal")
        imageMaterial.metalness.contents = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_metallic")
        imageMaterial.roughness.contents = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_roughness")
        imageMaterial.ambientOcclusion.contents = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_ao")
        
        //Прозрачный эффект
//            imageMaterial.isDoubleSided = true
//            imageMaterial.lightingModel = .constant
//            imageMaterial.blendMode = .add
//            imageMaterial.writesToDepthBuffer = false

        ballNode.geometry?.materials = [imageMaterial]
        
        ballNode.position = SCNVector3Make(CGFloat(x), 0, CGFloat(y))
        scene?.rootNode.addChildNode(ballNode)
        balls.append(ballNode)
    }
    
    func findBallNode(x: Int, y: Int) -> BallNode?{
        for node in balls{
            if node.x == x && node.y == y{
                return node
            }
        }
        return nil
    }
    
    func ballExist(x: Int, y: Int) -> Bool {
        if let _ = findBallNode(x: x, y: y){
            return true
        }
        return false
    }
}
