//
//  BatController.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/8/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


class BatController: SKNode{
    
    private var batsArray = [Bat]()
    private var frameCount = 0.0
    private var lastUpdateTime = 0.0
    private var batSpawningInterval = 10.9
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init()
        setup()
    }
    

    private func setup(){
        batsArray = [
            Bat(scalingFactor: 0.3),
            Bat(scalingFactor: 0.6),
            Bat(scalingFactor: 1.0),
            Bat(scalingFactor: 2.0),
            Bat(scalingFactor: 4.0)
        ]
    }
    
    func spawnBats(numberOfBats: Int){
        
        for _ in 0...numberOfBats{
            
            let randomIndex = RandomIntegerBetween(min: 0, max: batsArray.count-1)
            
            let batClone = batsArray[randomIndex].copy() as! Bat
            
            self.addChild(batClone)
        }
        
    }
    
    func spawnRandomNumberOfBatsFrom(minimum: Int, toMaximum maximum: Int){
        let numberOfBats = RandomIntegerBetween(min: minimum, max: maximum)
        
        for _ in 0...numberOfBats{
            let randomIndex = RandomIntegerBetween(min: 0, max: batsArray.count-1)
            
            let batClone = batsArray[randomIndex].copy() as! Bat
            
            self.addChild(batClone)
        }
        
    }
    
    func update(currentTime: TimeInterval){
        
        frameCount += currentTime - lastUpdateTime
        
        if(frameCount > batSpawningInterval){
            spawnRandomNumberOfBatsFrom(minimum: 1, toMaximum: 5)
            frameCount = 0
        }
        
        for node in self.children{
            if let bat = node as? Bat{
                    let currentVelocity = bat.physicsBody?.velocity
                    let currentXVelocity = currentVelocity?.dx
                    let currentYVelocity = currentVelocity?.dy
                
                    if(currentYVelocity! < CGFloat(30) && currentXVelocity! < CGFloat(30.0)){
                    
                        var randomXImpulse = Int(arc4random_uniform(2))
                        var randomYImpulse = Int(arc4random_uniform(2))
                    
                        RandomizeSign(coordinateValue: &randomXImpulse)
                        RandomizeSign(coordinateValue: &randomYImpulse)
                    
                    
                    
                        let impulseVector = CGVector(dx: randomXImpulse, dy: randomYImpulse)
                        bat.physicsBody?.applyImpulse(impulseVector)
                }

            }
        }
        
        
        lastUpdateTime = currentTime
    }
    
    
    func checkForRepositioning(){
        for node in self.children{
            if let bat = node as? Bat{
                if(bat.position.x < -kViewWidth/1.8 || bat.position.x > kViewWidth/1.8){
                    bat.setPosition()
                }
                
                if(bat.position.y < -kViewHeight/1.8 || bat.position.y > kViewHeight/1.8){
                    bat.setPosition()
                }
            }
        }
    }
    
}
