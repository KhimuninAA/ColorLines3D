//
//  NewPos.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 09.01.2023.
//

import Foundation
import SceneKit

extension SceneView{
    func newPos() -> (x: Int, y: Int) {
        var x = Int.random(in: 0..<poleLevelSize)
        var y = Int.random(in: 0..<poleLevelSize)
        
        while ballExist(x: x, y: y){
            x = Int.random(in: 0..<poleLevelSize)
            y = Int.random(in: 0..<poleLevelSize)
        }
        
        return (x,y)
    }
}
