//
//  TLScene4.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/10/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class TLScene4: SKScene{
    
    var gameNode = SKSpriteNode()
    
    var player: CrossHair?
    var background: Background?
    
    var queenAlien: QueenAlien?
    var queenAlienIsVisible = false
    var quenAlienCounterTime: TimeInterval = 0.00
    var queenIntervalTime: TimeInterval = 10.00
    
    var hud: HUD?
    var bat: Bat?
    
    var timeLimit: TimeInterval = 30.00
    var timerIsStarted = false
    var lastUpdateTime: TimeInterval = 0.00
    var totalRunningTime: TimeInterval = 0.00
    
    var helpButton: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        configureBasicSceneElements(withPlayerTypeOf: .BlueLarge, andWithBackgroundOf: .ColoredForest, withBackgroundMusicFrom: BackgroundMusic.FlowingRocks)
        
        setupIntroMessageBox()
        
        
        
        bat = Bat()
        
        
        gameNode.addChild(bat!)
        //gameNode.addChild(queenAlien!)
        self.addChild(gameNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func didSimulatePhysics() {
        
        // guard let bat = bat else { return }
        
        // bat.update()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let player = player else { return }
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        
        //player.updateTargetPosition(position: touchLocation) //Better suited for production version
        
        player.position = touchLocation
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(timerIsStarted){
            totalRunningTime += currentTime - lastUpdateTime
            quenAlienCounterTime += currentTime - lastUpdateTime
            
            lastUpdateTime = currentTime
            
            
            if(quenAlienCounterTime > queenIntervalTime){
                
                if(queenAlienIsVisible){
                    queenAlien?.run(SKAction.fadeOut(withDuration: 1.0))
                    queenAlien?.changeNoiseFieldBitMaskCategoryTo(noiseFieldBitmaskCategory: 0)
                    
                } else {
                    queenAlien?.run(SKAction.fadeIn(withDuration: 1.0))
                    queenAlien?.changeNoiseFieldBitMaskCategoryTo(noiseFieldBitmaskCategory: 1)
                    
                }
                
                queenAlienIsVisible = !queenAlienIsVisible
                quenAlienCounterTime = 0
            }
            
            
            if(kDebug){
                print("Current running time: \(totalRunningTime)")
            }
        }
        
        guard let player = player, let bat = bat else { return }
        
        player.update()
        // bat.checkForReposition()
        
    }
    
    
    func configureBasicSceneElements(withPlayerTypeOf crossHairType: CrossHair.CrossHairType, andWithBackgroundOf backgroundType: Background.BackgroundType, withBackgroundMusicFrom fileName: String){
        
        //Configure GameNode Properties
        gameNode.scale(to: self.size)
        gameNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gameNode.position = CGPoint.zero
        gameNode.color = SKColor.black
        gameNode.alpha = 0.6
        
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
        background!.zPosition = -2
        background!.scale(to: self.size)
        gameNode.addChild(background!)
        
        
        
        
        //Configure HUD display
        hud = HUD()
        hud!.zPosition = -1
        self.addChild(hud!)
        
    }
    
    private func setupIntroMessageBox(){
        let currentLevelTimeLimit = self.timeLimit
        
        let introButton = ButtonFactory.createIntroMessageWith(levelTitle: "Level 2", levelDescription: "It's just got a little darker!", levelTimeLimit: currentLevelTimeLimit)
        
        if let introButton = introButton {
            self.addChild(introButton)
            
        }
        
        
    }
    
    
}
