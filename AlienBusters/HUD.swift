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
    
    let pauseButton = PauseButton(buttonType: .Pause)

    
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
        
        scoreIconTexture = hudAtlas?.textureNamed("text_score")
        bulletNodeTexture = hudAtlas?.textureNamed("icon_bullet_gold_long")
        
        let scoreIcon = SKSpriteNode(texture: scoreIconTexture)
        let scoreIconSize = scoreIcon.size
        scoreIcon.xScale *= 0.7
        scoreIcon.yScale *= 0.7
        //Configure the size and position of the Kill score icon (assume a scene anchore point of (0.5,0.5)
        let scoreIconYPos = CGFloat(180.0)//screenSize.height/2-23
        let scoreIconXPos = CGFloat(-250.0)//-screenSize.width/2 + 20
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
                let xPos = scoreIconXPos - 50 + CGFloat(index)*(bulletSize.width + 5.0)
                
                newBulletNode.position = CGPoint(x: xPos, y: yPos)
                bulletNodes.append(newBulletNode)
                
                self.addChild(newBulletNode)
            }
        }
        
        setupPauseButton()


    }
    
    private func setupPauseButton(){
        if let pauseButton = pauseButton{
            self.addChild(pauseButton)
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
