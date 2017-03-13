//
//  SpikemanScene1.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/13/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class SpikemanScene1: TimeLimitScene, SKPhysicsContactDelegate{
    
    private var spikeman: Spikeman!
    private var background: Background!
    private var player: CrossHair!
    private var animal: Animal!
    
    //Number of hits on enemy
    private var numberOfHits: Int = 0

    
    override func didMove(to view: SKView) {
        
        //Configure background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: BackgroundMusic.CheerfulAnnoyance, forParentNode: self)
        
        //Configure scene anchor point
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //Configure background
        background = Background(backgroundType: .ColoredForest)
        background!.zPosition = -2
        background!.scale(to: self.size)
        self.addChild(background!)
        
        //Configure physics body for scene
        
        let groundYPos = -ScreenSizeFloatConstants.HalfScreenHeight*0.85
        
        let leftEdgePoint = CGPoint(x: -ScreenSizeFloatConstants.HalfScreenWidth, y: groundYPos)
        
        let rightEdgePoint = CGPoint(x: ScreenSizeFloatConstants.HalfScreenWidth, y: groundYPos)
        
        self.physicsBody = SKPhysicsBody(edgeFrom: leftEdgePoint, to: rightEdgePoint)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -0.05)
        self.physicsWorld.contactDelegate = self
        self.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Animal
        
        //Configure RandomGenerator
        let minInitialXPosition = -Int(ScreenSizeFloatConstants.HalfScreenWidth*0.70)
        let maxInitialXPosition = Int(ScreenSizeFloatConstants.HalfScreenWidth*0.70)
        
        let randomSource = GKLinearCongruentialRandomSource()
        let randomDist = GKRandomDistribution(randomSource: randomSource, lowestValue: minInitialXPosition, highestValue: maxInitialXPosition)
        
        //Configure enemy
        spikeman = Spikeman(startingHealth: 2)
        spikeman.anchorPoint = CGPoint(x: 0.5, y: 0)
        spikeman.position = CGPoint(x: randomDist.nextInt(), y: -Int(ScreenSizeFloatConstants.HalfScreenHeight*0.85))
        self.addChild(spikeman)
        
        //Configure animal
        animal = Animal(animalType: .Giraffe)!
        animal.position = CGPoint(x: spikeman.position.x, y: 200)
        animal.xScale *= 0.2
        animal.yScale *= 0.2
        
        self.addChild(animal)
        
    }
    
    //Game Loop Functions
    override func update(_ currentTime: TimeInterval) {
        animal.position.x = spikeman.position.x
    }
    
    override func didSimulatePhysics() {
        if(!spikeman.isInDamagedState()){
            spikeman.updatePhysics()
        }
        
    }
    
    //User input handlers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        
        if(spikeman.contains(touchLocation)){
            spikeman.takeDamage()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    //Contact handler
    func didBegin(_ contact: SKPhysicsContact) {
        
        var otherBody: SKPhysicsBody
        let animalMask = PhysicsCategory.Animal
        
        //The other body is not the animal
        if(contact.bodyA.categoryBitMask & animalMask) > 0{
            otherBody = contact.bodyB
        }else{
            otherBody = contact.bodyA
        }
        
        switch(otherBody.categoryBitMask){
        case PhysicsCategory.Ground:
            animal.flyAway()
            print("The animal hit the ground")
            break
        case PhysicsCategory.Enemy:
            print("The animal hit the enemy")
            animal.die()
            break
        case PhysicsCategory.DamagedEnemy:
            animal.flyAway()
            print("The animal hit the damaged enemy")
        default:
            print("This contact has no game logic associated with it")
            break
        }
    }
}
