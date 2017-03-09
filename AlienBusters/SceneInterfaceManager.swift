//
//  SceneInterfaceManager.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/9/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


class SceneInterfaceManager: SceneInterfaceManagerDelegate{
    
    var managedScene: TimeLimitMode

    init(managedScene: TimeLimitMode){
        self.managedScene = managedScene
    }
    
    
    func setupIntroMessageBox(){
        if let introMessage = createIntroMessageWith(levelTitle: "Level 1", levelDescription: "Find all the bats and shoot them", levelTimeLimit: managedScene.timeLimit){
            
            
            managedScene.addChild(introMessage)
            
            introMessage.run(SKAction.sequence([
                SKAction.wait(forDuration: 4.0),
                SKAction.removeFromParent(),
                SKAction.run({
                    [weak managedScene] in
                    managedScene?.timerIsStarted = true
                })
                ]))
            
        }
    }
}
