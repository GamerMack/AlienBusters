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
    
    private enum State{
        case Waiting,Running,Paused,GameOver
    }
    
    private var state: State = .Waiting
    private var previousState: State = .Waiting
    
    private let startButton = StartButton()
    private let gameNode = SKNode()
    
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
        
        //Register notifications for "Pause"
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "Pause"), object: nil, queue: nil, using: statePaused)
        //Register notifications for "Resume"
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "Resume"), object: nil, queue: nil, using: resumeGame)
        
        setup()
        
        /** TestCode for Flying Alien
        flyingAlien = FlyingAlien(alienColor: .pink)
        flyingAlien!.zPosition = 1
        **/
        
        
        spaceShip = SpaceShip(spaceShipType: .Blue1)
        gameNode.addChild(spaceShip!)
        
        let barrierNode = SKSpriteNode(texture: nil, color: .clear, size: self.size)
        barrierNode.size = CGSize(width: 400, height: 400)
        barrierNode.color = SKColor.black
        barrierNode.alpha = 0.4
        barrierNode.zPosition = 1
        barrierNode.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -200, y: -200, width: 400, height: 400))
        gameNode.addChild(barrierNode)
        
        if let player = player{
            let lightNode = SKLightNode()
            lightNode.lightColor = SKColor.yellow
            lightNode.ambientColor = SKColor.orange
            lightNode.isEnabled = true
            lightNode.shadowColor = SKColor.gray
            lightNode.zPosition = 5
            player.addChild(lightNode)
        }
        
       // self.addChild(flyingAlien!)
        
      self.addChild(gameNode)
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
        gameNode.addChild(player!)
        
        //Configure background
        background = Background(backgroundType: .ColoredCastle)
        background!.zPosition = -2
        background!.scale(to: self.size)
        gameNode.addChild(background!)
        
        //Configure HUD display
        hud = HUD()
        hud!.zPosition = -1
        self.addChild(hud!)
        
        /**
        Create an emitter node
        let emitterNode = SmokeEmitterManager.sharedInstance.createSmokeEmitterFor(engineState: .Accelerated)
        emitterNode.zPosition = 2
        self.addChild(emitterNode)
        **/
        
        //Add the Start Button
        gameNode.addChild(startButton)
        
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
        /** This is deprecated as a result of adding a state machine
        if(numberOfBullets == 0) {
            print("No more bullets")
            return
        }**/
        
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        
        
        switch(self.state){
        case .Running:
            if let player = player, player.contains(touchLocation){
                player.run(self.shootingSound)
                numberOfBullets -= 1
                
                if let flyingAlien = flyingAlien, flyingAlien.contains(touchLocation){
                    flyingAlien.respondToHitAt(touchLocation: touchLocation)
                }
                
                if let spaceShip = spaceShip, spaceShip.contains(touchLocation){
                    spaceShip.respondToHitAt(touchLocation: touchLocation)
                }
                
                if let hud = hud, let pauseButton = hud.pauseButton, pauseButton.contains(touchLocation){
                    pauseButtonPressed()
                }
                
              
                
            }
            break
        case .Waiting:
            if(startButton.contains(touchLocation)){
                stateRunning()
            }
            break
        case .Paused:
            return
        case .GameOver:
            return
            
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
        
        if(state != .Running){ return } else {
            if(numberOfBullets > 0){
                if let player = player{
                    player.update()
                }
                
                
                if let spaceShip = spaceShip{
                    spaceShip.update(currentTime: timeElapsed)
                }
        
            } else {
                stateGameOver()
            }
        
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
    
    //MARK: - State
    func stateRunning(){
        state = .Running
    }
    
    func statePaused(notification: Notification?){
        previousState = state
        state = .Paused
        gameNode.speed = 0.0
        
        if kDebug{
            print("Pausing game ...")
        }
        
    }
    
    func stateResume(){
        state = previousState
        gameNode.speed = 1.0
        
        if kDebug{
            print("Resuming game...")
        }
        
    }
    
    func stateGameOver(){
        state = .GameOver
    }
    
    //MARK: - Pause and Resume Game
    func resumeGame(notification: Notification){
        //Run a timer that resumes the game after 1 second
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(stateResume), userInfo: nil, repeats: false)
    }
    
    private func pauseButtonPressed(){
        if let hud = hud, let pauseButton = hud.pauseButton{
            pauseButton.tapped()
            
            if(pauseButton.getPauseState()){
                statePaused(notification: nil)
                
                gameNode.isPaused = true
            } else {
                
                stateResume()
                gameNode.isPaused = false
            }
            
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
