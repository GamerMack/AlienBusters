//
//  GameOver.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class GameOverScene: SKScene{
    
    override func didMove(to view: SKView) {
        
        let bg = SKAudioNode(fileNamed: kGameOver)
        bg.autoplayLooped = true
        self.addChild(bg)
        
        let gameOverLabel = SKLabelNode(fontNamed: kFuturaMediumItalic)
        gameOverLabel.text = "Game Over"
        gameOverLabel.verticalAlignmentMode = .center
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.fontSize = 60
        gameOverLabel.position = CGPoint.zero
        self.addChild(gameOverLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func didSimulatePhysics() {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
