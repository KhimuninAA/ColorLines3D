//
//  IsFinish.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 09.01.2023.
//

import Foundation
import SceneKit

extension SceneView{
    func isFinish(){
        if balls.count >= poleLevelSize * poleLevelSize {
            clearAllBalls(completionHandler: { [weak self] in
                if let score = self?.score {
                    TopList.setNewScore(score: score)
                }
                self?.score = 0
                self?.updatePanel()
                self?.nextStep()
            })
        }
    }
    
    func clearAllBalls(completionHandler: (()->Void)?){
        var count = balls.count
        for ball in balls{
            let animation = SCNAction.move(to: SCNVector3(x: ball.position.x - 12, y: 0, z: ball.position.z), duration: 2.0)
            ball.runAction(animation, completionHandler: {
                ball.removeFromParentNode()
                count -= 1
                if count == 0 {
                    completionHandler?()
                }
            })
        }
        balls = [BallNode]()
    }
}
