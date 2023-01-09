//
//  FindLine.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 09.01.2023.
//

import Foundation
import SceneKit

extension SceneView{
    func findLine() -> Bool{
        var lineBalls: [BallNode] = [BallNode]()
        var lastColorType: BallColorType?
        var isLineFinding: Bool = false
        
        func isLine(){
            if lineBalls.count >= 5{
                score += lineBalls.count * 2
                updatePanel()
                isLineFinding = true
                //Animation
                let animation = SCNAction.scale(to: 0, duration: 0.3)
                for ball in lineBalls{
                    ball.runAction(animation, completionHandler: { [weak self] in
                        if let self = self{
                            if let index = self.balls.firstIndex(where: {$0.x == ball.x && $0.y == ball.y}){
                                self.balls[index].removeFromParentNode()
                                self.balls.remove(at: index)
                            }
                        }
                    })
                }
                lineBalls = [BallNode]()
            }
        }
        
        //horizont
        for y in 0..<poleLevelSize{
            lastColorType = nil
            lineBalls = [BallNode]()
            for x in 0..<poleLevelSize{
                let findBall = findBallNode(x: x, y: y)
                let findColorType = findBall?.colorType ?? .none
                
                if findColorType != lastColorType{
                    isLine()
                    lineBalls = [BallNode]()
                    lastColorType = findColorType
                }
                
                if let findBall = findBall{
                    lineBalls.append(findBall)
                }
            }
            isLine()
        }
        
        //verticale
        for x in 0..<poleLevelSize{
            lastColorType = nil
            lineBalls = [BallNode]()
            for y in 0..<poleLevelSize{
                let findBall = findBallNode(x: x, y: y)
                let findColorType = findBall?.colorType ?? .none
                
                if findColorType != lastColorType{
                    isLine()
                    lineBalls = [BallNode]()
                    lastColorType = findColorType
                }
                
                if let findBall = findBall{
                    lineBalls.append(findBall)
                }
            }
            isLine()
        }
        
        // ---/---
        for i in -8..<9{
            lastColorType = nil
            lineBalls = [BallNode]()
            for j in 0..<9{
                let x = i + j
                let y = j
                if x >= 0 && x < 9{
                    let findBall = findBallNode(x: x, y: y)
                    let findColorType = findBall?.colorType ?? .none
                    
                    if findColorType != lastColorType{
                        isLine()
                        lineBalls = [BallNode]()
                        lastColorType = findColorType
                    }
                    
                    if let findBall = findBall{
                        lineBalls.append(findBall)
                    }
                }
            }
            isLine()
        }
        
        // ---\---
        for i in 0..<17{
            lastColorType = nil
            lineBalls = [BallNode]()
            for j in 0..<9{
                let x = i - j
                let y = j
                if x >= 0 && x < 9{
                    let findBall = findBallNode(x: x, y: y)
                    let findColorType = findBall?.colorType ?? .none
                    
                    if findColorType != lastColorType{
                        isLine()
                        lineBalls = [BallNode]()
                        lastColorType = findColorType
                    }
                    
                    if let findBall = findBall{
                        lineBalls.append(findBall)
                    }
                }
            }
            isLine()
        }
        
        return isLineFinding
    }
}
