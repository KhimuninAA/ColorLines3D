//
//  NextStep.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 09.01.2023.
//

import Foundation
import SceneKit

extension SceneView{
    func nextStep(){
        if findLine() {
            return
        }
        isFinish()
        
        var newBallCount: Int = 3
        let freePole = poleLevelSize * poleLevelSize - balls.count
        if freePole < 3 {
            newBallCount = freePole
        }
        
        for _ in 0..<newBallCount{
            let colorType = BallColorType.random()
            let pos = newPos()
            createBall(colorType: colorType, x: pos.x, y: pos.y)
            
        }
        if findLine() {
            return
        }
        isFinish()
    }
}
