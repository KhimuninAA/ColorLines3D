//
//  ScenesView.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 05.01.2023.
//

import Foundation
import SceneKit

class SceneView: SCNView{
    var jampTick: CGFloat = 0
    var lightTick: CGFloat = 0
    
    var selectBall: BallNode?
    var lightNode: SCNNode?
    var camNode: SCNNode?
    var scoreValueNode: SCNNode?
    var topListBoxNode: SCNNode?
    var nextBallColorNodes: [SCNNode] = [SCNNode]()
    var nextBallColor: [BallColorType] = [BallColorType]()
    
    var balls: [BallNode] = [BallNode]()
    var overlayScene: OverlayScene?
    var score: Int = 0
    
    let poleLevelSize: Int = 9
    
    override init(frame: NSRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    func moveCamera(){
        camNode = scene?.rootNode.childNode(withName: "camera", recursively: true)
        camNode?.position = SCNVector3Make(4.3, 12, 4)
        camNode?.eulerAngles = SCNVector3(x: 0, y: -CGFloat.pi * 0.5, z: 0)
                                          
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] (_) in
            let animation = SCNAction.rotateTo(x: -CGFloat.pi * 0.5, y: -CGFloat.pi * 0.5, z: 0, duration: 2)
            self?.camNode?.runAction(animation)
        })
    }
    
    func initScoreValue(){
        scoreValueNode = scene?.rootNode.childNode(withName: "scoreValue", recursively: true)
        setScoreValue(0)
    }
    
    func setScoreValue(_ val: Int){
        if let textNode = scoreValueNode?.geometry as? SCNText{
            textNode.string = "\(val)"
        }
    }
    
    private func initView(){
        self.delegate = self
        self.loops = true
        self.isPlaying = true
        
        scene = SCNScene(named: "SKScene.scnassets/ColorLines.scn")
        
        moveCamera()
        findNextBallColors()
        initScoreValue()
        
        addShadow()
        
        createLevel()
        
//        overlayScene = OverlayScene(size: bounds.size)
//        if let overlayScene = overlayScene{
//            overlayScene.scaleMode = .resizeFill
//            self.overlaySKScene = overlayScene
//        }
        newBallColors()
        nextStep()
    }
}

extension SceneView: SCNSceneRendererDelegate{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let lightNode = lightNode{
            lightTick += 0.001
            let x = 4.5 + 11 * sin(lightTick)
            let y = 4.5 + 11 * cos(lightTick)
            
            lightNode.position = SCNVector3Make(x, lightNode.position.y, y)
        }
        
        if let selectBall = selectBall{
            jampTick += 0.1
            if let index = balls.firstIndex(where: {$0.x == selectBall.x && $0.y == selectBall.y}){
                balls[index].position = SCNVector3Make(CGFloat(balls[index].x), abs( 0.4 * sin(jampTick)), CGFloat(balls[index].y))
                
                balls[index].tick += 1 * 0.01
                balls[index].eulerAngles = SCNVector3Make(0, 0, balls[index].tick);
            }
        }
    }
}

extension SceneView{
    override func mouseDown(with event: NSEvent) {
        let result = hitTestResultForEvent(event)
        
        if let ballNode = result?.node, ballNode.name == "topListBox"{
            let animation = SCNAction.move(to: SCNVector3(x: 20, y: ballNode.position.y, z: 4), duration: 0.8)
            topListBoxNode?.runAction(animation, completionHandler: { [weak self] in
                self?.topListBoxNode?.removeFromParentNode()
                self?.topListBoxNode = nil
            })
        }
        
        if topListBoxNode != nil{
            return
        }
        
        if let ballNode = result?.node, ballNode.name == "score"{
            topListBoxNode = ctrateTopListBox()
            if let topListBoxNode = topListBoxNode{
                topListBoxNode.position = SCNVector3(20, 2, 4)
                let animation = SCNAction.move(to: SCNVector3(x: 4, y: topListBoxNode.position.y, z: 4), duration: 0.5)
                scene?.rootNode.addChildNode(topListBoxNode)
                topListBoxNode.runAction(animation)
            }
        }
        
        if let ballNode = result?.node, ballNode.name == "newGameBtn" || ballNode.name == "NewGameLabel"{
            let ballPos = ballNode.position
            let animation = SCNAction.move(to: SCNVector3(x: ballPos.x, y: ballPos.y - 0.3, z: ballPos.z), duration: 0.2)
            ballNode.runAction(animation, completionHandler: {
                let animation = SCNAction.move(to: ballPos, duration: 0.2)
                ballNode.runAction(animation)
            })
            clearAllBalls(completionHandler: { [weak self] in
                if let score = self?.score {
                    TopList.setNewScore(score: score)
                }
                self?.score = 0
                self?.updatePanel()
                self?.nextStep()
            })
        }
        
        if let ballNode = result?.node, ballNode.name == "ball"{
            if let selectBall = selectBall{
                if let index = balls.firstIndex(where: {$0.x == selectBall.x && $0.y == selectBall.y}){
                    balls[index].position = SCNVector3Make(CGFloat(balls[index].x), 0, CGFloat(balls[index].y))
                }
            }
            selectBall = ballNode as? BallNode
        }else{
            let floorNode = result?.node as? FloorNode
            
            if let selectBall = selectBall{
                var isNextStep: Bool = false
                if let floorNode = floorNode{
                    if selectBall.x != floorNode.x || selectBall.y != floorNode.y{
                        isNextStep = true
                    }
                    if let index = balls.firstIndex(where: {$0.x == selectBall.x && $0.y == selectBall.y}){
                        
                        DispatchQueue.global().async { [weak self] in
                            if let self = self{
                                let path = AlgoritmA.getPath(start: Point(x: selectBall.y, y: selectBall.x), end: Point(x: floorNode.y, y: floorNode.x), blocks: self.balls.points, isRnd: false)

                                var minPath = path
                                if let _ = path{
                                    if let pth = AlgoritmA.getPath(start: Point(x: selectBall.y, y: selectBall.x), end: Point(x: floorNode.y, y: floorNode.x), blocks: self.balls.points){
                                        minPath = pth
                                    }
                                }

                                DispatchQueue.main.async { [weak self] in
                                    if let self = self{
                                        if let path = minPath{
                                            self.jampTick = 0
                                            self.selectBall = nil
                                            self.balls[index].x = floorNode.x
                                            self.balls[index].y = floorNode.y
                                            self.animationIndexBall(index: index, path: path, onConplite: { [weak self] in
                                                if isNextStep {
                                                    self?.nextStep()
                                                }
                                            })
                                        }else{
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    func animationIndexBall(index: Int, path: [Point]?, onConplite: @escaping ()->Void) {
        if let path = path{
            if let point = path.first{
                var newPath = path
                newPath.remove(at: 0)
                
                let animation = SCNAction.move(to: SCNVector3(x: CGFloat(point.y), y: 0, z: CGFloat(point.x)), duration: 0.1)
                balls[index].runAction(animation, completionHandler: { [weak self] in
                    self?.animationIndexBall(index: index, path: newPath, onConplite: onConplite)
                })
            }else{
                onConplite()
            }
        }else{
            onConplite()
        }
    }
    
    func hitTestResultForEvent(_ event: NSEvent) -> SCNHitTestResult?{
        let viewPoint = viewPointForEvent(event)
        let cgPoint = CGPoint(x: viewPoint.x, y: viewPoint.y)
        let points = self.hitTest(cgPoint, options: [:])
        return points.first
    }
    
    func viewPointForEvent(_ event: NSEvent) -> NSPoint{
        let windowPoint = event.locationInWindow
        let viewPoint = self.convert(windowPoint, from: nil)
        return viewPoint
    }
    
    func resizeView(){
        let selfSize = bounds.size
        //overlayScene?.mapSize = selfSize.height / 3
        overlayScene?.layout2DOverlay(newSize: selfSize)
    }
    
    func updatePanel(){
        overlayScene?.setScore(score)
        setScoreValue(score)
    }
}
