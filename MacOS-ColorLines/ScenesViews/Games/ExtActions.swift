//
//  ExtActions.swift
//  ColorLines3D
//
//  Created by Алексей Химунин on 11.01.2023.
//

import Foundation
import SceneKit

extension SceneView{
    func extNewGame() {
        clearAllBalls(completionHandler: { [weak self] in
            if let score = self?.score {
                TopList.setNewScore(score: score)
            }
            self?.score = 0
            self?.updatePanel()
            self?.nextStep()
        })
    }

    func extNextStep() {
        nextStep()
    }
    
    func extShowTopList(){
        if let topListBoxNode = topListBoxNode{
            let animation = SCNAction.move(to: SCNVector3(x: 20, y: topListBoxNode.position.y, z: 4), duration: 0.8)
            topListBoxNode.runAction(animation, completionHandler: { [weak self] in
                self?.topListBoxNode?.removeFromParentNode()
                self?.topListBoxNode = nil
            })
            return
        }
        
        topListBoxNode = ctrateTopListBox()
        if let topListBoxNode = topListBoxNode{
            topListBoxNode.position = SCNVector3(20, 2, 4)
            let animation = SCNAction.move(to: SCNVector3(x: 4, y: topListBoxNode.position.y, z: 4), duration: 0.5)
            scene?.rootNode.addChildNode(topListBoxNode)
            topListBoxNode.runAction(animation)
        }
    }
}
