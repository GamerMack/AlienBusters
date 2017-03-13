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
    
    
    //Interval at which to apply impulse
    var applyImpulseInterval: TimeInterval = 5.00
    
    
    //Variables related to velocity ceilings and floors imposed during physics update
    private var minXVelocityFloor: Float = -20.0
    private var maxXVelocityCeiling: Float = 20.0
    
    private var minYVelocityFloor: Float = -20.0
    private var maxYVelocityCeiling: Float = 20.0
    
    //Variables for configuring impulse applied during physics update
    private var maxXComponentVelocity: Float = 10.0
    private var maxYComponentVelocity: Float = 10.0
    
    private var minXComponentVelocity: Float = -10.0
    private var minYComponentVelocity: Float = -10.0
    
    private var meanXComponentVelocity: Float = 0.00
    private var xComponentVelocityVariance: Float = 10.0
    private var meanYComponentVelocity: Float = 0.00
    private var yComponentVelocityVariance: Float = 10.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init?(scalingFactor: CGFloat = 1.0, startingHealth: Int = 2, xVelocity: CGFloat, yVelocity: CGFloat, applyImpulseInterval: TimeInterval) {
        
        
        
        //Nonconfigurable parameters
        
        guard let batTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .Bats)?.textureNamed("bat") else { return nil }
        
        let batSize = batTexture.size()
        
        self.init(texture: batTexture,color: SKColor.clear, size: batSize)
        
        performBasicConfiguration(circleRadius: batSize.width/2.0)
        configureActions()
        configureLighting()
        setPosition()
        
        //Configurable parameters
        self.applyImpulseInterval = applyImpulseInterval
        self.physicsBody?.velocity.dx = xVelocity
        self.physicsBody?.velocity.dy = yVelocity
        
        self.xScale *= scalingFactor
        self.yScale *= scalingFactor
        
        self.health = startingHealth
        
        
        self.run(SKAction.wait(forDuration: 1.0))


    }
    
    convenience init?(scalingFactor: CGFloat = 1.0, startingHealth: Int = 2, minXVelocity: Float = -10.0, maxXVelocity: Float = 10.0, minYVelocity: Float = -10.0, maxYVelocity: Float = 10.0) {
        
        
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
        
        self.minXComponentVelocity = minXVelocity
        self.minYComponentVelocity = minYVelocity
        
        self.maxXComponentVelocity = maxXVelocity
        self.maxYComponentVelocity = maxYVelocity
        
        self.health = startingHealth
        
        
        self.run(SKAction.wait(forDuration: 1.0))

    }
    
    convenience init?(meanXComponentVelocity: Float, xVariance: Float, meanYComponentVelocity: Float, yVariance: Float, scalingFactor: Int = 1, startingHealth: Int = 2) {
        
        
        //Nonconfigurable parameters
        
        guard let batTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .Bats)?.textureNamed("bat") else { return nil }
        
        let batSize = batTexture.size()
        
        self.init(texture: batTexture,color: SKColor.clear, size: batSize)
        
        performBasicConfiguration(circleRadius: batSize.width/2.0)
        configureActions()
        configureLighting()
        setPosition()
        
        
        //Configurable parameters
        
        self.meanXComponentVelocity = meanXComponentVelocity
        self.xComponentVelocityVariance = xVariance
        
        self.meanYComponentVelocity = meanYComponentVelocity
        self.yComponentVelocityVariance = yVariance
        
        self.health = startingHealth
        self.xScale *= CGFloat(scalingFactor)
        self.yScale *= CGFloat(scalingFactor)
        
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
        
        let randomPoint = randomPointGenerator.getRandomPointInRandomQuadrant()
        self.position = randomPoint
        
    }
    
    
    
    //MARK: GameLoop-Related Functions 
    
    func updatePhysicsWithARC4Random(){
        
        let randomVector = RandomVector(yComponentMin: Double(self.minYComponentVelocity), yComponentMax: Double(self.maxYComponentVelocity), xComponentMin: Double(self.minXComponentVelocity), xComponentMax: Double(self.maxXComponentVelocity))
        
        self.physicsBody?.applyImpulse(randomVector.getVector())
        
    }
    
    
    func updatePhysicsWithUniformRandom(){
        
        let randomVectorGenerator = RandomVectorUniform(algorithmType: .Faster)
        
        let randomVector = randomVectorGenerator.getRandomVectorBetween(xMinOf: Int(self.minXComponentVelocity)  , andXMaxOf: Int(self.maxXComponentVelocity), andBetweenYMinOf: Int(self.minYComponentVelocity), yMaxOf: Int(self.maxYComponentVelocity))
        
        self.physicsBody?.applyImpulse(randomVector)
        
    }
    
    
    func updatePhysicsWithGaussianRandom1(){
        
        let randomVectorGenerator = RandomVectorGaussian(algorithmType: .Faster)
        
        let randomVector = randomVectorGenerator.getRandomVectorWith(xMeanOf: self.meanXComponentVelocity, andXVarianceOf: self.xComponentVelocityVariance, andWithYMeanValueOf: self.meanYComponentVelocity, yVariance: self.yComponentVelocityVariance)
        
        self.physicsBody?.applyImpulse(randomVector)
        
    }
    
    func updatePhysicsWithGaussianRandom2(){
        
        let randomVectorGenerator = RandomVectorGaussian(algorithmType: .Faster)
        
        let randomVector = randomVectorGenerator.getRandomVectorBetween(xMinOf: Int(self.minXComponentVelocity), andXMaxOf: Int(self.maxXComponentVelocity), andBetweenYMinOf: Int(self.minYComponentVelocity), yMaxOf: Int(self.maxYComponentVelocity))
        
        self.physicsBody?.applyImpulse(randomVector)
        
        
    }
    
    func performVelocityCeilingAndFloorCheck(){
        
        if var currentVelocity = self.physicsBody?.velocity{
            let xComponent = Float(currentVelocity.dx)
            let yComponent = Float(currentVelocity.dy)
            
            if(xComponent < minXVelocityFloor){
                currentVelocity.dx = CGFloat(minXVelocityFloor)
            }
            
            if(xComponent > maxXVelocityCeiling){
                currentVelocity.dx = CGFloat(maxXVelocityCeiling)
            }
            
            if(yComponent < minYVelocityFloor){
                currentVelocity.dy = CGFloat(minYVelocityFloor)
            }
            
            if(yComponent > maxYVelocityCeiling){
                currentVelocity.dy = CGFloat(maxYVelocityCeiling)
            }
            
        }
    }
    
    
    func updateWithAppliedImpulse(){
            setPosition()
            updatePhysicsWithGaussianRandom2()
        
    }
    
    
    func updatePositionWithBoundaryCheck(){
        
        let positionConstraint1 = position.x < -ScreenSizeFloatConstants.HalfScreenWidth*0.8
        let positionConstraint2 = position.x > ScreenSizeFloatConstants.HalfScreenWidth*0.8
        let positionConstraint3 = position.y < -ScreenSizeFloatConstants.HalfScreenHeight*0.8
        let positionConstraint4 = position.y > ScreenSizeFloatConstants.HalfScreenHeight*0.8
      
        
        if(positionConstraint1 || positionConstraint2 || positionConstraint3 || positionConstraint4){
            setPosition()
        }
    }
    
    
    func getApplyImpulseInterval() -> TimeInterval{
        return self.applyImpulseInterval
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
