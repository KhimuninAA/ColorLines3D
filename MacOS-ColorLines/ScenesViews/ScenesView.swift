//
//  ScenesView.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 05.01.2023.
//

import Foundation
import SceneKit

class SceneView: SCNView{
    private var jampTick: CGFloat = 0
    private var lightTick: CGFloat = 0
    
    private var selectBall: BallNode?
    private var lightNode: SCNNode?
    
    private var balls: [BallNode] = [BallNode]()
    private var overlayScene: OverlayScene?
    private var score: Int = 0
    
    override init(frame: NSRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private let poleLevelSize: Int = 9
    private func createLevel(){
        for i in 0..<poleLevelSize{
            for j in 0..<poleLevelSize{
                
                let imageMaterial = SCNMaterial()
                imageMaterial.lightingModel = .physicallyBased
                imageMaterial.isDoubleSided = false
                imageMaterial.diffuse.contents = NSImage(named: "FrenchMosaic_512_albedo") //pole1
                imageMaterial.normal.contents = NSImage(named: "FrenchMosaic_512_normal")
                
                let cube: SCNGeometry? = SCNBox(width: 1.0, height: 1.0, length: 1, chamferRadius: 0)
                let node = FloorNode(geometry: cube)
                node.x = i
                node.y = j
                node.geometry?.materials = [imageMaterial]
                
                node.position = SCNVector3Make(CGFloat(i), -1, CGFloat(j))
                scene?.rootNode.addChildNode(node)
            }
        }
    }
    
    private func createBall(colorType: BallColorType,x: Int, y: Int){
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
    
    private func findBallNode(x: Int, y: Int) -> BallNode?{
        for node in balls{
            if node.x == x && node.y == y{
                return node
            }
        }
        return nil
    }
    
    private func ballExist(x: Int, y: Int) -> Bool {
        if let _ = findBallNode(x: x, y: y){
            return true
        }
        return false
    }
    
    private func newPos() -> (x: Int, y: Int) {
        var x = Int.random(in: 0..<poleLevelSize)
        var y = Int.random(in: 0..<poleLevelSize)
        
        while ballExist(x: x, y: y){
            x = Int.random(in: 0..<poleLevelSize)
            y = Int.random(in: 0..<poleLevelSize)
        }
        
        return (x,y)
    }
    
    private func nextStep(){
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
    
    private func isFinish(){
        if balls.count >= poleLevelSize * poleLevelSize {
            for ball in balls{
                let animation = SCNAction.move(to: SCNVector3(x: ball.position.x - 12, y: 0, z: ball.position.z), duration: 2.0)
                ball.runAction(animation, completionHandler: {
                    ball.removeFromParentNode()
                })
            }
            balls = [BallNode]()
        }
    }
    
    private func findLine() -> Bool{
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
    
    private func initView(){
        self.delegate = self
        self.loops = true
        self.isPlaying = true
        
        scene = SCNScene(named: "SKScene.scnassets/ColorLines.scn")
        
        addShadow()
        
        createLevel()
        
        overlayScene = OverlayScene(size: bounds.size)
        if let overlayScene = overlayScene{
            overlayScene.scaleMode = .resizeFill
            self.overlaySKScene = overlayScene
        }
        
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
                                let path = AlgoritmA.getPath(start: Point(x: selectBall.y, y: selectBall.x), end: Point(x: floorNode.y, y: floorNode.x), blocks: self.balls.points)
                                
                                DispatchQueue.main.async { [weak self] in
                                    if let self = self{
                                        if let path = path{
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
    
    private func addShadow(){
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
    
    func resizeView(){
        let selfSize = bounds.size
        //overlayScene?.mapSize = selfSize.height / 3
        overlayScene?.layout2DOverlay(newSize: selfSize)
    }
    
    func updatePanel(){
        overlayScene?.setScore(score)
    }
}
