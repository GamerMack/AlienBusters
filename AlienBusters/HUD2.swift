//
//  HUD2.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class HUD2: SKSpriteNode{
    
    //MARK: TextureAtlasManager singleton and HUD TextureAtlas
    private let textureAtlasManager = TextureAtlasManager.sharedInstance
    private let hudAtlas = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .HUD)
    
    
    //MARK: Return-to-Menu and Restart Buttons
    var restartButton: SKSpriteNode?
    var menuButton: SKSpriteNode?
    
    //MARK: Game Performance/Stats Metrics (dynamically updated)
    
    var numberOfEnemiesKilled = SKLabelNode(text: "00000")
    var currentNumberOfEnemies = SKLabelNode(text: "00000")
    
    //MARK: Displays/Indicators (static and preconfigured)
    
    var numberKilledTexture: SKTexture?
    var numberEnemiesLabel = SKLabelNode(text: "Number of Enemies Spawned: ")
    
    //MARK:*********** INITIALIZATION METHODS
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    
    convenience init() {
        
        
        self.init(texture: nil, color: .clear, size: CGSize(width: ScreenSizeFloatConstants.ScreenWidth, height: ScreenSizeFloatConstants.ScrrenHeight))
        
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.zPosition = 10
        self.size = CGSize(width: ScreenSizeFloatConstants.ScreenWidth, height: ScreenSizeFloatConstants.ScrrenHeight)
        
        guard let numberKilledTexture = hudAtlas?.textureNamed("text_score") else { return }
        
        let killCountIcon = SKSpriteNode(texture: numberKilledTexture)
        
        killCountIcon.xScale *= 0.7
        killCountIcon.yScale *= 0.7
        
        //Configure the size and position of the Kill score icon (assume a scene anchore point of (0.5,0.5)
        let iconYPos = CGFloat(ScreenSizeFloatConstants.HalfScreenHeight*0.8)
        let iconXPos = CGFloat(-ScreenSizeFloatConstants.HalfScreenWidth*0.8)
        killCountIcon.position = CGPoint(x: iconXPos, y: iconYPos)
        
        
        //Configure the killCountText display
        numberOfEnemiesKilled.fontName = FontTypes.NoteWorthyBold
        numberOfEnemiesKilled.fontColor = SKColor.white
        numberOfEnemiesKilled.position = CGPoint(x: iconXPos + 100, y: iconYPos)
        
        numberOfEnemiesKilled.verticalAlignmentMode = .center
        numberOfEnemiesKilled.horizontalAlignmentMode = .left
        
        self.addChild(numberOfEnemiesKilled)
        self.addChild(killCountIcon)
        
        numberEnemiesLabel.fontName = FontTypes.NoteWorthyBold
        numberEnemiesLabel.fontColor = SKColor.white
        numberEnemiesLabel.fontSize = 15.0
        numberEnemiesLabel.verticalAlignmentMode = .top
        numberEnemiesLabel.horizontalAlignmentMode = .center
        
        currentNumberOfEnemies.fontName = FontTypes.NoteWorthyBold
        currentNumberOfEnemies.fontColor = SKColor.white
        currentNumberOfEnemies.fontSize = 15.0
        currentNumberOfEnemies.verticalAlignmentMode = .top
        currentNumberOfEnemies.horizontalAlignmentMode = .left
        
        numberEnemiesLabel.position = CGPoint(x: iconXPos + 30, y: iconYPos - 50)
        currentNumberOfEnemies.position = CGPoint(x: iconXPos + 150, y: iconYPos - 50)
        
        
        self.addChild(numberEnemiesLabel)
        self.addChild(currentNumberOfEnemies)
        
        
        
        setupRestartButtons()
        
        
    }
    
    //MARK: Helper Function for Updated Labels
    
    func setNumberOfEnemiesTo(numberOfEnemies: Int){
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 3
        formatter.maximumIntegerDigits = 3
        let numberString = formatter.string(from: NSNumber(value: numberOfEnemies))
        currentNumberOfEnemies.text = numberString

    }
    
    func setNumberOfEnemiesKilledTo(numberKilled: Int){
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 3
        formatter.maximumIntegerDigits = 3
        let numberString = formatter.string(from: NSNumber(value: numberKilled))
        numberOfEnemiesKilled.text = numberString

    }
    
    
    private func setupRestartButtons(){
        
        guard let menuButtonTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .HUD)?.textureNamed("button-menu") else { return }
        
        guard let restartButtonTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .HUD)?.textureNamed("button-restart") else { return }
        
        menuButton = SKSpriteNode(texture: menuButtonTexture)
        
        restartButton = SKSpriteNode(texture: restartButtonTexture)
        
        if let menuButton = menuButton, let restartButton = restartButton{
            menuButton.name = NodeNames.ReturnToMenuButton
            restartButton.name = NodeNames.RestartGameButton
            
            menuButton.size = CGSize(width: kViewWidth*0.2, height: kViewHeight*0.3)
            restartButton.size = CGSize(width: kViewWidth*0.2, height: kViewHeight*0.3)
            
            menuButton.position = CGPoint(x: kViewWidth*0.5*0.2, y: 0)
            restartButton.position = CGPoint(x: menuButton.position.x - menuButton.size.width - 30, y: menuButton.position.y)
            
            let returnToMenuText = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
            returnToMenuText.text = "Main Menu"
            returnToMenuText.fontSize = 20.0
            returnToMenuText.fontColor = SKColor.white
            returnToMenuText.verticalAlignmentMode = .bottom
            returnToMenuText.position = CGPoint(x: 0, y: -menuButton.size.height)
            menuButton.addChild(returnToMenuText)
            
            let restartGameText = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
            restartGameText.text = "Restart Level"
            restartGameText.fontSize = 20.0
            restartGameText.fontColor = SKColor.white
            restartGameText.verticalAlignmentMode = .bottom
            restartGameText.position = CGPoint(x: 0, y: -restartButton.size.height)
            restartButton.addChild(restartGameText)
            
            restartButton.zPosition = -15
            menuButton.zPosition = -15
            
            restartButton.alpha = 0
            menuButton.alpha = 0
            
            
            
        }
        
    }
        
        func showRestartButtons(){
            //Set the button alpha to zero
            if let restartButton = restartButton, let menuButton = menuButton{
               
                self.addChild(restartButton)
                self.addChild(menuButton)
                
                restartButton.alpha = 0
                menuButton.alpha = 0
                
                
                
                menuButton.zPosition = 12
                restartButton.zPosition = 12
                
                
                let fadeAnimation = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
                
                restartButton.run(fadeAnimation)
                menuButton.run(fadeAnimation)
            }
            
    }
    
        
    
}