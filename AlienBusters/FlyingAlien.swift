//
//  FlyingAlien.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class FlyingAlien: SKSpriteNode, Enemy{
    
    enum AlienColor{
        case pink,yellow,blue,green
    }
    
   
    private let textureAtlasManager = TextureAtlasManager.sharedInstance
    private let textureAtlas = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)
    
    //Timer-Related Variables
    var timeSinceLastFlyModeTransition = 0.00
    var lastUpdateInterval = 0.00
    var flyModeTransitionInterval = 5.00
    var totalGameTime = 0.00
    
    
    var health: Int = Int(2)           //2 hits are required to destroy a flying alien
    var alienColor: AlienColor = .blue
    
    let randomPointGenerator = RandomPoint(algorithmType: .Faster)
    
    //var defaultForceApplied = 40.0
    var isManned: Bool = false{
        didSet{
            switch(self.alienColor){
                case .blue:
                    if(isManned){
                        self.run(SKAction.setTexture(TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)!.textureNamed("shipBlue_manned")))
                    }else{
                        self.run(SKAction.setTexture(TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)!.textureNamed("shipBlue")))
                    }
                    break
                case .green:
                    if(isManned){
                        self.run(SKAction.setTexture(TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)!.textureNamed("shipGreen_manned")))
                    }else{
                        self.run(SKAction.setTexture(TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)!.textureNamed("shipGreen")))
                    }
                    break
                case .yellow:
                    if(isManned){
                        self.run(SKAction.setTexture(TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)!.textureNamed("shipYellow_manned")))
                    }else{
                        self.run(SKAction.setTexture(TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)!.textureNamed("shipYellow")))
                    }
                    break
                case .pink:
                    if(isManned){
                        self.run(SKAction.setTexture(TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)!.textureNamed("shipPink_manned")))
                    }else{
                        self.run(SKAction.setTexture(TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)!.textureNamed("shipPink")))
                    }
                    break
                
            }
           
        }
    }
    
    
    
    
  
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init?(alienColor: AlienColor, startingHealth: Int = 2) {
        var texture: SKTexture?

        switch(alienColor){
        case .blue:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipBlue")
            break
        case .pink:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipPink")
            break
        case .yellow:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipYellow")
            break
        case .green:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipGreen")
            break
        default:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipBlue")
        }
        
        guard let alienTexture = texture else { return nil }
        
        self.init(texture: alienTexture, color: .clear, size: alienTexture.size() )
        setAlienColorTo(alienColor: alienColor)
        setup()
        self.health = startingHealth
    }
    
    private func setAlienColorTo(alienColor: AlienColor){
        self.alienColor = alienColor
    }
    
    private func setup(){
        position = randomPointGenerator.getRandomPointInRandomQuadrant()
        configurePhysics()
    }
    
    private func configurePhysics(){
        
        guard let texture = self.texture else { return }
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: texture.size().width/2, center: self.position)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        self.physicsBody?.collisionBitMask = PhysicsCategory.Ground
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Ground
        
    }
    
    
    
    func updateFlyingMode(currentTime: TimeInterval){
        timeSinceLastFlyModeTransition += currentTime - lastUpdateInterval
        
        if(timeSinceLastFlyModeTransition > flyModeTransitionInterval){
            isManned = !isManned
            timeSinceLastFlyModeTransition = 0
        }
        
        lastUpdateInterval = currentTime
        
    }
    
    func updatePhysics(){
        
        self.physicsBody?.velocity = getRandomVectorAjustedForHealth()

    }
    
    private func getRandomVectorAjustedForHealth() -> CGVector{
        
        var randomVector: RandomVector
        
        switch(self.health){
        case 2:
            randomVector = RandomVector(yComponentMin: 200, yComponentMax: 300, xComponentMin: 200, xComponentMax: 300)
            randomVector.randomizeXComponentSign()
            randomVector.randomizeYComponentSign()
            break
        case 1:
            randomVector = RandomVector(yComponentMin: 200, yComponentMax: 300, xComponentMin: 200, xComponentMax: 300)
            randomVector.randomizeYComponentSign()
            randomVector.randomizeYComponentSign()
            break
        case 0:
            randomVector = RandomVector(yComponentMin: 200, yComponentMax: 300, xComponentMin: 200, xComponentMax: 300)
            randomVector.randomizeYComponentSign()
            randomVector.randomizeXComponentSign()
            break
        default:
            randomVector = RandomVector(yComponentMin: 200, yComponentMax: 300, xComponentMin: 200, xComponentMax: 300)
                randomVector.randomizeXComponentSign()
                randomVector.randomizeYComponentSign()
            break
        }
        
        return randomVector.getVector()
        
    }
    
    
    func respondToHit(){
        
        if(!isManned) { return }
        
            switch(self.health){
            case 2:
                self.run(SKAction.sequence([
                    SKAction.rotate(byAngle: 90, duration: 0.50),
                    SKAction.rotate(byAngle: 90, duration: 0.50),
                    SKAction.rotate(byAngle: 90, duration: 0.50),
                    SKAction.rotate(byAngle: 90, duration: 0.50)
                    ]))
                print("Health Level 2, now decreased to Level 1")
                self.health -= 1
                break
            case 1:
                self.run(SKAction.sequence([
                    SKAction.rotate(byAngle: 90, duration: 0.50),
                    SKAction.rotate(byAngle: 90, duration: 0.50),
                    SKAction.rotate(byAngle: 90, duration: 0.50),
                    SKAction.rotate(byAngle: 90, duration: 0.50)
                    ]))
                print("Health Level 1, now decreased to Level 0")
                self.health -= 1
                break
            case 0:
                print("About to explode...")

                AnimationsFactory.createExplosionFor(spriteNode: self)
                self.run(SKAction.sequence([
                    SKAction.wait(forDuration: 2.0),
                    SKAction.removeFromParent()
                    ]))
                break
            default:
                AnimationsFactory.createExplosionFor(spriteNode: self)
                self.run(SKAction.sequence([
                    SKAction.wait(forDuration: 2.0),
                    SKAction.removeFromParent()
                    ]))
                
            }
        
        
    }
    
    

  
    
 }

enum FlyingAlienType{
    case BlueManned
    case BlueUnmanned
    case BlueDamage1
    case BlueDamage2
    case PinkManned
    case PinkUnmanned
    case PinkDamage1
    case PinkDamge2
    case YellowManned
    case YellowUnmanned
    case YellowDamage1
    case YellowDamage2
    case GreenManned
    case GreenUnmanned
    case GreenDamage1
    case GreenDamage2
}



extension FlyingAlienType{
    
    
    var texture: SKTexture?{
        get{
            var texture: SKTexture?
            
            switch(self){
            case .BlueManned:
                texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipBlue_manned")
            case .BlueUnmanned:
                texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipBlue")
            case .BlueDamage1:
                texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipBlue_damage1")
            case .BlueDamage2:
                texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipBlue_damage2")
            case .YellowManned:
                texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipYellow_manned")
            case .YellowUnmanned:
                texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipYellow")
            case .YellowDamage1:
                texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipYellow_damage1")
            case .YellowDamage2:
                texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipBlue_damage2")
            case .GreenManned:
                texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipGreen_manned")
            case .GreenUnmanned:
                texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipGreen")
            case .GreenDamage1:
                texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipGreen_damage1")
            case .GreenDamage2:
                texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipGreen_damage2")
            case .PinkManned:
                texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipPink_manned")
            case .PinkUnmanned:
                texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipPink")
            case .PinkDamage1:
                texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipPink_damage1")
            case .PinkDamge2:
                texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)?.textureNamed("shipPink_damage2")
            }
            
            return texture
        }
    }

    
}
