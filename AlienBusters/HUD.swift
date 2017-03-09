//
//  HUD.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


class HUD: SKSpriteNode{
    
    private let textureAtlasManager = TextureAtlasManager.sharedInstance
    private let hudAtlas = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .HUD)
    
    var restartButton: SKSpriteNode?
    var menuButton: SKSpriteNode?
    
    var bulletNodes: [SKSpriteNode] = []
    var killCountText = SKLabelNode(text: "00000")
    
    var scoreIconTexture: SKTexture?
    var bulletNodeTexture: SKTexture?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init() {
        self.init(texture: nil, color: .clear, size: CGSize(width: 300, height: 300))
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.zPosition = 10
        self.size = CGSize(width: kViewWidth, height: kViewHeight)
        
        scoreIconTexture = hudAtlas?.textureNamed("text_score")
        bulletNodeTexture = hudAtlas?.textureNamed("icon_bullet_gold_long")
        
        let scoreIcon = SKSpriteNode(texture: scoreIconTexture)
        let scoreIconSize = scoreIcon.size
        scoreIcon.xScale *= 0.7
        scoreIcon.yScale *= 0.7
        
        //Configure the size and position of the Kill score icon (assume a scene anchore point of (0.5,0.5)
        let scoreIconYPos = CGFloat(kViewHeight*0.5*0.8)
        let scoreIconXPos = CGFloat(-kViewWidth*0.5*0.8)
        scoreIcon.position = CGPoint(x: scoreIconXPos, y: scoreIconYPos)
        
        
        //Configure the killCountText display
        killCountText.fontName = "IowanOldStyle-Bold"
        killCountText.fontColor = SKColor.black
        killCountText.position = CGPoint(x: scoreIconYPos, y: scoreIconYPos)
        
        killCountText.verticalAlignmentMode = .center
        killCountText.horizontalAlignmentMode = .left
        
        self.addChild(killCountText)
        self.addChild(scoreIcon)
        
        //Create the bullets for the player's ammunition
        for index in 0...4{
            if let bulletNodeTexture = bulletNodeTexture{
                let bulletSize = bulletNodeTexture.size()
                
                let newBulletNode = SKSpriteNode(texture: bulletNodeTexture)
                
                let yPos = scoreIconYPos - scoreIconSize.height
                let xPos = scoreIconXPos - kViewWidth*0.07 + CGFloat(index)*(bulletSize.width + 5.0)
                
                newBulletNode.position = CGPoint(x: xPos, y: yPos)
                bulletNodes.append(newBulletNode)
                
                self.addChild(newBulletNode)
            }
        }
        
        
        setupRestartButtons()


    }
    
    func showRestartButtons(){
        //Set the button alpha to zero
        if let restartButton = restartButton, let menuButton = menuButton{
            restartButton.alpha = 0
            menuButton.alpha = 0
            
            self.addChild(restartButton)
            self.addChild(menuButton)
            
            let fadeAnimation = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
            
            restartButton.run(fadeAnimation)
            menuButton.run(fadeAnimation)
        }
        
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
            returnToMenuText.verticalAlignmentMode = .bottom
            returnToMenuText.position = CGPoint(x: 0, y: -menuButton.size.height)
            menuButton.addChild(returnToMenuText)
            
            let restartGameText = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
            restartGameText.text = "Restart Level"
            restartGameText.fontSize = 20.0
            restartGameText.verticalAlignmentMode = .bottom
            restartGameText.position = CGPoint(x: 0, y: -restartButton.size.height)
            restartButton.addChild(restartGameText)
            
            
        }
        
        
       
        
    }
    
  
    func setKillCountDisplay(newKillCount: Int){
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 5
        
        if let killCount = formatter.string(from: NSNumber(value: newKillCount)){
            killCountText.text = killCount
        }
        
    }
    
    func setBulletDisplay(newBulletAmount: Int){
        let emptyBulletTexture = hudAtlas?.textureNamed("icon_bullet_empty_long")
        
        if let emptyBulletTexture = emptyBulletTexture{
            let textureChangeAction = SKAction.setTexture(emptyBulletTexture)
            
            for index in 0...bulletNodes.count-1{
                if index < newBulletAmount{
                    bulletNodes[index].alpha = 1.0
                } else {
                    bulletNodes[index].run(textureChangeAction)
                }
            }
        }
    }
}
