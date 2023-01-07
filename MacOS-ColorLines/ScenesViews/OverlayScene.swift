//
//  OverlayScene.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 06.01.2023.
//

import Foundation
import SceneKit
import SpriteKit

class OverlayScene: SKScene{
    private var labelNode: SKLabelNode = SKLabelNode(fontNamed: "Arial")
    private var overlayNode: SKNode = SKNode()
    
    override init(size: CGSize) {
        super.init(size: size)
        initScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initScene()
    }
    
    private func initScene(){
        scaleMode = .resizeFill
        
        addChild(overlayNode)
        overlayNode.position = CGPoint(x: 0.0, y: size.height)
        
        labelNode.text = "Счет: 0"
        labelNode.fontColor = .black
        labelNode.verticalAlignmentMode = .center
        labelNode.horizontalAlignmentMode = .center
        labelNode.fontSize = 29.0
        labelNode.zPosition = 1
        overlayNode.addChild(labelNode)
    }
    
    //private var oldSize: CGSize = .zero
    func layout2DOverlay(newSize: CGSize) {
        //oldSize = newSize
        DispatchQueue.main.async { [weak self] in
            //self?.overlayNode.position = CGPoint(x: 0.0, y: newSize.height)
            
            let width = self?.labelNode.frame.width ?? 0
            let labelNodeHeight = self?.labelNode.fontSize ?? 48
            self?.labelNode.position = CGPoint(x: 16 + 0.5 * width, y: newSize.height - labelNodeHeight - 16)
        }
    }
    
    func setScore(_ score: Int){
        labelNode.text = "Счет: \(score)"
        
        //layout2DOverlay(newSize: oldSize)
    }
}
