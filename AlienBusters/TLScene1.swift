//
//  TLScene1.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/8/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class TLScene1: SKScene{
    
    var gameNode = SKSpriteNode()
    
    var player: CrossHair?
    var background: Background?
    var hud: HUD?
    var bat: Bat?
    
    override func didMove(to view: SKView) {
        configureBasicSceneElements(withPlayerTypeOf: .BlueLarge, andWithBackgroundOf: .ColoredForest, withBackgroundMusicFrom: BackgroundMusic.FlowingRocks)
        
        
        bat = Bat()
        
        gameNode.addChild(bat!)
        
        self.addChild(gameNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func didSimulatePhysics() {
        
        guard let bat = bat else { return }
        
       bat.update()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let player = player else { return }
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        
        //player.updateTargetPosition(position: touchLocation) //Better suited for production version
        
        player.position = touchLocation
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        guard let player = player, let bat = bat else { return }
        
        player.update()
       bat.checkForReposition()
    }
    
    
    func configureBasicSceneElements(withPlayerTypeOf crossHairType: CrossHair.CrossHairType, andWithBackgroundOf backgroundType: Background.BackgroundType, withBackgroundMusicFrom fileName: String){
        
        //Configure GameNode Properties
        gameNode.scale(to: self.size)
        gameNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gameNode.position = CGPoint.zero
        gameNode.color = SKColor.black
        gameNode.alpha = 0.4
        
        //Configure background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: fileName, forParentNode: self)
        
        //Set the anchor point of the scene to (0.5,0.5)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        //Configure player
        player = CrossHair(crossHairType: .BlueLarge)
        player!.zPosition = 3
        self.addChild(player!)
        
        //Configure background
        background = Background(backgroundType: backgroundType)
        background!.zPosition = -2
        background!.scale(to: self.size)
        gameNode.addChild(background!)
        
        /**
        let barrierNode = SKSpriteNode(texture: nil, color: .clear, size: self.size)
        barrierNode.zPosition = 2
        barrierNode.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -200, y: -200, width: 400, height: 400))
        
        barrierNode.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        barrierNode.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        
        self.addChild(barrierNode)
         **/
        
        //Configure HUD display
        hud = HUD()
        hud!.zPosition = -1
        self.addChild(hud!)
        
    }
    
}
