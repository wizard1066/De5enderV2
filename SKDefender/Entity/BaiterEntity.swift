//
//  BaiterEntity.swift
//  SKDefender
//
//  Created by localadmin on 26.11.18.
//  Copyright © 2018 ch.cqd.skdefender. All rights reserved.
//

import SpriteKit
import GameKit

class BaiterEntity: GKEntity {
    var spriteComponent: SpriteComponent!
    var baiterComponent: BaiterComponent!
    //    var bomb: SKSpriteNode!
    
    init(imageName: String, xCord: CGFloat, yCord: CGFloat, screenBounds: CGRect, view2D: EntityNode, scanNodes: [EntityNode], foregrounds: [EntityNode], shadowNode: EntityNode?, playerToKill: PlayerEntity?) {
        //    init(imageName: String) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        
        baiterComponent = BaiterComponent(entity: self, screenBounds: screenBounds, view2D: view2D, scanNodes: scanNodes, foregrounds: foregrounds, shadow: shadowNode)
        addComponent(baiterComponent)
        
        //        bomb = SKSpriteNode(imageNamed: "mine")
        //        bomb.size = CGSize(width: 64, height: 64)
        
        
        let spriteNode = spriteComponent.node
        spriteNode.size = CGSize(width: spriteNode.size.width/2, height: spriteNode.size.height/2)
        spriteNode.physicsBody = SKPhysicsBody.init(texture: texture, size: spriteNode.size)
        spriteNode.position = CGPoint(x: xCord, y: yCord)
        //        spriteNode.physicsBody = SKPhysicsBody.init(circleOfRadius: spriteNode.size.width/2)
        spriteNode.physicsBody?.categoryBitMask = PhysicsCat.Alien
        spriteNode.physicsBody?.collisionBitMask = PhysicsCat.None
        spriteNode.physicsBody?.contactTestBitMask = PhysicsCat.Fire
        spriteNode.physicsBody?.affectedByGravity = false
        spriteNode.name = "baiter"
        
        if shadowNode != nil {
            spriteNode.userData = NSMutableDictionary()
            spriteNode.userData?.setObject(shadowNode, forKey: "shadow" as NSCopying)
        }
        
        if playerToKill != nil {
            spriteNode.userData?.setObject(playerToKill, forKey: "player" as NSCopying)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}