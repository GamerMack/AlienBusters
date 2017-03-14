//
//  UserInterfaceManager.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/10/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

/** This method doesn't work **/

class UserInterfaceManager{
    
    init(){
        
    }
    
    weak var managedScene: SKEffectNode? {
        get{
            return managedScene
        }
        
        set(newManagedScene){
            managedScene = newManagedScene
        }
    }
    
    func setupIntroMessageBox(levelTitle: String, levelDescription: String, levelTimeLimit: Double){
        
        print("Inside the setupIntroMessageBox...")
        
        if let introMessage = ButtonFactory.createIntroMessageWith(levelTitle: levelTitle, levelDescription: levelDescription, levelTimeLimit: levelTimeLimit){
            
            print("About to add the introMessage to the scene...")
            
            if let managedScene = managedScene{
                managedScene.addChild(introMessage)
            }
            
        }

    }

}
