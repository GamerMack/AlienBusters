//
//  TestScene6.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


class TestScene6: TimeLimitScene{
    
    let bat1 = Bat(xVelocity: 5.0, yVelocity: 5.0, applyImpulseInterval: 3.00)!

    
    override func didMove(to view: SKView) {
        //Configure background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: BackgroundMusic.CheerfulAnnoyance, forParentNode: self)
        
        //Add bats to the scene
        self.addChild(bat1)
        
    }
    
    //GameLoop Functions
    
    override func update(_ currentTime: TimeInterval) {
        frameCount = currentTime - lastUpdateTime
        
        if(frameCount > bat1.getApplyImpulseInterval()){
            bat1.updateWithAppliedImpulse()
            frameCount = 0.00
        }
        
        lastUpdateTime = currentTime
    }
    
    override func didSimulatePhysics() {
    }
    
    //User input handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
