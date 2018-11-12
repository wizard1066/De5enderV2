//
//  AlienDecentComponent.swift
//  SKDefender
//
//  Created by localadmin on 12.11.18.
//  Copyright © 2018 ch.cqd.skdefender. All rights reserved.
//

import SpriteKit
import GameplayKit

class AlienDecentComponent: GKComponent {
    let spriteComponent: SpriteComponent
    
    var decentRate: CGFloat = -1
    
    init(entity: GKEntity) {
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeDirection(_ lastUpdateTime: TimeInterval) {
        decentRate = 1
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        spriteComponent.node.position.y = spriteComponent.node.position.y + decentRate
    }
    
}