//
//  TLScene3Delegate.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/11/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

/**SKSceneDelegates are used when you don't want to subclass SKScene
import Foundation
import SpriteKit

class TLScene3Delegate: NSObject, SKSceneDelegate{
    
    override init() {
        super.init()
    }
    

    func didFinishUpdate(for scene: SKScene) {
        if let tlscene3 = scene as? TLScene3{
            if(tlscene3.totalRunningTime > tlscene3.timeLimit){
                print("The time limit has been exceeded already!")
            }
        }
    }
    
    func didSimulatePhysics(for scene: SKScene) {
        
    }
    
    func didEvaluateActions(for scene: SKScene) {
        
    }
    
    override func didChangeValue(forKey key: String) {
    
    }
    
    func didApplyConstraints(for scene: SKScene) {
        
    }
    
}
 **/
