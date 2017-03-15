//
//  BatController.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/8/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class BatController: SKNode{
    
    
    //MARK: ************  Timer-related variables
    private var frameCount = 0.0
    private var lastUpdateTime = 0.0
    private var batSpawningInterval = 10.0
    private var minimumBatsSpawnedPerInterval: Int = 0
    private var maximumBatsSpawnedPerInterval: Int = 1
    
    //MARK: ************ Variables related to bats array
    private var batsArray = [Bat]()
    private var batIndex: Int {
        get{
            return GKRandomDistribution(lowestValue: 0, highestValue: batsArray.count-1).nextInt()
        }
    }
    
    
    //MARK: ************* TOTAL NUMBER OF BATS SPAWNED
    private var totalNumberOfBatsSpawned: Int = 0
    
    
    //MARK: **************** BAT VELOCITY VARIABLES
    private var maxComponentVelocity: Double = 10
    private var minComponentVelocity: Double = 0
    
    //MARK: ************ INITIALIZERS
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init()
        setup()
    }
    
    
    convenience init(batSpawningInterval: TimeInterval = 10.00, minBatsSpawned: Int = 0,  maxBatsSpawned: Int = 1, minBatComponentVelocity: Double = 0, maxBatComponentVelocity: Double = 5) {
        
        self.init()
        setup()
        self.minimumBatsSpawnedPerInterval = minBatsSpawned
        self.maximumBatsSpawnedPerInterval = maxBatsSpawned
        self.batSpawningInterval = batSpawningInterval
        self.minComponentVelocity = minBatComponentVelocity
        self.maxComponentVelocity = maxBatComponentVelocity
        self.totalNumberOfBatsSpawned = 0
    }

    private func setup(){
        
        if let bat1 = Bat(scalingFactor: 0.3), let bat2 = Bat(scalingFactor: 0.6), let bat3 = Bat(scalingFactor: 1.0), let bat4 = Bat(scalingFactor: 2.0), let bat5 = Bat(scalingFactor: 4.0){
                batsArray = [ bat1, bat2, bat3, bat4, bat5 ]
            
        }
        
      
    }
    
   
    
    func update(currentTime: TimeInterval){
        
        frameCount += currentTime - lastUpdateTime
        
        if(frameCount > batSpawningInterval){
            spawnRandomNumberOfBatsFrom(minimum: self.minimumBatsSpawnedPerInterval, toMaximum: self.maximumBatsSpawnedPerInterval)
            frameCount = 0
        }
        
        for node in self.children{
            if let bat = node as? Bat{
            
                    var randomVector = RandomVector(yComponentMin: self.minComponentVelocity, yComponentMax: self.maxComponentVelocity, xComponentMin: self.minComponentVelocity, xComponentMax: self.maxComponentVelocity)
                        
                    randomVector.randomizeXComponentSign()
                    randomVector.randomizeYComponentSign()
                        
                    bat.physicsBody?.velocity = randomVector.getVector()
                
                
            }
        }
        
        
        lastUpdateTime = currentTime
    }
    
    //MARK: ************* Bat spawning functions
    
    func spawnBats(numberOfBats: Int){
        
        for _ in 0...numberOfBats{
            
            let batClone = batsArray[batIndex].copy() as! Bat
            let radius = batClone.size.width/2.0
            batClone.physicsBody = SKPhysicsBody(circleOfRadius: radius)
            batClone.physicsBody?.affectedByGravity = false
            batClone.physicsBody?.allowsRotation = false
            batClone.physicsBody?.linearDamping = 0.0
            self.addChild(batClone)
            totalNumberOfBatsSpawned += 1
        }
        
    }
    
    func spawnRandomNumberOfBatsFrom(minimum: Int, toMaximum maximum: Int){
        let numberOfBats = GKRandomDistribution(lowestValue: minimum, highestValue: maximum).nextInt()
        
        for _ in 0...numberOfBats{
            
            let batClone = batsArray[batIndex].copy() as! Bat
            let radius = batClone.size.width/2.0
            batClone.physicsBody = SKPhysicsBody(circleOfRadius: radius)
            batClone.physicsBody?.affectedByGravity = false
            batClone.physicsBody?.allowsRotation = false
            batClone.physicsBody?.linearDamping = 0.0
            self.addChild(batClone)
            
            totalNumberOfBatsSpawned += 1
        }
        
    }
    
    
    func checkForRepositioning(){
        for node in self.children{
            if let bat = node as? Bat{
                if(bat.position.x < -ScreenSizeFloatConstants.HalfScreenWidth*0.8 || bat.position.x > ScreenSizeFloatConstants.HalfScreenHeight*0.8){
                    bat.setPosition()
                }
                
                if(bat.position.y < -ScreenSizeFloatConstants.HalfScreenHeight*0.8 || bat.position.y > ScreenSizeFloatConstants.HalfScreenHeight*0.8){
                    bat.setPosition()
                }
            }
        }
    }
    
    func getTotalNumberOfBatsSpawned() -> Int{
        return totalNumberOfBatsSpawned
    }
    
    func reduceNumberOfBatsSpawnedBy(numberEliminated: Int){
        totalNumberOfBatsSpawned -= numberEliminated
    }
    
    func getTotalBatCount() -> Int{
        
        var numberOfBats = 0
        
        for node in self.children{
            if let node = node as? Bat{
                numberOfBats += 1
            }
        }
        
        return numberOfBats
    }
    
}
