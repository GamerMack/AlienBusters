//
//  FallingAliens.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class FallingAlien: SKSpriteNode, Enemy{
    
    enum AlienColor{
        case pink,yellow,blue,green
    }
    
    private let textureAtlasManager = TextureAtlasManager.sharedInstance
    private let textureAtlas = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)
    
    //2 hits are required to destroy a flying alien
    var health: Int = 2
    var drift = CGFloat()
    
    var isManned: Bool = true
    
     var alienColor: AlienColor = .blue
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init?(alienColor: AlienColor) {
        var texture: SKTexture?
        
        switch(alienColor){
        case .blue:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipBlue_manned")
            break
        case .pink:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipPink_manned")
            break
        case .yellow:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipYellow_manned")
            break
        case .green:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipGreen_manned")
            break
        default:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipBlue_manned")
            
        }
        
        guard let alienTexture = texture else { return nil }
        
        self.init(texture: alienTexture, color: .clear, size: alienTexture.size() )
        setAlienColorTo(alienColor: alienColor)
        setup()
    }
    
    private func setAlienColorTo(alienColor: AlienColor){
        self.alienColor = alienColor
    }
    
    private func setup(){
        position = CGPoint(x: -20.0, y: 20.0)
        configurePhysics()
    }
    
    private func configurePhysics(){
        
        guard let texture = self.texture else { return }
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: texture.size().width/2, center: self.position)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Ground
        
    }
    
    func update(currentTime: TimeInterval){
        //Move down the Y Axis
        self.position.y = self.position.y-CGFloat(currentTime*2)
        
        //Add the drift to the X position
        self.position.x = self.position.x + self.drift
        
    }
    
    
    
    func respondToHitAt(touchLocation: CGPoint){
        
        if(!isManned) { return }
        
        if self.contains(touchLocation){
            
            switch(self.health){
            case 2:
                self.run(SKAction.fadeAlpha(to: 0.6, duration: 0.25))
                self.health -= 1
                break
            case 1:
                self.run(SKAction.fadeAlpha(to: 0.3, duration: 0.25))
                self.health -= 1
                break
            case 0:
                createExplosionFor(spriteNode: self)
                self.run(SKAction.sequence([
                    SKAction.wait(forDuration: 2.0),
                    SKAction.removeFromParent()
                    ]))
                break
            default:
                createExplosionFor(spriteNode: self)
                self.run(SKAction.sequence([
                    SKAction.wait(forDuration: 2.0),
                    SKAction.removeFromParent()
                    ]))
            }
        }
    
    }

}

