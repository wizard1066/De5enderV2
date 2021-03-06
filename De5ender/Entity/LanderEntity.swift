//
//  LanderEntity.swift
//  SKDefender
//
//  Created by localadmin on 27.11.18.
//  Copyright © 2018 ch.cqd.skdefender. All rights reserved.
//

import SpriteKit
import GameKit

class LanderEntity: GKEntity {
    var spriteComponent: SpriteComponent!
    var landerComponent: LanderComponent!
    
    init(imageName: String, xCord: CGFloat, yCord: CGFloat, screenBounds: CGRect, shadowNode: EntityNode?) {
        //    init(imageName: String) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        
        landerComponent = LanderComponent(entity: self, screenBounds: screenBounds)
        addComponent(landerComponent)
        
        let spriteNode = spriteComponent.node
        spriteNode.size = CGSize(width: spriteNode.size.width/2, height: spriteNode.size.height/2)
        spriteNode.position = CGPoint(x: xCord, y: yCord)
        if shadowNode != nil {
//            spriteNode.physicsBody = SKPhysicsBody.init(texture: texture, size: spriteNode.size)
            spriteNode.physicsBody = SKPhysicsBody.init(circleOfRadius: spriteNode.size.width/5 )
            spriteNode.physicsBody?.categoryBitMask = PhysicsCat.Alien
            spriteNode.physicsBody?.collisionBitMask = PhysicsCat.None
            spriteNode.physicsBody?.contactTestBitMask = PhysicsCat.SpaceMan | PhysicsCat.Fire | PhysicsCat.Player
            spriteNode.physicsBody?.affectedByGravity = false
            spriteNode.physicsBody?.angularDamping = 0
            spriteNode.physicsBody?.restitution = 0.5
        }
        spriteNode.name = "alien"
        
        if shadowNode != nil {
            spriteNode.userData = NSMutableDictionary()
            spriteNode.userData?.setObject(shadowNode, forKey: "shadow" as NSCopying)
            spriteNode.userData?.setObject(self, forKey: "class" as NSCopying)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
