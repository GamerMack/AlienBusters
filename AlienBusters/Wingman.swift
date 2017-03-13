//
//  Wingman.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/13/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class Wingman: SKSpriteNode{
    
    let textureAtlas = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .Enemies)
    
    
    var flappingAnimation: SKAction!
        
       
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init?(scalingFactor: CGFloat) {
        
        guard let wingmanTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .Enemies)?.textureNamed("wingMan1") else { return nil }
        
        let wingmanSize = wingmanTexture.size()
        
        self.init(texture: wingmanTexture, color: .clear, size: wingmanSize)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: wingmanSize.width/2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        self.physicsBody?.collisionBitMask = ~PhysicsCategory.Enemy
        
        
        self.xScale *= scalingFactor
        self.yScale *= scalingFactor
        
        createFlappingAnimation()
    }
    
    
    private func createFlappingAnimation(){
        
        let textureAtlas = self.textureAtlas!
        
        let flapDownSequence = SKAction.animate(with: [
            textureAtlas.textureNamed("wingMan1"),
            textureAtlas.textureNamed("wingMan2"),
            textureAtlas.textureNamed("wingMan3"),
            textureAtlas.textureNamed("wingMan4"),
            textureAtlas.textureNamed("wingMan5"),

            ], timePerFrame: 0.10)
        
        let flapUpSequence = SKAction.reversed(flapDownSequence)()
        
        let flappingSequence = SKAction.sequence([
            flapDownSequence,
            flapUpSequence
            ])
        
        flappingAnimation = SKAction.repeatForever(flappingSequence)
        
        self.run(flappingAnimation, withKey: "flappingAnimation")
    }
    
    
    func updatePhysics(){
        
        let randomVector = RandomVector.init(yComponentMin: -5, yComponentMax: 5, xComponentMin: -5, xComponentMax: 5)
    
        self.physicsBody?.velocity = randomVector.getVector()
    }
    
    
}
