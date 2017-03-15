//
//  SpaceShip.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/8/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class SpaceShip: SKSpriteNode, Enemy{
    
    //MARK: *****************Nested Enum Type for Different SpaceShip Types
    enum SpaceShipType{
        case Red1,Red2,Red3
        case Blue1,Blue2,Blue3
        case Green1,Green2,Green3
        case Orange1,Orange2,Orange3
    }
    
    
    //MARK: *********************Fire Emitter Node (for damaged ship)
    let fireEmitterNode: SKEmitterNode = {
        let emitterPath = Bundle.main.path(forResource: "Fire", ofType: "sks")!
        let emitterNode = NSKeyedUnarchiver.unarchiveObject(withFile: emitterPath) as! SKEmitterNode
        return emitterNode
        
    }()
    
    
    
    //MARK: ************************* References to App-level singletons
    private let textureAtlasManager = TextureAtlasManager.sharedInstance
    private let textureAtlas = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)
    
    private let smokeEmitterManager = SmokeEmitterManager.sharedInstance
    
    
    //MARK: ***************** Variables for Ship State
    private var isInStealthMode: Bool = false
    private var health: Int = 2     //2 hits are required to destroy a flying alien
    private var spaceShipType: SpaceShipType = .Red1
    private var travelSpeed: CGFloat = 0.00
    
    //MARK: ***************Timer-Related Variables
    var timeSinceLastFlyModeTransition = 0.00
    var lastUpdateInterval = 0.00
    var flyModeTransitionInterval = 2.00
    var totalGameTime = 0.00
    
    
    //MARK: *******************Random Point Generator
    var randomPointGenerator = RandomPoint(algorithmType: .Faster)
    
    //MARK: *************** INITIALIZERS
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init?(spaceShipTypeOf spaceShipType: SpaceShipType = .Red1, travelSpeedOf travelSpeed: CGFloat = 50.0, scalingFactor: CGFloat = 1.0) {
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
        
        self.xScale *= scalingFactor
        self.yScale *= scalingFactor
        
        setSpaceShipTypeTo(spaceShipType: spaceShipType)
        
        setupWithSpeedOf(travelSpeed: travelSpeed)
        self.travelSpeed = travelSpeed
    }
    
    
    //MARK: **************BASIC CONFIGURATION HELPER FUNCTIONS
    
    private func setSpaceShipTypeTo(spaceShipType: SpaceShipType){
        self.spaceShipType = spaceShipType
    }
    
    private func setupWithSpeedOf(travelSpeed: CGFloat){
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        setRandomPosition()
        
        let randomDist = GKRandomDistribution(lowestValue: 10, highestValue: 300)
        let cgRect = CGRect(x: self.position.x, y: self.position.y, width: CGFloat(randomDist.nextUniform()), height: CGFloat(randomDist.nextUniform()))
        
        let spaceShipPath = CGPath(ellipseIn: cgRect, transform: nil)
      
        let pathAnimation = SKAction.repeatForever(SKAction.follow(spaceShipPath, asOffset: true, orientToPath: true, speed: travelSpeed))
        
        self.run(pathAnimation, withKey: "pathAnimation")
    }
    
    func setRandomPosition(){
        
        let randomPoint = randomPointGenerator.getRandomPointInRandomQuadrant()
        position = randomPoint
        
    }
    
  
    
    //MARK: ***************** GameLoop-Related Function
    
    func update(currentTime: TimeInterval){
        updateFlyingMode(currentTime: currentTime)
        
        
        if(isOffScreen()){
            setupWithSpeedOf(travelSpeed: self.travelSpeed)
        }
    }
    
    private func isOffScreen() -> Bool{
        
        if(position.x > ScreenSizeFloatConstants.HalfScreenWidth || position.x < -ScreenSizeFloatConstants.HalfScreenWidth){
            return true
        }
        
        if(position.y > ScreenSizeFloatConstants.HalfScreenHeight || position.y < -ScreenSizeFloatConstants.HalfScreenHeight){
            return true
        }
        
        return false
    }
    
    private func updateFlyingMode(currentTime: TimeInterval){
        
        timeSinceLastFlyModeTransition += currentTime - lastUpdateInterval
        
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
    
    
   
    
    //MARK: ******************* User-Input Handling Functions
    
    func getHealth() -> Int {
    
        return self.health
    }
    
    
    func respondToHit(){
        
        if(isInStealthMode) { return }
        
            switch(self.health){
            case 2:
               // self.takeDamage(engineState: .NormalRunning)
                if(kDebug){
                    print("Space Ship was hit. Original health level: \(self.health)")
                }
                self.health -= 1

                break
            case 1:
               // self.takeDamage(engineState: .LowFuel)
                if(kDebug){
                    print("Space Ship was hit. Original health level: \(self.health)")
                }
                self.health -= 1
                break
            case 0:
               self.die()
                break
            default:
                self.die()
            }
        
    }
    
    func reduceHealthBy(healthLoss: Int = 1){
        self.health -= healthLoss
    }
    
    func takeDamage1(){
        self.reduceHealthBy(healthLoss: 1)
        fireEmitterNode.targetNode = self
        self.addChild(fireEmitterNode)
    }
    
    func takeDamage2(){
        self.reduceHealthBy(healthLoss: 1)
        fireEmitterNode.particleBirthRate = 500
        fireEmitterNode.particleSpeed = 400
        fireEmitterNode.particleSpeedRange = 50
        fireEmitterNode.emissionAngleRange = 100
    }
    
    func die(){
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.removeFromParent()
            ]))
        
    }
    
    
    deinit{
        print("I've been deinitialized")
    }
    

    
}
