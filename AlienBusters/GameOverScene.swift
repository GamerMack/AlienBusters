//
//  GameOver.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class GameOverScene: SKScene{
    
    let textureAtlas = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .Enemies)!
    

    
    var gameOverNode = SKSpriteNode()
    var gameOverReason: String = "Better Luck Next Time"
    
    override func didMove(to view: SKView) {
        
        //Configure background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: BackgroundMusic.GameOver, forParentNode: self)
        
        //Get random point generator
        let randomPointGenerator = RandomGaussianPoint(algorithmType: .Faster)
        
        //Set anchor point equal to center of the screen
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = SKColor.init(red: 0.7, green: 0.2, blue: 0.2, alpha: 0.7)
    
        //Add some decorative textures
        let flymanTexture = textureAtlas.textureNamed("flyMan_fly")
        let flymanNode = SKSpriteNode(texture: flymanTexture)
        flymanNode.position = randomPointGenerator.getLowerLeftQuadrantPoint()
        self.addChild(flymanNode)
        
        let wingmanTexture = textureAtlas.textureNamed("wingMan2")
        let wingmanNode = SKSpriteNode(texture: wingmanTexture)
        wingmanNode.position = randomPointGenerator.getUpperLeftQuadrantPoint()
        self.addChild(wingmanNode)
        
        let batTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .Bats)?.textureNamed("bat")
        let batNode = SKSpriteNode(texture: batTexture)
        batNode.position = randomPointGenerator.getUpperRightQuadrantPoint()
        self.addChild(batNode)
        
        let flyingAlienTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipGreen_manned")
        let flyingAlienNode = SKSpriteNode(texture: flyingAlienTexture)
        flyingAlienNode.position = randomPointGenerator.getLowerRightQuadrantPoint()
        self.addChild(flyingAlienNode)
        
        //Add game over texture
        let gameOverTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .HUD)?.textureNamed("text_gameover")
        gameOverNode = SKSpriteNode(texture: gameOverTexture)
        gameOverNode.position = CGPoint.zero
        
        
        let gameOverLabel = SKLabelNode(fontNamed: kFuturaMediumItalic)
        gameOverLabel.text = gameOverReason
        gameOverLabel.verticalAlignmentMode = .center
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.fontSize = 60
        gameOverLabel.position = CGPoint(x: 0, y: -100)
        gameOverNode.addChild(gameOverLabel)
        
        let pulsingAction = SKAction.repeatForever(SKAction.sequence([
            SKAction.fadeAlpha(to: 0.8, duration: 1.0),
            SKAction.fadeAlpha(to: 1.0, duration: 1.0)
            
            ]))
        
        gameOverNode.run(pulsingAction, withKey: "pulsingAction")
        
        self.addChild(gameOverNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func didSimulatePhysics() {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    
    convenience init(size: CGSize, gameOverReason: String) {
        self.init(size: size)
        self.gameOverReason = gameOverReason
        
    }
}
