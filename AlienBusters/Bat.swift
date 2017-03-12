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
    
   
    private let textureAtlas = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .Bats)
    
    private let randomPointGenerator = RandomPoint(algorithmType: .Faster)
    private let randomGaussianPointGenerator = RandomGaussianPoint(algorithmType: .Faster)
    
    
    
    private var health: Int = 2     //2 hits are required to destroy a flying alien
    
    private var maxXComponentVelocity: Double = 100.0
    private var maxYComponentVelocity: Double = 100.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init?(scalingFactor: CGFloat = 1.0, startingHealth: Int = 2, maxXVelocity: Double = 100.0, maxYVelocity: Double = 100.0) {
        
        
        //Nonconfigurable parameters
        
        guard let batTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .Bats)?.textureNamed("bat") else { return nil }
        
        let batSize = batTexture.size()
        
        self.init(texture: batTexture,color: SKColor.clear, size: batSize)
        
        performBasicConfiguration(circleRadius: batSize.width/2.0)
        configureActions()
        configureLighting()
        setPosition()

        
        //Configurable parameters
        
        self.xScale *= scalingFactor
        self.yScale *= scalingFactor
        
        self.maxXComponentVelocity = maxXVelocity
        self.maxYComponentVelocity = maxYVelocity
        
        self.health = startingHealth
        
        
        self.run(SKAction.wait(forDuration: 1.0))

    }
    

    
    //MARK: Configuration functions
    
    private func performBasicConfiguration(circleRadius: CGFloat){
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsBody = SKPhysicsBody(circleOfRadius: circleRadius)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        
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
    
    

    
    func setPosition(){
        
        let randomPoint = randomPointGenerator.getFullScreenPoint()
        self.position = randomPoint
        
    }
    
    
    
    //MARK: GameLoop-Related Functions 
    
    func updatePhysics(){
        checkForReposition()
        
        let randomVector = RandomVector(yComponentMin: -maxYComponentVelocity, yComponentMax: maxYComponentVelocity, xComponentMin: -maxXComponentVelocity, xComponentMax: maxXComponentVelocity)
        
        self.physicsBody?.velocity = randomVector.getVector()
    }
    
    private func checkForReposition(){
        if(position.x < -kViewWidth/1.8 || position.x > kViewWidth/1.8){
            setPosition()
        }
        
        if(position.y < -kViewHeight/1.8 || position.y > kViewHeight/1.8){
            setPosition()
        }
    }
    
    
    //MARK:  User input event handlers
    
    func respondToHitAt(touchLocation: CGPoint){
        
        if self.contains(touchLocation){
            
                AnimationsFactory.createExplosionFor(spriteNode: self)
                self.run(SKAction.sequence([
                    SKAction.wait(forDuration: 2.0),
                    SKAction.removeFromParent()
                    ]))
                
        }
        
            
    }


    
}
