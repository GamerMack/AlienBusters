//
//  GameViewController.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SoundLoader.preloadSounds()
        
      /**
        let menuScene = MenuScene(size: UIScreen.main.bounds.size)
        
        let randomVectorConfiguration = RandomVectorConfiguration(minimumVectorYComponent: -20, maximumVectorYComponent: 20, minimumVectorXComponent: -20, maximumVectorXComponent: 20)
        
        let testScene8 = TestScene8(size: UIScreen.main.bounds.size, levelNumber: 1, numberOfBackgroundObjects: 5, hideInterval: 10.0, spawnInterval: 4.00, initialNumberOfEnemiesSpawned: 1, enemiesSpawnedPerInterval: 2, randomVectorConfigurationForUpdate: randomVectorConfiguration)
        
        
        
 
        let flyingAlienScene = FlyingAlienScene(size: UIScreen.main.bounds.size, levelNumber: 1)
 
         **/
        
        let spaceShipLevel = SpaceShipLevel(size: self.view.bounds.size, levelNumber: 1, numberOfBackgroundObjects: 4, spawnInterval: 10.0, initialNumberOfEnemiesSpawned: 1, enemiesSpawnedPerInterval: 2, spaceShipTravelSpeed: 10.0, spaceShipTransitionInterval: 3.0)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
           
                // Set the scale mode to scale to fit the window
                spaceShipLevel.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(spaceShipLevel)
            
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
