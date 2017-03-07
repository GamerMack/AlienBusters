//
//  FlyingAliensController.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class FallingAliensController: SKNode{
    
    //Private class variables
    private var frameCount = 0.0
    private var fallingAliensArray = [SKSpriteNode]()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init()
        setup()
    }
    
    
    
    private func setup(){
        fallingAliensArray = [
            FallingAlien(alienColor: .pink)!,
            FallingAlien(alienColor: .blue)!,
            FallingAlien(alienColor: .green)!,
            FallingAlien(alienColor: .yellow)!
        ]
    }
    
    private func spawnAliens(){
        let randomCount = RandomIntegerBetween(min: 1, max: 3)
        
        for _ in 0...randomCount{
            let randomIndex = RandomIntegerBetween(min: 0, max: fallingAliensArray.count - 1)
            
            let halfHeight = kViewHeight/2
            let halfWidth = kViewWidth/2
            
            let offsetX: CGFloat = randomIndex % 2 == 0 ? -200:200
            let startX = RandomFloatRange(min: 0, max: offsetX)
            
            let offsetY: CGFloat = randomIndex % 2 == 0 ? 72:-72
            let startY = halfHeight*1.25 + offsetY
            
            let alien = self.fallingAliensArray[randomIndex].copy() as! FallingAlien
            alien.drift = RandomFloatRange(min: -0.5, max: 0.5)
            alien.position = CGPoint(x: startX, y: startY)
            
            self.addChild(alien)
        }
    }
    
    func update(delta: TimeInterval){
        frameCount += delta
        
        if frameCount >= 10{
            spawnAliens()
            
            frameCount = 0.0
        }
        
        for node in self.children{
            if let alien = node as? FlyingAlien{
                alien.update(currentTime: delta)
            }
        }
        
    }
    

}
