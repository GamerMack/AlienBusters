//
//  GameScene.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class TestScene: SKScene {
    
    let textureAtlasManager = TextureAtlasManager.sharedInstance
    
    private var player: CrossHair?
    private var background: Background?
    
    override func didMove(to view: SKView) {
        
        setup()
        
        let backgroundTexture = SKTexture(image: #imageLiteral(resourceName: "colored_forest"))
        let backgroundSprite = SKSpriteNode(texture: backgroundTexture)
        backgroundSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundSprite.position = CGPoint.zero
        backgroundSprite.zPosition = 0
        self.addChild(backgroundSprite)
        
      
    }
    
    
    private func setup(){
        //Set the anchorpoint of the scene at the center of the scene
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //Configure background audio
        let bg = SKAudioNode(fileNamed: kMishiefStroll)
        bg.autoplayLooped = true
        self.addChild(bg)
        
        //Configure player
        player = CrossHair(crossHairType: .BlueLarge)
        player!.zPosition = 3
        self.addChild(player!)
        
        //Configure background
        background = Background(backgroundType: .ColoredCastle)
        background!.zPosition = 0
        self.addChild(background!)
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
      
    }
    
    func touchMoved(toPoint pos : CGPoint) {
      player?.updateTargetPosition(position: pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        
        if let player = player{
            player.updateTargetPosition(position: touchLocation)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if let player = player{
            player.update()
        }
    }
    
    private func loadScene(){
        let scene = GameOverScene()
        let transition = SKTransition.crossFade(withDuration: 0.20)
        view?.presentScene(scene, transition: transition)
        
    }
}
