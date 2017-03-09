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
    
    //MARK: Private state enum
    private enum State{
        case Waiting, Running, Paused, GameOver
    }
    
    private var state: State = .Waiting

    
    //GameState Toggle Buttons
    var introButton: SKSpriteNode?
    var pauseButton: PauseButton?
    var helpButton: SKSpriteNode?

    //Game characters and other game elements
    var gameNode = SKSpriteNode()
    var player: CrossHair?
    var background: Background?
    var hud: HUD?
    var bat: Bat?
    
    //Timer-related variables
    var timeLimit: TimeInterval = 15.0
    var timerIsStarted = false
    var lastUpdateTime: TimeInterval = 0.00
    var totalRunningTime: TimeInterval = 0.00{
        didSet{
            if(totalRunningTime > timeLimit){
                gameOver()
            }
        }
    }
    
    
    
    override func didMove(to view: SKView) {
        
        //Configure crosshair type, background type, and background music
        configureBasicSceneElements(withPlayerTypeOf: .BlueLarge, andWithBackgroundOf: .ColoredForest, withBackgroundMusicFrom: BackgroundMusic.FlowingRocks)
        
        //Setup the intro message for the current level
        setupIntroMessageBox()
        
        //Setup the pause/resume button
        setupPauseButton()
        
        //Setup enemies
        setupEnemies()
        
        //Add the gameNode, which provides the dark overlay for hiding the bat
        self.addChild(gameNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        
       
        
        switch(state){
            case .Running:
                for node in nodes(at: touchLocation){
                    if(node.name == NodeNames.PauseButton){
                      
                        statePaused()
                    }
                }
                break
            case .Paused:
                for node in nodes(at: touchLocation){
                    if(node.name == NodeNames.ResumeButton){
                        
                        stateResume()
                    }
                }
                break
            case .Waiting:
                for node in nodes(at: touchLocation){
                    if(node.name == NodeNames.StartButton){
                        node.removeFromParent()
                        stateRunning()
                    }
                }
                break
            case .GameOver:
                for node in nodes(at: touchLocation){
                    if(node.name == NodeNames.RestartGameButton){
                        self.view?.presentScene(TLScene1(size: self.size))
                    }
                    
                    if(node.name == NodeNames.ReturnToMenuButton){
                        self.view?.presentScene(MenuScene(size: self.size))
                    }
            }
            
        }
        
    }
    
    
    override func didSimulatePhysics() {
        
        if(state != .Running){
            return
        } else {
            guard let bat = bat else { return }
            bat.update()
        }
    }
    
    private func setupPauseButton(){
        pauseButton = PauseButton(buttonType: .Pause)
        
        if let pauseButton = pauseButton{
            self.addChild(pauseButton)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(state != .Running){
            return
        } else {
            guard let player = player else { return }
            
            let touch = touches.first! as UITouch
            let touchLocation = touch.location(in: self)
            
            //player.updateTargetPosition(position: touchLocation) //Better suited for production version
            
            player.position = touchLocation
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if(state != .Running){
            return
        } else {
           
                if(timerIsStarted){
                    totalRunningTime += currentTime - lastUpdateTime
                  
                    
                    if let player = player, let bat = bat{
                        player.update()
                        bat.checkForReposition()
                    }
                    
                    if(kDebug){
                        print("Current running time: \(totalRunningTime)")
                    }
                }
                
            
                
            
        }
        
        lastUpdateTime = currentTime
        
    }
    
    
    func configureBasicSceneElements(withPlayerTypeOf crossHairType: CrossHair.CrossHairType, andWithBackgroundOf backgroundType: Background.BackgroundType, withBackgroundMusicFrom fileName: String){
        
        //Configure GameNode Properties
        gameNode.scale(to: self.size)
        gameNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gameNode.position = CGPoint.zero
        gameNode.zPosition = 8
        gameNode.color = SKColor.black
        gameNode.alpha = 0.4
        
        //Configure background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: fileName, forParentNode: self)
        
        //Set the anchor point of the scene to (0.5,0.5)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        //Configure player
        player = CrossHair(crossHairType: .BlueLarge)
        if let player = player{
            player.zPosition = 3
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
            self.addChild(hud)
        }
       
        
        
    }
    
    private func setupEnemies(){
        bat = Bat()
        if let bat = bat{
            gameNode.addChild(bat)
        }
    }
    
    private func setupIntroMessageBox(){
        let currentLevelTimeLimit = self.timeLimit
        
        introButton = createIntroMessageWith(levelTitle: "Level 1", levelDescription: "Find all the bats and shoot them", levelTimeLimit: currentLevelTimeLimit)
        
        if let introButton = introButton {
            self.addChild(introButton)

        }
        
       
    }
    
        
    func gameOver(){
        
        if let bat = bat{
            bat.removeAllActions()
            bat.physicsBody?.velocity = CGVector.zero
        }
        
        if let hud = hud{
            hud.showRestartButtons()
        }
    }
    
    //MARK: - State 
    func stateRunning(){
        state  = .Running
        timerIsStarted = true
    }
    
    func statePaused(){
        state = .Paused
        timerIsStarted = false
    }
    
    func stateResume(){
        state = .Running
        timerIsStarted = true
    }
    
    func stateGameOver(){
        state = .GameOver
        timerIsStarted = false
        gameOver()
    }
    
}
