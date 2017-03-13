//
//  Spikeman.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/13/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Spikeman: SKSpriteNode{
    
    let textureAtlasManager = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .Enemies)
    
    var health: Int = 2
    var initialVelocity = 50.0
    var isDamaged = false
    
    var jumpAnimation = SKAction()
    var walkingAnimation = SKAction()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init?(startingHealth: Int = 2) {
        
        
        guard let spikemanTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .Enemies)?.textureNamed("spikeMan_stand") else { return nil }
        
        let spikemanSize = spikemanTexture.size()
        
        self.init(texture: spikemanTexture, color: .clear, size: spikemanSize)
        
        self.health = startingHealth
        
        self.xScale *= 0.6
        self.yScale *= 0.6
        
        configurePhysicsProperties(physicsBodyRadius: spikemanSize.width/2)
        configureWalkingAction()
        configureJumpAction()
        
        self.run(walkingAnimation, withKey: "walkingAnimation")
        
    }
    
    
    //Configuration Functions
    
    private func configurePhysicsProperties(physicsBodyRadius: CGFloat){
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: physicsBodyRadius)
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.friction = 0.0
        self.physicsBody?.linearDamping = 0.0
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.Enemy 
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Animal
        
        self.physicsBody?.velocity.dx = CGFloat(initialVelocity)
        
    }
    
    private func configureWalkingAction(){
        
        guard let textureAtlasManager = textureAtlasManager else { return }
        
        let walkingAction = SKAction.animate(with: [
            textureAtlasManager.textureNamed("spikeMan_walk1"),
            textureAtlasManager.textureNamed("spikeMan_walk2")
            ], timePerFrame: 0.25)
    
        walkingAnimation = SKAction.repeatForever(walkingAction)
        
    }
    
    private func configureJumpAction(){
        
        guard let textureAtlasManager = textureAtlasManager else { return }
        
        let jumpAction = SKAction.animate(with: [
            textureAtlasManager.textureNamed("spikeMan_stand"),
            textureAtlasManager.textureNamed("spikeMan_jump")
            ], timePerFrame: 0.25)
        
        jumpAnimation = jumpAction
    }
    
    
    //Game loop functions
    
    func updatePhysics(){
        //Get random point
        let randomSource = GKLinearCongruentialRandomSource()
        let randomDist = GKRandomDistribution(randomSource: randomSource, lowestValue: -Int(ScreenSizeFloatConstants.HalfScreenWidth*0.7), highestValue: Int(ScreenSizeFloatConstants.HalfScreenWidth*0.7))
        
        let xPosition = self.position.x
        let yPosition = self.position.y
        
        let randomPoint = CGPoint(x: randomDist.nextInt(), y: Int(yPosition))
        
        
        let minAllowableXPosition = -ScreenSizeFloatConstants.HalfScreenWidth*0.9
        let maxAllowableXPosition = ScreenSizeFloatConstants.HalfScreenWidth*0.9
        
        if(xPosition < minAllowableXPosition || xPosition > maxAllowableXPosition){
            if let currentXVelocity = self.physicsBody?.velocity.dx{
                self.physicsBody?.velocity.dx = -currentXVelocity
            }
        }
        
    }
    
    func isInDamagedState() -> Bool{
        return isDamaged
    }
    
    func toggleDamageState(){
        isDamaged = !isDamaged
    }
    
    func takeDamage(){
        self.removeAction(forKey: "walkingAnimation")
        let originalZPosition = self.zPosition
        let originalVelocity = self.physicsBody?.velocity
        
        self.run(
            SKAction.sequence([
                SKAction.rotate(byAngle: CGFloat(90.0*M_PI/180.0), duration: 1.0),
                SKAction.run({
                    self.isDamaged = true
                    self.physicsBody?.velocity = CGVector.zero
                    self.physicsBody?.categoryBitMask = PhysicsCategory.DamagedEnemy
                    }),
                SKAction.wait(forDuration: 2.0),
                SKAction.rotate(toAngle: originalZPosition, duration: 1.0),
                SKAction.run({
                    self.isDamaged = false
                    self.physicsBody?.velocity = originalVelocity!
                    self.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
                    self.run(self.walkingAnimation, withKey: "walkingAnimation")
                }),
                
                ])
        )
        
        
    }
    
    
}
