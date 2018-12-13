//
//  textComponent.swift
//  SKDefender
//
//  Created by localadmin on 30.11.18.
//  Copyright © 2018 ch.cqd.skdefender. All rights reserved.
//

import SpriteKit
import GameplayKit

class TextComponent: GKComponent {
    let node: SKLabelNode
    var highScore: Int = 0
    var currentScore: Int = 0
    
    init(entity: GKEntity, text2D: String) {
        node = SKLabelNode(text: text2D)
        node.entity = entity
        let defaults = UserDefaults.standard
        highScore = defaults.integer(forKey: "highScore")
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func returnNodePosition() -> CGPoint {
        return node.position
    }
    
    func showHighScore() {
        node.text = "HScore \(highScore)"
        let defaults = UserDefaults.standard
        defaults.set(highScore, forKey: "highScore")
    }
    
    func moreScore(score: Int) {
//        let oldScore = Int(node.text!)
//        let newScore = oldScore! + score
        currentScore += score
        node.text = "CScore \(currentScore)"
    }
    
    func lessScore(score: Int) {
//        let oldScore = Int(node.text!)
//        let newScore = oldScore! - score
        currentScore -= score
        node.text = "CScore \(currentScore)"
    }
    
    
    
}
