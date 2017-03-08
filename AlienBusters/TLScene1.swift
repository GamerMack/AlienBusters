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
    
    var timeLimit: Int = 30
    var timerIsStarted = false
    var lastUpdateTime: TimeInterval = 0.00
    var totalRunningTime: TimeInterval = 0.00
    
    var helpButton: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        configureBasicSceneElements(withPlayerTypeOf: .BlueLarge, andWithBackgroundOf: .ColoredForest, withBackgroundMusicFrom: BackgroundMusic.FlowingRocks)
        
        configureHelpButton()
        
        
        let introBoxTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .UI)?.textureNamed("yellow_panel")
        let introBox = SKSpriteNode(texture: introBoxTexture, color: .clear, size: CGSize(width: kViewWidth*0.4, height: kViewHeight*0.4))
        introBox.position = CGPoint.zero
        introBox.zPosition = 10
        
        let introxBoxHeight = introBoxTexture!.size().height
        
        let introText1 = SKLabelNode(fontNamed: FontTypes.NoteWorthyBold)
        introBox.addChild(introText1)
        introText1.position = CGPoint(x: 0, y: introxBoxHeight*0.4 )
        introText1.text = "Level 1"
        introText1.fontSize = 30.0
        introText1.zPosition = 12
        
        let introText2 = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
        introBox.addChild(introText2)
        introText2.position = CGPoint(x: 0, y: 0 )
        introText2.text = "Find and Shoot All the Alien Bats"
        introText2.fontSize = 20.0
        introText2.zPosition = 12
        
        let introText3 = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
        introBox.addChild(introText3)
        introText3.position = CGPoint(x: 0, y: -introxBoxHeight*0.4 )
        introText3.fontSize = 20.0
        introText3.text = "Time Limit: \(timeLimit) seconds"
        introText3.zPosition = 12
        self.addChild(introBox)
        
        
        let introTextPulseAction = SKAction.sequence([
            SKAction.fadeIn(withDuration: 0.2),
            SKAction.fadeOut(withDuration: 0.2)
            ])
        
        let pulsingAction = SKAction.repeatForever(introTextPulseAction)
        
        introText1.run(pulsingAction)
        
        introBox.run(SKAction.sequence([
            SKAction.wait(forDuration: 6.0),
            SKAction.removeFromParent(),
            SKAction.run({
                [weak self] in
                self?.timerIsStarted = true
            })
            ]))
        
        
        
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
        if(timerIsStarted){
            totalRunningTime += currentTime - lastUpdateTime
            lastUpdateTime = currentTime
            
            if(kDebug){
                print("Current running time: \(totalRunningTime)")
            }
        }
        
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
    
    private func configureHelpButton(){
       
        let helpButtonTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .UI)?.textureNamed("yellow_button01")
        
        let helpButtonHeight = kViewHeight*0.05
        let helpButtonWidth = kViewWidth*0.06
        let helpButtonSize = CGSize(width: helpButtonWidth, height: helpButtonHeight)
        helpButton = SKSpriteNode(texture: helpButtonTexture!, color: SKColor.blue, size: helpButtonSize)
        
        
        guard let helpButton = helpButton else { return }
        
        helpButton.name = "Help"
        helpButton.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        helpButton.zPosition = 12
        helpButton.position = CGPoint(x: kViewWidth/2-helpButtonWidth-10, y: kViewHeight/2-helpButtonHeight-5)
        
        let helpButtonText = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
        helpButtonText.fontSize = 10.0
        helpButtonText.fontColor = SKColor.blue
        helpButtonText.text = "Help"
        helpButtonText.name = "Help"
        helpButtonText.verticalAlignmentMode = .center
        helpButtonText.horizontalAlignmentMode = .center
        helpButtonText.position = CGPoint(x: -15.0, y: -10.0)
        helpButtonText.zPosition = 13
        
        helpButton.addChild(helpButtonText)
        self.addChild(helpButton)
        
    }
    
}
