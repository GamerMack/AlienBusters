//
//  TestScene8.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class TestScene8: SKScene{
    
    let backgroundObjects: [BackgroundObject] = [
        BackgroundObject(backgroundObjectType: .Sun),
        BackgroundObject(backgroundObjectType: .Cloud1),
        BackgroundObject(backgroundObjectType: .Cloud2),
        BackgroundObject(backgroundObjectType: .FullMoon),
        BackgroundObject(backgroundObjectType: .HalfMoon),
        BackgroundObject(backgroundObjectType: .Cloud3),
        BackgroundObject(backgroundObjectType: .Cloud5),
        BackgroundObject(backgroundObjectType: .Cloud6)
    
    ]
    
    var backgroundObjectsPositions = [CGPoint]()
    
    
    var wingmanArray = [Wingman]()
    var currentWingmanIndex: Int = 0
    
    //Timer Related Variables
    var frameCount: TimeInterval = 0.00
    var lastUpdateTime: TimeInterval = 0.00
    var spawnInterval: TimeInterval = 5.00
    
    var hideIntervalFrameCount: TimeInterval = 0.00
    var hideInterval: TimeInterval = 2.00
    
    let randomPointGenerator = RandomPoint(algorithmType: .Faster)
    
    override func didMove(to view: SKView) {
        //Set anchor point of current scene to center
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = SKColor.black
        
        //Configure Background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: BackgroundMusic.MissionPlausible, forParentNode: self)
        
        //Populate WingmanArray
        populateWingmanArrayWith(wingmanNumberOf: 10)
        
        //Spawn Background Objects
        spawnBackgroundObjects(scaledByFactorOf: 0.40)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func didSimulatePhysics() {
        updateAllWingmanPhysics()
    }
    
    override func update(_ currentTime: TimeInterval) {
        frameCount += currentTime - lastUpdateTime
        hideIntervalFrameCount += currentTime - lastUpdateTime
        
        if(frameCount > spawnInterval){
            spawnWingman()
            frameCount = 0
        }
        
        
        if(hideIntervalFrameCount > hideInterval){
            hideAllWingman()
            hideIntervalFrameCount = 0
        }
        
        lastUpdateTime = currentTime
    }
    
    private func spawnBackgroundObjects(scaledByFactorOf scaleFactor: CGFloat){
        
        for index in 0..<backgroundObjects.count-1{
            
            var randomSpawnPoint = index % 2 == 0 ? randomPointGenerator.getUpperScreenPoint() : randomPointGenerator.getLowerScreenPoint()
            
            backgroundObjects[index].zPosition = -1
            backgroundObjects[index].position = randomSpawnPoint
            backgroundObjectsPositions.append(randomSpawnPoint)
            
            self.addChild(backgroundObjects[index])
        }
    }
    
    private func getPositionOfRandomBackgroundObject() -> CGPoint{
        
        let numberOfPositions: UInt32 = UInt32(backgroundObjectsPositions.count-1)
        
        let randomIndex = Int(arc4random_uniform(numberOfPositions))
        
        return backgroundObjectsPositions[randomIndex]
 
        
    }
    
    private func populateWingmanArrayWith(wingmanNumberOf wingmanNumber: Int){
        
        for index in 0..<wingmanNumber{
            let randomScalingFactor = RandomFloatRange(min: 0.5, max: 1.5)
            let newWingman = Wingman(scalingFactor: randomScalingFactor)!
            newWingman.name = "wingman\(index)"
            wingmanArray.append(newWingman)
        }
    }
    
    private func spawnWingman(){
        
        if(currentWingmanIndex < wingmanArray.count-1){
            
            let currentWingman = wingmanArray[currentWingmanIndex]
            let randomSpawnPoint = randomPointGenerator.getRandomPointInRandomQuadrant()
            currentWingman.position = randomSpawnPoint
            self.addChild(currentWingman)
            
            currentWingmanIndex += 1
            
        }
    }
    
    private func updateAllWingmanPhysics(){
        for node in self.children{
            if let node = node as? Wingman{
                node.updatePhysics()
            }
        }
    }
    
    private func hideAllWingman(){
        for node in self.children{
            if let node = node as? Wingman{
                node.run(SKAction.move(to: getPositionOfRandomBackgroundObject(), duration: 0.50))
                node.zPosition = -2
            }
        }
    }
    
}
