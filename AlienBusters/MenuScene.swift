//
//  MenuScene.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/8/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

/**
 TODO: Easy,medium, and hard buttons should be added to a container node whose zPosition can be set behind the main screen after a selection is made
 TODO: Likewise, GamePlayMode buttons should be added to a container node whose zPosition can be set behidn the screen upon selection
 
 TODO: A small arrow menu should allow user to navigate between different option screens (i.e. Difficulty Selection and GamePlayMode) as well as to QUIT the game
 
 **/

class MenuScene: SKScene{
    
    //Texture Atlas for MenuScene
    let textureAtlas: SKTextureAtlas? = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .UI)
    
    //Menu Button
    let startButton: SKSpriteNode = SKSpriteNode()
    
    //Difficulty Configuration Buttons
    var hardButton = SKSpriteNode()
    var mediumButton = SKSpriteNode()
    var easyButton = SKSpriteNode()
    
    //GamePlayMode Configuration Buttons
    var noTimeLimitModeButton = SKSpriteNode()
    var timeLimitModeButton = SKSpriteNode()
    
    //User Options Manager
    let userOptionsManager = UserOptionsManager.sharedInstance
    
    override func didMove(to view: SKView) {
        
    
        self.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        
        //Setup background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: BackgroundMusic.GermanVirtue, forParentNode: self)
        
        //Setup background image
        configureBackground()
        
        //Setup game title
        setupGameTitle()
        
        //Setup start button
        setupStartButton()
        
        
        //Add characters for background decoration
        setupBackgroundDecoration()
     
        
        //Build difficulty options buttons
        setupDifficultyOptionsButtons()
        
        //Build GamePlayMode buttons
        setupGamePlayModeButtons()
        
    }
    
    func getButtonWith(textureNamed textureName: String, andWithTextOf buttonText: String, atPosition position: CGPoint, andWithSizeOf size: CGSize = CGSize(width: 295, height: 75)) ->SKSpriteNode {
        
        guard let textureAtlas = self.textureAtlas else { return SKSpriteNode() }
        
        var button = SKSpriteNode()
        
        let buttonTexture = textureAtlas.textureNamed(textureName)
        button = SKSpriteNode(texture: buttonTexture)
        button.anchorPoint = CGPoint.zero
        button.size = size
        button.name = buttonText
        button.position = position
        button.zPosition = -20
        
        let buttonTextLabel = SKLabelNode(fontNamed: kFuturaCondensedMedium)
        buttonTextLabel.text = buttonText
        buttonTextLabel.verticalAlignmentMode = .center
        buttonTextLabel.position = CGPoint(x: 100, y: 40)
        buttonTextLabel.fontSize = 40
        buttonTextLabel.fontColor = SKColor.blue
        buttonTextLabel.name = buttonText
        buttonTextLabel.zPosition = 3
        
        button.addChild(buttonTextLabel)
        
        return button
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for t in touches{
            let touchLocation = t.location(in: self)
            let nodeTouched = nodes(at: touchLocation)[0]
            
            if nodeTouched.name == NodeNames.StartButton{
                startButton.removeAllActions()
                startButton.run(SKAction.run({
                    self.startButton.zPosition = -10
                }))
                startButton.run(SKAction.wait(forDuration: 5.0))
                
                hardButton.zPosition = 2
                mediumButton.zPosition = 2
                easyButton.zPosition = 2
                
                
            }
            
            if nodeTouched.name == "Hard"{
                userOptionsManager.setDifficultyLevel(userSelection: "Hard")
                
                hardButton.run(SKAction.run({
                    self.hardButton.zPosition = -10
                    
                    for node in self.hardButton.children{
                        if let node = node as? SKLabelNode{
                            node.zPosition = -10
                        }
                    }
                }))
                hardButton.run(SKAction.wait(forDuration: 5.0))
                
                 self.view?.presentScene(TestScene8(size: self.size, levelNumber: 1, numberOfBackgroundObjects: 3, hideInterval: 5.00, spawnInterval: 5.00, initialNumberOfEnemiesSpawned: 3, enemiesSpawnedPerInterval: 3, randomVectorConfigurationForUpdate: RandomVectorConfiguration(minimumVectorYComponent: -10, maximumVectorYComponent: 10, minimumVectorXComponent: -10, maximumVectorXComponent: 10)))
                
                // noTimeLimitModeButton.zPosition = 2
                // timeLimitModeButton.zPosition = 2

            }
            

            if nodeTouched.name == "Medium"{
                userOptionsManager.setDifficultyLevel(userSelection: "Medium")
                
                mediumButton.run(SKAction.run({
                    self.mediumButton.zPosition = -10
                    
                    for node in self.mediumButton.children{
                        if let node = node as? SKLabelNode{
                            node.zPosition = -10
                        }
                    }
                }))
                mediumButton.run(SKAction.wait(forDuration: 5.0))
                
                 self.view?.presentScene(TestScene8(size: self.size, levelNumber: 1, numberOfBackgroundObjects: 3, hideInterval: 5.00, spawnInterval: 5.00, initialNumberOfEnemiesSpawned: 3, enemiesSpawnedPerInterval: 3, randomVectorConfigurationForUpdate: RandomVectorConfiguration(minimumVectorYComponent: -10, maximumVectorYComponent: 10, minimumVectorXComponent: -10, maximumVectorXComponent: 10)))
                
               // noTimeLimitModeButton.zPosition = 2
              //  timeLimitModeButton.zPosition = 2
            }
            
            if nodeTouched.name == "Easy"{
                userOptionsManager.setDifficultyLevel(userSelection: "Easy")
                
                easyButton.run(SKAction.run({
                    self.easyButton.zPosition = -10
                    
                    for node in self.easyButton.children{
                        if let node = node as? SKLabelNode{
                            node.zPosition = -10
                        }
                    }
                }))
                easyButton.run(SKAction.wait(forDuration: 5.0))
                
                self.view?.presentScene(TestScene8(size: self.size, levelNumber: 1, numberOfBackgroundObjects: 3, hideInterval: 5.00, spawnInterval: 5.00, initialNumberOfEnemiesSpawned: 1, enemiesSpawnedPerInterval: 1, randomVectorConfigurationForUpdate: RandomVectorConfiguration(minimumVectorYComponent: -10, maximumVectorYComponent: 10, minimumVectorXComponent: -10, maximumVectorXComponent: 10)))
                
                //noTimeLimitModeButton.zPosition = 2
                //timeLimitModeButton.zPosition = 2
                
            }
            
            
            /** Gameplay Mode may not be implemented
            
            if nodeTouched.name == "No Time Limit"{
                //userOptionsManager.setGamePlayModeTo(gamePlayMode: "NoTimeLimit")
                self.view?.presentScene(TLScene1(size: self.size))

            }
            
            if nodeTouched.name == "Unlimited Ammunition"{
                //userOptionsManager.setGamePlayModeTo(gamePlayMode: "TimeLimit")
                self.view?.presentScene(TLScene1(size: self.size))

            }
            **/
        }
        
    }
    
    private func configureBackground(){
        let backgroundTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .BackgroundScenes)?.textureNamed("colored_forest")
        
        let backgroundImage = SKSpriteNode(texture: backgroundTexture)
        backgroundImage.size = CGSize(width: self.size.width, height: self.size.height)
        backgroundImage.position = CGPoint.zero
        backgroundImage.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundImage.zPosition = -5
        self.addChild(backgroundImage)
    }
    
    private func setupGameTitle(){
        //Build the label for the GameTitle
        let topTitleNode = SKLabelNode(fontNamed: FontTypes.NoteWorthyBold)
        topTitleNode.fontColor = SKColor.black
        topTitleNode.text = "Stealthy Sniper"
        topTitleNode.zPosition = 2
        topTitleNode.position = CGPoint(x: 0.0, y: 100)
        topTitleNode.fontSize = 60
        self.addChild(topTitleNode)
        
        let bottomTitleNode = SKLabelNode(fontNamed: FontTypes.NoteWorthyBold)
        bottomTitleNode.fontColor = SKColor.black
        bottomTitleNode.text = "against the Alien Invasion"
        bottomTitleNode.position = CGPoint(x: 0.0, y: 40)
        bottomTitleNode.zPosition = 2
        bottomTitleNode.fontSize = 60
        self.addChild(bottomTitleNode)
    }
    
    private func setupStartButton(){
        //Build the start node
        
        guard let textureAtlas = textureAtlas else { return }
        
        startButton.texture = textureAtlas.textureNamed("yellow_button09")
        startButton.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        startButton.size = CGSize(width: 295, height: 76)
        startButton.name = NodeNames.StartButton
        startButton.position = CGPoint(x: 0, y: -80)
        startButton.zPosition = 2
        self.addChild(startButton)
        
        
        
        
        //Build label text for Start Button
        let startButtonText = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
        startButtonText.text = "Start Game"
        startButtonText.verticalAlignmentMode = .center
        startButtonText.position = CGPoint(x: 0, y: 2)
        startButtonText.fontSize = 40
        startButtonText.name = NodeNames.StartButton
        startButtonText.zPosition = 3
        startButton.addChild(startButtonText)
        
        let pulseAnimation = SKAction.repeatForever(SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.25),
            SKAction.fadeAlpha(to: 0.8, duration: 0.25)
            ]))
        
        startButton.run(pulseAnimation, withKey: "startPulseAnimation")
    }
    
    private func setupBackgroundDecoration(){
        

        //Add some alien enemies
        guard let wingmanTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .Enemies)?.textureNamed("wingMan1") else { return }
        
        let wingmanNode = SKSpriteNode(texture: wingmanTexture)
        wingmanNode.xScale *= 1.2
        wingmanNode.yScale *= 1.2
        wingmanNode.position = CGPoint(x: -180, y: -140)
        wingmanNode.zPosition = 1
        wingmanNode.zRotation = -30
        self.addChild(wingmanNode)
        
        
        guard let flymanTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .Enemies)?.textureNamed("flyMan_fly") else {return}
        
        let flymanNode = SKSpriteNode(texture: flymanTexture)
        flymanNode.xScale *= 1.2
        flymanNode.yScale *= 1.2
        flymanNode.position = CGPoint(x: 150, y: 100)
        flymanNode.zPosition = 1
        flymanNode.zRotation = 120
        self.addChild(flymanNode)
        
        
    }
    
    private func setupDifficultyOptionsButtons(){
        hardButton = getButtonWith(textureNamed: "yellow_button06", andWithTextOf: "Hard", atPosition: CGPoint(x: 0, y: 100))
        mediumButton = getButtonWith(textureNamed: "yellow_button06", andWithTextOf: "Medium", atPosition: CGPoint(x: 0, y: 10))
        easyButton = getButtonWith(textureNamed: "yellow_button06", andWithTextOf: "Easy", atPosition: CGPoint(x: 0, y: -75))
        
        self.addChild(hardButton)
        self.addChild(mediumButton)
        self.addChild(easyButton)
    }
    
    private func setupGamePlayModeButtons(){
        noTimeLimitModeButton = getButtonWith(textureNamed: "yellow_button02", andWithTextOf: "No Time Limit", atPosition: CGPoint(x: 0, y: 100))
        
        timeLimitModeButton = getButtonWith(textureNamed: "yellow_button02", andWithTextOf: "Unlimited Ammunition", atPosition: CGPoint(x: 0, y: 10))
        
        self.addChild(noTimeLimitModeButton)
        self.addChild(timeLimitModeButton)
        
    }
    
}
