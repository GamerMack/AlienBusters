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
    
    //SceneInterfaceManagerDelegate
    weak var sceneInterfaceManagerDelegate: SceneInterfaceManager?

    //GameState Toggle Buttons
    var introButton: SKSpriteNode?
    var pauseButton: SKSpriteNode?
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
        
        
        
        //Setup the pause/resume button
        //setupPauseButton()
        
        //Setup enemies
        setupEnemies()
        
        //Add the gameNode, which provides the dark overlay for hiding the bat
        self.addChild(gameNode)
        
        sceneInterfaceManagerDelegate = SceneInterfaceManager(instantiationMessage: "I've come alive", newManagedScene: self)
        
        guard let sceneInterfaceManagerDelegate = sceneInterfaceManagerDelegate else { return }
        
        
        //Setup the intro message for the current level
        //setupIntroMessageBox()
        sceneInterfaceManagerDelegate.setupIntroMessageBox(levelTitle: "Level 1", levelDescription: "Find all the bats and shoot them!", levelTimeLimit: 30.0)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        
       
        
        switch(state){
            case .Running:
                if let pauseButton = pauseButton, pauseButton.contains(touchLocation){
    
                    ButtonFactory.resetPauseButton(pauseButton: pauseButton, withLabelTextOf: "Resume",  andWithNodeNameOf: NodeNames.ResumeButton, withPauseState: true)
                    
                    print("You tapped the pause button")
                    statePaused()
                }
              
                break
            case .Paused:
                if let pauseButton = pauseButton, pauseButton.contains(touchLocation){
                    
                    ButtonFactory.resetPauseButton(pauseButton: pauseButton, withLabelTextOf: "Pause",  andWithNodeNameOf: NodeNames.PauseButton, withPauseState: false)
        
    
                    print("You tapped the resume button")
                    stateResume()
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
            bat.updatePhysicsWithARC4Random()
        }
    }
    
    private func setupPauseButton(){
        pauseButton = ButtonFactory.createPauseButton()
        if let pauseButton = pauseButton{
            pauseButton.zPosition = 10
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
           updateRunningTime(currentTime: currentTime)
            
            if(currentTime > timeLimit){
                gameOver()
            }
         
            if let player = player, let bat = bat{
                player.update()
            }
            
            lastUpdateTime = currentTime
        
        }
        
      
        
    }
    
    private func updateRunningTime(currentTime: TimeInterval){
        if(timerIsStarted){
            totalRunningTime += currentTime - lastUpdateTime
            
            if(kDebug){
                print("Current running time: \(totalRunningTime)")
            }
        }
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
    
    /** REFACTOR: This method will be called on the scene interface manager delegate
    func setupIntroMessageBox(){
        let currentLevelTimeLimit = self.timeLimit
        
        introButton = ButtonFactory.createIntroMessageWith(levelTitle: "Level 1", levelDescription: "Find all the bats and shoot them", levelTimeLimit: currentLevelTimeLimit)
        
        if let introButton = introButton {
            self.addChild(introButton)

        }
        
       
    }
 
    **/
    
        
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
    
    }
    
}
