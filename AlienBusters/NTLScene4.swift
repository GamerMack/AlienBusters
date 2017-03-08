//
//  NTLScene4.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/8/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class NTLScene4: SKScene{
    
    var player: CrossHair?
    var background: Background?
    var hud: HUD?
    
    override func didMove(to view: SKView) {
        configureBasicSceneElements(withPlayerTypeOf: .BlueLarge, andWithBackgroundOf: .ColoredForest, withBackgroundMusicFrom: BackgroundMusic.FlowingRocks)
     
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        guard let player = player else { return }
        
        player.updateTargetPosition(position: pos)
    }
    
    override func didSimulatePhysics() {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        guard let player = player else { return }
        
        player.update()
    }
    
    func configureBasicSceneElements(withPlayerTypeOf crossHairType: CrossHair.CrossHairType, andWithBackgroundOf backgroundType: Background.BackgroundType, withBackgroundMusicFrom fileName: String){
        
        //Configure background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: fileName, forParentNode: self)
        
        //Set the anchor point of the scene to (0.5,0.5)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        //Configure player
        player = CrossHair(crossHairType: crossHairType)
        player!.zPosition = 3
        self.addChild(player!)
        
        //Configure background
        background = Background(backgroundType: backgroundType)
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

}
