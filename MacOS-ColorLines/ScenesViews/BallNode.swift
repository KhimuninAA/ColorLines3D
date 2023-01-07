//
//  BallNode.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 06.01.2023.
//

import Foundation
import SceneKit

class BallNode: SCNNode{
    var tick: CGFloat = 0
    
    var x: Int = 0
    var y: Int = 0
    var colorType: BallColorType = .blue
    
    init(geometry: SCNGeometry?) {
        super.init()
        self.geometry = geometry
    }
    /* Xcode required this */
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Array where Element == BallNode {
    var points: [Point]{
        var points = [Point]()
        for item in self{
            points.append(Point(x: item.y, y: item.x))
        }
        return points
    }
}
