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
    
    let bat1 = Bat()
    let bat2 = Bat(scalingFactor: 2.0, startingHealth: 5, maxXVelocity: 10, maxYVelocity: 10)!
    let bat3 = Bat(scalingFactor: 3.0, startingHealth: 5, maxXVelocity: 50, maxYVelocity: 50)!
    
    override func didMove(to view: SKView) {
        //Configure background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: BackgroundMusic.CheerfulAnnoyance, forParentNode: self)
        
        //Add bats to the scene
        self.addChild(bat1)
        self.addChild(bat2)
        self.addChild(bat3)
        
    }
    
    //GameLoop Functions
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func didSimulatePhysics() {
        bat1.updatePhysics()
        bat2.updatePhysics()
        bat3.updatePhysics()
    }
    
    //User input handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
