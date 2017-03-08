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
    
    private let textureAtlasManager = TextureAtlasManager.sharedInstance
    
    private let timeLimit: TimeInterval = 10.0
    private var timeElapsed: TimeInterval = 0.00
    private var previousTime: TimeInterval = 0.00
    
    private var numberOfBullets = 5{
        didSet{
            if(numberOfBullets == 0){
                self.run(SKAction.wait(forDuration: 3.0))
                loadGameOverScene()
            }
        }
    }
    
    private var numberOfKills = 0
    
    private let shootingSound = SKAction.playSoundFileNamed(SoundEffects.Laser9, waitForCompletion: false)
    
    private var player: CrossHair?
    private var background: Background?
    private var hud: HUD?
    private var flyingAlien: FlyingAlien?
    private var spaceShip: SpaceShip?
    
    override func didMove(to view: SKView) {
        
        setup()
        
        /** TestCode for Flying Alien
        flyingAlien = FlyingAlien(alienColor: .pink)
        flyingAlien!.zPosition = 1
        **/
        
        spaceShip = SpaceShip(spaceShipType: .Blue1)
        self.addChild(spaceShip!)
        
        let barrierNode = SKSpriteNode(texture: nil, color: .clear, size: self.size)
        barrierNode.zPosition = 1
        barrierNode.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -200, y: -200, width: 400, height: 400))
        self.addChild(barrierNode)
        
       // self.addChild(flyingAlien!)
        
      
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
        background!.zPosition = -2
        background!.scale(to: self.size)
        self.addChild(background!)
        
        //Configure HUD display
        hud = HUD()
        hud!.zPosition = -1
        self.addChild(hud!)
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
      
    }
    
    func touchMoved(toPoint pos : CGPoint) {
      player?.updateTargetPosition(position: pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //If the player runs out of bullets, he cannot fire anymore
        if(numberOfBullets == 0) {
            print("No more bullets")
            return
        }
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        
        
        if let player = player, player.contains(touchLocation){
            player.run(self.shootingSound)
            numberOfBullets -= 1
            
            if let flyingAlien = flyingAlien, flyingAlien.contains(touchLocation){
                flyingAlien.respondToHitAt(touchLocation: touchLocation)
            }
            
            if let spaceShip = spaceShip, spaceShip.contains(touchLocation){
                //Not yet implemented
                //spaceShip.respondToHitAt(touchLocation: touchLocation)
            }
        
        }
        
       
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let touchLocation = t.location(in: self)
            
            if let player = player{
                //player.updateTargetPosition(position: touchLocation)
                player.position = touchLocation
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        let deltaTime = currentTime - previousTime
        timeElapsed += deltaTime
        
        if let player = player{
            player.update()
        }
        
       
        if let spaceShip = spaceShip{
            spaceShip.update(currentTime: timeElapsed)
        }
        
        
        previousTime = currentTime
    }
    
    override func didSimulatePhysics() {
        if let flyingAlien = flyingAlien{
           //flyingAlien.update(currentTime: timeElapsed)
        }
    }
    

    
    private func loadGameOverScene(){
        let scene = GameOverScene()
        let transition = SKTransition.crossFade(withDuration: 0.20)
        view?.presentScene(scene, transition: transition)
        
    }
}
