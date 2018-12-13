//
//  GameViewController.swift
//  SKDefender
//
//  Created by localadmin on 06.11.18.
//  Copyright © 2018 ch.cqd.skdefender. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

var gameViewController: UIViewController!

class GameViewController: UIViewController {

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gameViewController = self
        
        if let skView = self.view as? SKView {
            if skView.scene == nil {
//                let aspectRatio = skView.bounds.size.height / skView.bounds.size.width
                let scene = GameScene(size: CGSize(width: self.view!.bounds.width * 2, height: self.view!.bounds.height * 2))
                
                
                skView.showsFPS = true
                skView.showsNodeCount = true
                skView.showsPhysics = false
                skView.ignoresSiblingOrder = true
                

                
                scene.scaleMode = .aspectFill
                
                skView.presentScene(scene)
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscape]
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public func displayAlert() {
        let alert = UIAlertController(title: "Test",
                                      message: "I am a modal alert",
                                      preferredStyle: .alert)
        let defaultButton = UIAlertAction(title: "OK",
                                          style: .default) {(_) in
                                            // your defaultButton action goes here
        }
        
        alert.addAction(defaultButton)
        present(alert, animated: true) {
            // completion goes here
        }
    }
}
