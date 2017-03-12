//
//  TLScene2.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/8/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


import Foundation
import SpriteKit

class TLScene2: SKScene{
    
   
    //MARK: Cached Sounds
    private let shootingSound = SKAction.playSoundFileNamed(SoundEffects.Laser6, waitForCompletion: false)
    
    //MARK: Variables for Game Objects
    private var gameNode = SKSpriteNode()
    private var player: CrossHair?
    private var background: Background?
    private var hud: HUD?

    private var bat1: Bat?
    private var bat2: Bat?
    private var bat3: Bat?
    private var bat4: Bat?
    private var bat5: Bat?
  
    //MARK: Timer-Related Variables
    
    private var timeLimit: TimeInterval = 30.00
    private var timerIsStarted = false
    private var lastUpdateTime: TimeInterval = 0.00
    private var totalRunningTime: TimeInterval = 0.00
    
    
    override func didMove(to view: SKView) {
        configureBasicSceneElements(withPlayerTypeOf: .BlueLarge, andWithBackgroundOf: .ColoredForest, withBackgroundMusicFrom: BackgroundMusic.FlowingRocks)
        
        setupIntroMessageBox()
        
        setupBats()
        
       
        
        
        self.addChild(gameNode)
    }
    
    //MARK: User Input Handlers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let player = player else { return }

        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        
       
        
     
            for node in nodes(at: touchLocation){
                if node.name == NodeNames.StartButton{
                    node.removeFromParent()
                }
            }
        
        
            if player.contains(touchLocation){
                player.run(shootingSound)
            }
            
            if let bat1 = bat2, player.contains(touchLocation), bat1.contains(touchLocation){
              
                bat1.respondToHitAt(touchLocation: touchLocation)
                bat1.run(SKAction.sequence([
                    SKAction.wait(forDuration: 0.25),
                    SKAction.removeFromParent()
                    ]))
                updateNumberOfKills()
            
                if(kDebug){
                    showNumberOfKills()
                }
            }
            
            if let bat2 = self.bat2, player.contains(touchLocation),bat2.contains(touchLocation){

                bat2.respondToHitAt(touchLocation: touchLocation)
                bat2.run(SKAction.sequence([
                    SKAction.wait(forDuration: 0.25),
                    SKAction.removeFromParent()
                    ]))
                updateNumberOfKills()
                
                
                
                if(kDebug){
                    showNumberOfKills()
                }
            }
            
            if let bat3 = self.bat3, player.contains(touchLocation),bat3.contains(touchLocation){
              
                bat3.respondToHitAt(touchLocation: touchLocation)
                bat3.run(SKAction.sequence([
                    SKAction.wait(forDuration: 0.25),
                    SKAction.removeFromParent()
                    ]))
                updateNumberOfKills()
                
                
                
                
                if(kDebug){
                    showNumberOfKills()
                }
            }
            
            if let bat4 = self.bat4, player.contains(touchLocation),bat4.contains(touchLocation){
          
                bat4.respondToHitAt(touchLocation: touchLocation)
                bat4.run(SKAction.sequence([
                    SKAction.wait(forDuration: 0.25),
                    SKAction.removeFromParent()
                    ]))
                updateNumberOfKills()
                
                
                
                if(kDebug){
                    showNumberOfKills()
                }
            }
            
            if let bat5 = self.bat5, player.contains(touchLocation),bat5.contains(touchLocation){
               
                bat5.respondToHitAt(touchLocation: touchLocation)
                bat5.run(SKAction.sequence([
                    SKAction.wait(forDuration: 0.25),
                    SKAction.removeFromParent()
                    ]))
                updateNumberOfKills()
                
                if(kDebug){
                    showNumberOfKills()
                }
            }
            
      
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    
        guard let player = player else { return }
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        
        
        
        
            for node in nodes(at: touchLocation){
                if node.name == NodeNames.StartButton{
                    node.removeFromParent()
                }
            }
      
            //player.updateTargetPosition(position: touchLocation) //Better suited for production version
            player.position = touchLocation
            
       
        
    
    
    }
    
    
    //MARK: - Game Loop Functions
    
    override func didSimulatePhysics() {
     
            if let bat1 = bat1, let bat2 = bat2, let bat3 = bat3, let bat4 = bat4, let bat5 = bat5{
            
                    bat1.updatePhysics()
                    bat2.updatePhysics()
                    bat3.updatePhysics()
                    bat4.updatePhysics()
                    bat5.updatePhysics()
            }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        

                totalRunningTime += currentTime - lastUpdateTime
                lastUpdateTime = currentTime
                
                if let player = player, let bat1 = bat1, let bat2 = bat2, let bat3 = bat3, let bat4 = bat4, let bat5 = bat5{
                    
                    player.update()
                    
                
                
                
            }
        
      
        
    }
    
    
    //MARK: - Initial Scene Configuration
    
    func configureBasicSceneElements(withPlayerTypeOf crossHairType: CrossHair.CrossHairType, andWithBackgroundOf backgroundType: Background.BackgroundType, withBackgroundMusicFrom fileName: String){
        
        //Set initial number of kills to zero
        gameNode.userData?.setValue(0, forKey: "numberOfKills")
        
        //Configure GameNode Properties
        gameNode.scale(to: self.size)
        gameNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gameNode.position = CGPoint.zero
        gameNode.color = SKColor.black
        gameNode.alpha = 0.15
        
        //Configure background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: fileName, forParentNode: self)
        
        //Set the anchor point of the scene to (0.5,0.5)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        //Configure player
        player = CrossHair(crossHairType: .BlueLarge)
        if let player = player{
            player.zPosition = 3
            player.physicsBody = SKPhysicsBody(circleOfRadius: 10.0)
            player.physicsBody?.affectedByGravity = false
            player.physicsBody?.fieldBitMask = 1
            self.addChild(player)
        }
        
        //Configure background
        background = Background(backgroundType: backgroundType)
        if let background = background{
            background.zPosition = -2
            background.scale(to: self.size)
            gameNode.addChild(background)
        }

 
        
        //Configure HUD display
        hud = HUD()
            if let hud = hud{
                hud.zPosition = -1
                self.addChild(hud)
        }
        
    }
    
    private func setupBats(){
        bat1 = Bat(scalingFactor: 1.1)
        bat2 = Bat(scalingFactor: 1.4)
        bat3 = Bat(scalingFactor: 1.2)
        bat4 = Bat(scalingFactor: 1.9)
        bat5 = Bat(scalingFactor: 2.6)
        
        if let bat1 = bat1, let bat2 = bat2, let bat3 = bat3, let bat4 = bat4, let bat5 = bat5{
            gameNode.addChild(bat1)
            gameNode.addChild(bat2)
            gameNode.addChild(bat3)
            gameNode.addChild(bat4)
            gameNode.addChild(bat5)
        }
    }
    
    private func setupIntroMessageBox(){
        let currentLevelTimeLimit = self.timeLimit
        
        let introButton = ButtonFactory.createIntroMessageWith(levelTitle: "Level 2", levelDescription: "It's just got a little darker!", levelTimeLimit: currentLevelTimeLimit)
        
        if let introButton = introButton {
            self.addChild(introButton)
            
        }
        
        
    }
    
    private func updateNumberOfKills(){
        var originalNumberOfKills = gameNode.userData?.value(forKey: "numberOfKills") as? Int
        
        if let originalNumberOfKills = originalNumberOfKills{
            gameNode.userData?.setValue(originalNumberOfKills+1, forKey: "numberOfKills")
            
        }
    }
    
    //MARK: Private debug functions
    
    private func showNumberOfKills(){
        let numberOfKills = gameNode.userData?.value(forKey: "numberOfKills") as? Int
        
        if let accumulatedKills = numberOfKills{
            print("Number of kills is: \(accumulatedKills)")
        }
    }
    
    private func showTotalRunningTime(){
        print("The total running time is: \(totalRunningTime)")
    }
}
