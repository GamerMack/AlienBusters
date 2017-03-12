//
//  TLScene6.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


class TestScene2: TimeLimitScene{
    
    static let buttonPositionOffset: CGFloat = 20.0
    
    //MARK: Keep track of number times game is paused (for testing/debug purposes)
    var numberOfPauses: Int = 0
    
    let gameWaitingAction: SKAction = {
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.25)
        let scaleDown = SKAction.scale(to: 0.8, duration: 0.25)
        let scaleSequence = SKAction.sequence([
            scaleUp, scaleDown
            ])
        let scalingAnimation = SKAction.repeatForever(scaleSequence)
        return scalingAnimation
    }()
    
    
    let fadeAnimation: SKAction = {
        
        //Create and configure pulsing action for buttons
        let fadeIn = SKAction.fadeAlpha(to: 0.7, duration: 0.25)
        let fadeOut = SKAction.fadeAlpha(to: 1.0, duration: 0.25)
        let fadeSequence = SKAction.sequence([ fadeIn,fadeOut ])
        let fadeAnimation = SKAction.repeatForever(fadeSequence)
        
        return fadeAnimation
        
    }()
    
    let startButton: SKShapeNode = {
        let nodeRect = CGRect(x: -ScreenSizeFloatConstants.HalfScreenWidth + TestScene2.buttonPositionOffset, y: TestScene2.buttonPositionOffset, width: ScreenSizeFloatConstants.HalfScreenWidth*0.8, height: ScreenSizeFloatConstants.HalfScreenHeight*0.7)
        let shapeNode = SKShapeNode(rect: nodeRect, cornerRadius: 2.00)
        shapeNode.fillColor = SKColor.green
        shapeNode.name = NodeNames.StartButton
        
        
        return shapeNode
    
    }()
    
    
    let pauseButton: SKShapeNode = {
       let nodeRect = CGRect(x: -ScreenSizeFloatConstants.HalfScreenWidth + TestScene2.buttonPositionOffset, y: -ScreenSizeFloatConstants.HalfScreenHeight + TestScene2.buttonPositionOffset, width: ScreenSizeFloatConstants.HalfScreenWidth*0.8, height: ScreenSizeFloatConstants.HalfScreenHeight*0.7)
        
        let shapeNode = SKShapeNode(rect: nodeRect, cornerRadius: 2.00)
        shapeNode.fillColor = SKColor.cyan
        shapeNode.name = NodeNames.PauseButton
        
        return shapeNode
    }()
    
    
    let resumeButton: SKShapeNode = {
        let nodeRect = CGRect(x: TestScene2.buttonPositionOffset, y: -ScreenSizeFloatConstants.HalfScreenHeight + TestScene2.buttonPositionOffset, width: ScreenSizeFloatConstants.HalfScreenWidth*0.8, height: ScreenSizeFloatConstants.HalfScreenHeight*0.7)
        
        let shapeNode = SKShapeNode(rect: nodeRect, cornerRadius: 2.00)
        shapeNode.fillColor = SKColor.yellow
        shapeNode.strokeColor = SKColor.blue
        shapeNode.name = NodeNames.ResumeButton
        
        return shapeNode
    }()
    
    
    let gameOverButton: SKShapeNode = {
        let nodeRect = CGRect(x: TestScene2.buttonPositionOffset, y: TestScene2.buttonPositionOffset, width: ScreenSizeFloatConstants.HalfScreenWidth*0.8, height: ScreenSizeFloatConstants.HalfScreenHeight*0.7)
        
        let shapeNode = SKShapeNode(rect: nodeRect, cornerRadius: 2.00)
        shapeNode.fillColor = SKColor.magenta
        shapeNode.strokeColor = SKColor.blue
        shapeNode.name = NodeNames.GameOverButton
        
        return shapeNode
    }()
    

    
    override func didMove(to view: SKView) {
        //Add background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: BackgroundMusic.FarmFrolics, forParentNode: self)
        
        //Set anchor point of the scene to center
        self.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        
        //Enter waiting state
        state = .Waiting
        runGameWaitingAnimations()
        
        //Create labels and add buttons
        let startButtonLabel = createLabelWith(textOf: "Start Game", andNodeNameOf: NodeNames.StartButton)
        startButtonLabel.position = CGPoint(x: -200, y: 100)
        startButton.addChild(startButtonLabel)
        
        self.addChild(startButton)
        
        
        let pauseButtonLabel = createLabelWith(textOf: "Pause", andNodeNameOf: NodeNames.PauseButton)
        pauseButtonLabel.position = CGPoint(x: -200, y: -100)
        pauseButton.addChild(pauseButtonLabel)
        self.addChild(pauseButton)
        
        
        let resumeButtonLabel = createLabelWith(textOf: "Resume", andNodeNameOf: NodeNames.ResumeButton)
        resumeButtonLabel.position = CGPoint(x: 150, y: -100)
       resumeButton.addChild(resumeButtonLabel)
        self.addChild(resumeButton)
        
        
        let gameOverButtonLabel = createLabelWith(textOf: "End Game", andNodeNameOf: NodeNames.GameOverButton)
        gameOverButtonLabel.position = CGPoint(x: 150, y: 100)
        gameOverButton.addChild(gameOverButtonLabel)
        self.addChild(gameOverButton)
    }
    
    
    //MARK: Game Loop Functions
    
    override func update(_ currentTime: TimeInterval) {
        
        if(state != .Running){
            if(state == .GameOver){
                print("The total number of times you paused the game was: \(numberOfPauses)")
            }
            return
        } else {
            
        }
    }
    
    
    
    override func didSimulatePhysics() {
        if(state != .Running){
            return
        } else {
        }
    }
    
    //MARK: Handlers for User Input
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        
        switch(state){
            case .Running:
                if(pauseButton.contains(touchLocation)){
                    enterPausedState()
                }
                
                if(gameOverButton.contains(touchLocation)){
                    enterGameOverState()
                }
                break
            case .Paused:
                if(resumeButton.contains(touchLocation)){
                    enterResumedState()
                }
                
                break
            case .GameOver:
                break
            case .Waiting:
                if(startButton.contains(touchLocation)){
                    enterRunningState()
                }
                break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch(state){
            case .Running:
                break
            case .Paused:
                break
            case .GameOver:
                break
            case .Waiting:
                break
        }
    }
    
    private func createLabelWith(textOf text: String,  andNodeNameOf nodeName: String, fontTypeOf fontType: String = FontTypes.NoteWorthyBold ,fontColorOf fontColor: SKColor = SKColor.black, fontSizeOf fontSize: CGFloat = 40.0) -> SKLabelNode{
        
        let label = SKLabelNode(fontNamed: fontType)
        
        //Configure font settings
        label.fontSize = fontSize
        label.fontColor = fontColor
        label.text = text
        
        //Configure Horizontal and Vertical Alignment Modes
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
      
        
        //Set node name
        label.name = NodeNames.ResumeButton
        
        return label
    }
    
   

}


extension TestScene2{
    
    //MARK: Game state toggles
    override func enterGameOverState() {
        removeButtonFadeAnimations()
        super.enterGameOverState()
    }
    
    override func enterRunningState() {
        if(state == .Waiting){
            removeGameWaitingAnimations()
        }
        
        runButtonFadeAnimations()
        super.enterRunningState()
    }
    
    override func enterPausedState() {
        removeButtonFadeAnimations()
        numberOfPauses += 1
        super.enterPausedState()
    }
    
    override func enterResumedState() {
        runButtonFadeAnimations()
        super.enterResumedState()
    }
    
    //MARK: Private helper functions for game state toggles
    private func runButtonFadeAnimations(){
        pauseButton.run(fadeAnimation, withKey: "fadeAnimation")
        startButton.run(fadeAnimation, withKey: "fadeAnimation")
        gameOverButton.run(fadeAnimation, withKey: "fadeAnimation")
        resumeButton.run(fadeAnimation, withKey: "fadeAnimation")
    }
    
    private func removeButtonFadeAnimations(){
        pauseButton.removeAction(forKey: "fadeAnimation")
        startButton.removeAction(forKey: "fadeAnimation")
        gameOverButton.removeAction(forKey: "fadeAnimation")
        resumeButton.removeAction(forKey: "fadeAnimation")
    }
    
     func runGameWaitingAnimations(){
        pauseButton.run(gameWaitingAction, withKey: "gameWaitingAction")
        startButton.run(gameWaitingAction, withKey: "gameWaitingAction")
        gameOverButton.run(gameWaitingAction, withKey: "gameWaitingAction")
        resumeButton.run(gameWaitingAction, withKey: "gameWaitingAction")

    }
    
    
     func removeGameWaitingAnimations(){
        pauseButton.removeAction(forKey: "gameWaitingAction")
        startButton.removeAction(forKey: "gameWaitingAction")
        gameOverButton.removeAction(forKey: "gameWaitingAction")
        resumeButton.removeAction(forKey: "gameWaitingAction")

    }

    
}
