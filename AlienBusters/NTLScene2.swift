//
//  NTLScene2.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class NTLScene2: SKScene, SKPhysicsContactDelegate{
    
    private var player: CrossHair?
    private var background: Background?
    private var hud: HUD?
    private var flyingAlien: FlyingAlien?
    
    private let fallingAliensController = FallingAliensController()
    private var lastUpdateTime = 0.0
    
    
    override func didMove(to view: SKView) {
     
        //Configure Background Music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: BackgroundMusic.FarmFrolics, forParentNode: self)
        
        //Add the Flying Aliens Controller
        self.addChild(self.fallingAliensController)
        
        //Set the anchor point of the scene to (0.5,0.5)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //Set current scene as the contact delegate
        self.physicsWorld.contactDelegate = self
        
        //Configure player
        player = CrossHair(crossHairType: .BlueLarge)
        player!.zPosition = 3
        self.addChild(player!)
        
        //Configure background
        background = Background(backgroundType: .ColoredForest)
        background!.zPosition = -2
        background!.scale(to: self.size)
        self.addChild(background!)
        
        let barrierNode = SKSpriteNode(texture: nil, color: .clear, size: self.size)
        barrierNode.zPosition = 2
        barrierNode.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -200, y: -200, width: 400, height: 400))
        
        barrierNode.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        barrierNode.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        
        self.addChild(barrierNode)
        
        //Configure HUD display
        hud = HUD()
        hud!.zPosition = -1
        self.addChild(hud!)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //When alien falls to ground, it spawns a running alien that attempts to run away
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func didSimulatePhysics() {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        let delta = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        player?.update()
        fallingAliensController.update(delta: delta)
    }

   
    
}
