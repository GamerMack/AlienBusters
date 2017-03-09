//
//  Bat.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/8/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class Bat: SKSpriteNode{
    
    
    //Timer-Related Variables
    /**
    var timeSinceLastFlyModeTransition = 0.00
    var lastUpdateInterval = 0.00
    var flyModeTransitionInterval = 2.00
    var totalGameTime = 0.00
     **/
    
    private let textureAtlasManager = TextureAtlasManager.sharedInstance
    private let textureAtlas = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .Enemies)
    
    private var health: Int = 2     //2 hits are required to destroy a flying alien
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init?(scalingFactor: CGFloat = 1.0) {
        
        guard let batTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .Enemies)?.textureNamed("bat") else { return nil }
        
        
        
        let batSize = batTexture.size()
        
        self.init(texture: batTexture,color: SKColor.clear, size: batSize)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.xScale *= scalingFactor
        self.yScale *= scalingFactor
        
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: batSize.width/2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false 

        setPosition()
        configureActions()
        configureLighting()

    }
    
    
   
    
    func setPosition(){
        
        var randomXPos = Int(arc4random_uniform(UInt32(kViewWidth/2)))
        var randomYPos = Int(arc4random_uniform(UInt32(kViewHeight/2)))
        
        RandomizeSign(coordinateValue: &randomXPos)
        RandomizeSign(coordinateValue: &randomYPos)
        
        self.position = CGPoint(x: randomXPos, y: randomYPos)

    }
    
    
 
    
    private func configureActions(){
        
        guard let textureAtlas = textureAtlas else { return }
        
        let flyingAction = SKAction.animate(with: [
            textureAtlas.textureNamed("bat"),
            textureAtlas.textureNamed("bat-fly")
            ], timePerFrame: 0.25)
        let flyingAnimation = SKAction.repeatForever(flyingAction)
        self.run(flyingAnimation)
        
        
        
        
    }
    
    private func configureLighting(){
        self.lightingBitMask = 1
    }
    
    
    func checkForReposition(){
        if(position.x < -kViewWidth/1.8 || position.x > kViewWidth/1.8){
            setPosition()
        }
        
        if(position.y < -kViewHeight/1.8 || position.y > kViewHeight/1.8){
            setPosition()
        }
    }
    
    
    func update(){
        
        guard let currentVelocity = self.physicsBody?.velocity else { return }
        
        let currentXVelocity = currentVelocity.dx
        let currentYVelocity = currentVelocity.dy
        
        if(currentYVelocity < CGFloat(30) && currentXVelocity < CGFloat(30.0)){

            var randomXImpulse = Int(arc4random_uniform(2))
            var randomYImpulse = Int(arc4random_uniform(2))
        
            RandomizeSign(coordinateValue: &randomXImpulse)
            RandomizeSign(coordinateValue: &randomYImpulse)
        
            let impulseVector = CGVector(dx: randomXImpulse, dy: randomYImpulse)
            self.physicsBody?.applyImpulse(impulseVector)
        }
    }
    
    
   
   
    
    
}
