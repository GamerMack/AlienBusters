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
    
    
    var pauseButton: PauseButton?
    var gameNode = SKSpriteNode()
    var player: CrossHair?
    var background: Background?
    var hud: HUD?
    var bat: Bat?
    
    //Required variables for conformance to TimeLimitMode class
    
    var timeLimit: TimeInterval = 5.0
    var timerIsStarted = false
    var lastUpdateTime: TimeInterval = 0.00
    var totalRunningTime: TimeInterval = 0.00
    
    
    var helpButton: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        
      
        configureBasicSceneElements(withPlayerTypeOf: .BlueLarge, andWithBackgroundOf: .ColoredForest, withBackgroundMusicFrom: BackgroundMusic.FlowingRocks)
        
        setupIntroMessageBox()
        configureHelpButton()
        setupPauseButton()
        
        bat = Bat()
        
        gameNode.addChild(bat!)
        self.addChild(gameNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        
        if let pauseButton = pauseButton, nodes(at: touchLocation)[0].name == NodeNames.PauseButton{
            pauseButton.tapped()
        }
        
       
    }
    
    
    override func didSimulatePhysics() {
        
        guard let bat = bat else { return }
        
      // bat.update()
    }
    
    private func setupPauseButton(){
        pauseButton = PauseButton(buttonType: .Pause)
        
        if let pauseButton = pauseButton{
            self.addChild(pauseButton)
        }
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
        self.addChild(hud!)
        
        
    }
    
    private func setupIntroMessageBox(){
        if let introMessage = createIntroMessageWith(levelTitle: "Level 1", levelDescription: "Find all the bats and shoot them", levelTimeLimit: self.timeLimit){
            
            
            self.addChild(introMessage)
            
            introMessage.run(SKAction.sequence([
                SKAction.wait(forDuration: 4.0),
                SKAction.removeFromParent(),
                SKAction.run({
                    [weak self] in
                    self?.timerIsStarted = true
                })
                ]))
            
        }
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
    
    func gameOver(){
        if let hud = hud{
            hud.showRestartButtons()
        }
    }
    
}
