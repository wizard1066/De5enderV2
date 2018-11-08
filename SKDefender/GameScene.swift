//
//  GameScene.swift
//  SKDefender
//
//  Created by localadmin on 06.11.18.
//  Copyright © 2018 ch.cqd.skdefender. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCat {
    static let None: UInt32 = 0
    static let Player: UInt32 = 0b1
    static let Ground: UInt32 = 0b1 << 1
}

class GameScene: SKScene, SKPhysicsContactDelegate, touchMe {
    
    func spriteTouched(box: TouchableSprite) {
        switch box.name {
            case "up":
                player.movementComponent.applyImpulseUp(lastUpdateTimeInterval)
            case "down":
                player.movementComponent.applyImpulseDown(lastUpdateTimeInterval)
            case "left":
                player.movementComponent.applyImpulseLeft(lastUpdateTimeInterval)
            case "right":
                player.movementComponent.applyImpulseRight(lastUpdateTimeInterval)
            default:
                player.movementComponent.applyZero(lastUpdateTimeInterval)
        }
    }
    
    
    enum Layer: CGFloat {
        case background
        case foreground
        case player
    }
    
    let player = PlayerEntity(imageName: "starship")
    var playableStart: CGFloat = 0
    
    var deltaTime: TimeInterval = 0
    var lastUpdateTimeInterval: TimeInterval = 0
    
    let numberOfForegrounds = 2
    let groundSpeed = 150
    
    lazy var screenWidth = view!.bounds.width
    lazy var screenHeight = view!.bounds.height
    
    func buildGround() -> SKSpriteNode {
        let loopsNeeded = Int(screenWidth / 80)
        var path: CGMutablePath?
        for loop in stride(from: 0, to: Int(screenWidth*2), by: loopsNeeded) {
            let randomSource = GKARC4RandomSource()
            let randomDistribution = GKRandomDistribution(randomSource: randomSource, lowestValue: 80, highestValue: 128)
            let randomValueY = randomDistribution.nextInt()
            if path == nil {
                path = CGMutablePath()
                path!.move(to: CGPoint(x: 0, y: randomValueY))
            } else {
                path!.addLine(to: CGPoint(x: loop, y: randomValueY))
            }
        }
        
        let shape = SKShapeNode()
        shape.path = path
        shape.strokeColor = UIColor.white
        shape.lineWidth = 2
        shape.zPosition = 1
        
        let texture = view?.texture(from: shape)
        let sprite = SKSpriteNode(texture: texture)

        sprite.physicsBody = SKPhysicsBody(edgeChainFrom: shape.path!)
        sprite.physicsBody?.categoryBitMask = PhysicsCat.Ground
        sprite.physicsBody?.collisionBitMask = 0
        sprite.physicsBody?.contactTestBitMask = PhysicsCat.Player
        
        
//        addChild(sprite)
        return sprite
    }
    
    func setupForeground() {
        for i in 0..<numberOfForegrounds {
            let foreground = buildGround()
            foreground.anchorPoint = CGPoint(x: 0.0, y: -1.33)
            foreground.position = CGPoint(x: CGFloat(i) * foreground.size.width, y: playableStart)
            foreground.zPosition = Layer.foreground.rawValue
            foreground.name = "foreground"
            addChild(foreground)
        }
    }
    
    func updateForeground() {
        self.enumerateChildNodes(withName: "foreground") { (node, stop) in
            if let foreground = node as? SKSpriteNode {
                let moveAmount = CGPoint(x: -CGFloat(self.groundSpeed) * CGFloat(self.deltaTime), y: self.playableStart)
                foreground.position.x += moveAmount.x

                
                if foreground.position.x < -foreground.size.width {
                    foreground.position.x += foreground.size.width * CGFloat(self.numberOfForegrounds)
                }
            }
        }
    }
    
    func setupPlayer() {
        let playerNode = player.spriteComponent.node
        playerNode.position = CGPoint(x: self.view!.bounds.maxX / 2, y: self.view!.bounds.maxY / 2)
        playerNode.zPosition = Layer.player.rawValue
//        playerNode.size = CGSize(width: playerNode.size.width/4, height: playerNode.size.height/4)
        addChild(playerNode)
        playerNode.addChild(cameraNode)
        
//        player.movementComponent.playableStart = playableStart
    }
    
    func setupHUD() {
        let upArrow = TouchableSprite(imageNamed: "UpArrow")
        upArrow.position = CGPoint(x: (self.view?.bounds.minX)! + 128, y: ((self.view?.bounds.maxY)!) + 64)
//        upArrow.position = CGPoint(x: self.view!.bounds.minX, y: self.view!.bounds.minY)
        upArrow.size = CGSize(width: 64, height: 64)
        upArrow.name = "up"
        upArrow.delegate = self
        let downArrow = TouchableSprite(imageNamed: "DownArrow")
        downArrow.position = CGPoint(x: (self.view?.bounds.minX)! + 128, y: ((self.view?.bounds.maxY)!) - 64)
        downArrow.size = CGSize(width: 64, height: 64)
        downArrow.name = "down"
        downArrow.delegate = self
        let stopSquare = TouchableSprite(imageNamed: "Square")
        stopSquare.position = CGPoint(x: (self.view?.bounds.minX)! + 128, y: ((self.view?.bounds.maxY)!))
        //        upArrow.position = CGPoint(x: self.view!.bounds.minX, y: self.view!.bounds.minY)
        stopSquare.size = CGSize(width: 64, height: 64)
        stopSquare.name = "square"
        stopSquare.delegate = self
        
        let leftArrow = TouchableSprite(imageNamed: "LeftArrow")
        leftArrow.position = CGPoint(x: ((self.view?.bounds.maxX)! * 2) - 128, y: ((self.view?.bounds.maxY)!) + 64)
        //        upArrow.position = CGPoint(x: self.view!.bounds.minX, y: self.view!.bounds.minY)
        leftArrow.size = CGSize(width: 64, height: 64)
        leftArrow.name = "left"
        leftArrow.delegate = self
        let rightArrow = TouchableSprite(imageNamed: "RightArrow")
        rightArrow.position = CGPoint(x: ((self.view?.bounds.maxX)! * 2) - 128, y: ((self.view?.bounds.maxY)!) - 64)
        rightArrow.size = CGSize(width: 64, height: 64)
        rightArrow.name = "right"
        rightArrow.delegate = self
        
        let pauseSquare = TouchableSprite(imageNamed: "Square")
        pauseSquare.position = CGPoint(x: ((self.view?.bounds.maxX)! * 2) - 128, y: ((self.view?.bounds.maxY)!))
        //        upArrow.position = CGPoint(x: self.view!.bounds.minX, y: self.view!.bounds.minY)
        pauseSquare.size = CGSize(width: 64, height: 64)
        pauseSquare.name = "square"
        pauseSquare.delegate = self
        
        addChild(upArrow)
        addChild(downArrow)
        addChild(stopSquare)
        addChild(leftArrow)
        addChild(rightArrow)
        addChild(pauseSquare)
    }
    
    var cameraNode: SKCameraNode!
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: +512, y: +256)
        scene?.camera = cameraNode
        
//        buildGround()
        setupForeground()
        setupPlayer()
        setupHUD()
        
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }
        
        deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        updateForeground()
        player.update(deltaTime: deltaTime)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let pointTouched = touches.first?.location(in: self.view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let pointTouched = touches.first?.location(in: self.view)
        
        if pointTouched!.x < (self.view?.bounds.minX)! + 128, pointTouched!.y < ((self.view?.bounds.midY)!){
            player.movementComponent.applyImpulseUp(lastUpdateTimeInterval)
            return
        }
        if pointTouched!.x < (self.view?.bounds.minX)! + 128, pointTouched!.y > ((self.view?.bounds.midY)!){
            player.movementComponent.applyImpulseDown(lastUpdateTimeInterval)
            return
        }
        if pointTouched!.x > (self.view?.bounds.maxX)! - 128, pointTouched!.x < (self.view?.bounds.maxX)! - 64 {
            player.movementComponent.applyImpulseLeft(lastUpdateTimeInterval)
        }
        if pointTouched!.x > (self.view?.bounds.maxX)! - 64, pointTouched!.x > ((self.view?.bounds.maxX)!){
            player.movementComponent.applyImpulseRight(lastUpdateTimeInterval)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("ended")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask == PhysicsCat.Player ? contact.bodyB : contact.bodyA
        print("\(contact.bodyA.node!.name) \(contact.bodyB.node!.name)")
    }
}

public extension CGFloat {
    public func degreesToRadians() -> CGFloat {
        return CGFloat.pi * self / 180.0
    }

    public func radiansToDegrees() -> CGFloat {
        return self * 180.0 / CGFloat.pi
    }
}
