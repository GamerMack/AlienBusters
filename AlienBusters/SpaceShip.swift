//
//  SpaceShip.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/8/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class SpaceShip: SKSpriteNode{
    enum SpaceShipType{
        case Red1,Red2,Red3
        case Blue1,Blue2,Blue3
        case Green1,Green2,Green3
        case Orange1,Orange2,Orange3
    }
    
    
    //Timer-Related Variables
    var timeSinceLastFlyModeTransition = 0.00
    var lastUpdateInterval = 0.00
    var flyModeTransitionInterval = 2.00
    var totalGameTime = 0.00
    
    private let textureAtlasManager = TextureAtlasManager.sharedInstance
    private let textureAtlas = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)
    
    private var isInStealthMode: Bool = false
    private var health: Int = 2     //2 hits are required to destroy a flying alien
    private var spaceShipType: SpaceShipType = .Red1
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init?(spaceShipType: SpaceShipType) {
        var texture: SKTexture?
        
        switch(spaceShipType){
        case .Blue1:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .SpaceShips)?.textureNamed("playerShip1_blue")
            break
        case .Blue2:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .SpaceShips)?.textureNamed("playerShip2_blue")
            break
        case .Blue3:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .SpaceShips)?.textureNamed("playerShip3_blue")
            break
        case .Green1:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .SpaceShips)?.textureNamed("playerShip1_green")
            break
        case .Green2:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .SpaceShips)?.textureNamed("playerShip2_green")
            break
        case .Green3:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .SpaceShips)?.textureNamed("playerShip3_green")
            break
        case .Orange1:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .SpaceShips)?.textureNamed("playerShip1_orange")
            break
        case .Orange2:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .SpaceShips)?.textureNamed("playerShip2_orange")
            break
        case .Orange3:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .SpaceShips)?.textureNamed("playerShip3_orang")
            break
        case .Red1:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .SpaceShips)?.textureNamed("playerShip1_red")
            break
        case .Red2:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .SpaceShips)?.textureNamed("playerShip2_red")
            break
        case .Red3:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .SpaceShips)?.textureNamed("playerShip3_red")
            break
        default:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .SpaceShips)?.textureNamed("playerShip1_blue")
            break
            
        }
        
        guard let alienTexture = texture else { return nil }
        
        self.init(texture: alienTexture, color: .clear, size: alienTexture.size() )
        setSpaceShipTypeTo(spaceShipType: spaceShipType)
        setup()
    }
    
    private func setSpaceShipTypeTo(spaceShipType: SpaceShipType){
        self.spaceShipType = spaceShipType
    }
    
    private func setup(){
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 1
        
        setRandomPosition()
        let randomWidth = Double(arc4random_uniform(200))
        let randomHeight = Double(arc4random_uniform(200))
        
        let cgRect = CGRect(x: 0, y: 0, width: randomWidth, height: randomHeight)
        
        let spaceShipPath = CGPath(ellipseIn: cgRect, transform: nil)
      
        
        let pathAnimation = SKAction.repeatForever(SKAction.follow(spaceShipPath, asOffset: true, orientToPath: true, speed: 50.0))
        
        self.run(pathAnimation, withKey: "pathAnimation")
    }
    
    func setRandomPosition(){
        let randomXPos = -100 + Int(arc4random_uniform(100))
        let randomYPos = -100 + Int(arc4random_uniform(100))
        position = CGPoint(x: randomXPos, y: randomYPos)
        
        
    }
    
    
    
    func update(currentTime: TimeInterval){
        updateFlyingMode(currentTime: currentTime)
        
        
        if(isOffScreen()){
            setRandomPosition()
        }
    }
    
    private func isOffScreen() -> Bool{
        
        if(position.x > kViewWidth/2 || position.x < -kViewWidth/2){
            return true
        }
        
        if(position.y > kViewHeight/2 || position.y < -kViewHeight/2){
            return true
        }
        
        return false
    }
    
    private func updateFlyingMode(currentTime: TimeInterval){
        
        timeSinceLastFlyModeTransition += currentTime - lastUpdateInterval
        totalGameTime += timeSinceLastFlyModeTransition
        
        if(timeSinceLastFlyModeTransition > flyModeTransitionInterval){
            
            let changeAction = isInStealthMode ?
                SKAction.fadeAlpha(to: 1.0, duration: 0.25) :
                SKAction.fadeAlpha(to: 0.0, duration: 0.25)
            
            self.run(changeAction)
            
            isInStealthMode = !isInStealthMode
            timeSinceLastFlyModeTransition = 0
        }
        
        lastUpdateInterval = currentTime
    }
    
    
    func respondToHitAt(touchLocation: CGPoint){
        
        if(isInStealthMode) { return }
        
        if self.contains(touchLocation){
            
            switch(self.health){
            case 2:
                let emitterNode = SmokeEmitterManager.sharedInstance.createSmokeEmitterFor(engineState: .NormalRunning)
                emitterNode.position = CGPoint(x: 0, y: -10)
                emitterNode.zPosition = 2
                self.addChild(emitterNode)
                self.health -= 1
                break
            case 1:
                self.removeAllChildren()
                let emitterNode = SmokeEmitterManager.sharedInstance.createSmokeEmitterFor(engineState: .Accelerated)
                emitterNode.position = CGPoint(x: 0, y: -10)
                emitterNode.zPosition = 2

                self.addChild(emitterNode)
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
