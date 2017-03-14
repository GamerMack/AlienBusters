//
//  SceneInterfaceManager.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/9/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


class SceneInterfaceManager: SKSpriteNode, SceneInterfaceManagerDelegate{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: nil, color: .clear, size: CGSize.zero)
    }
    
    
    //THis is not necessary, but is more readable semantically instead of having to call methods on the parent
    weak var managedScene: SKEffectNode?{
        get{
            return self.parent as! SKEffectNode?
        }
        
        set(newManagedScene){
            self.move(toParent: newManagedScene!)
        }
        
    }
    
    convenience init(newManagedScene: SKNode, instantiationMessage: String = "SceneInterfaceManager Instantiated") {
        
        if(kDebug){
            print(instantiationMessage)
        }
        
        self.init(texture: nil, color: .clear, size: CGSize.zero)
        //parentNode.addChild(self)
       // managedScene = parentNode as! SKEffectNode
        managedScene = newManagedScene as! SKEffectNode
    }
    
    
    
    func setupIntroMessageBox(levelTitle: String, levelDescription: String, enemyName: String, spawningLimit: Int){
        
        print("Inside the setupIntroMessageBox...")
        
        if let introMessage = ButtonFactory.createIntroMessageWith(levelTitle: levelTitle, levelDescription: levelDescription, enemyName: enemyName, spawningLimit: spawningLimit){
            
            print("About to add the introMessage to the scene...")
            // self.parent!.addChild(introMessage)
            
            if let managedScene = managedScene{
                managedScene.addChild(introMessage)
            }
            
        }
    }
 
    

    
    func setupIntroMessageBox(levelTitle: String, levelDescription: String, levelTimeLimit: Double){
        
        print("Inside the setupIntroMessageBox...")
        
        if let introMessage = ButtonFactory.createIntroMessageWith(levelTitle: levelTitle, levelDescription: levelDescription, levelTimeLimit: levelTimeLimit){
            
            print("About to add the introMessage to the scene...")
           // self.parent!.addChild(introMessage)
            
            if let managedScene = managedScene{
                managedScene.addChild(introMessage)
            }
            
        }
    }
    
   
}
