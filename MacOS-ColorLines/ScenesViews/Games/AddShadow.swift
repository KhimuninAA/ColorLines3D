//
//  AddShadow.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 09.01.2023.
//

import Foundation
import SceneKit

extension SceneView{
    func addShadow(){
        //omni StaticLight
        lightNode = scene?.rootNode.childNode(withName: "omni", recursively: true)
        if let lightNode = lightNode{
            lightNode.light?.castsShadow = true
            lightNode.light?.automaticallyAdjustsShadowProjection = true
            lightNode.light?.maximumShadowDistance = 0 //100//20.0
            //lightNode?.light?.orthographicScale = 1

            //lightNode?.light?.shadowMapSize = CGSize(width: 2048, height: 2048)
            lightNode.light?.shadowMapSize = CGSize(width: 4000, height: 4000)
            lightNode.light?.orthographicScale=100; // bigger is softer
            lightNode.light?.shadowMode = .forward // forward deferred modulated
            lightNode.light?.shadowSampleCount = 128
            lightNode.light?.shadowRadius = 100
            lightNode.light?.shadowBias  = 0.1 //5//32
            
            lightNode.light?.shadowColor                   = NSColor(calibratedRed: 0, green: 0, blue: 0, alpha: 0.75) //UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
            //lightNode.light?.shadowMode                    = .deferred
            //lightNode.light?.shadowRadius                  = 2.0  // 3.25 // suggestion by StackOverflow
            lightNode.light?.shadowCascadeCount            = 3    // suggestion by lightNode
            lightNode.light?.shadowCascadeSplittingFactor  = 0.09 // suggestion by StackOverflow
        }
    }
}
