//
//  BatSceneLevelLoader.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/15/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


class BatSceneLevelLoader{
    
    enum DifficultyLevel{
        case Hard
        case Medium
        case Easy
    }
    
    static let mainTransition = SKTransition.crossFade(withDuration: 2.0)
    
    
    static func loadLevel5From(currentScene: SKScene, difficultyLevel: DifficultyLevel){
        
   
        var nextScene: SKScene
        
        switch(difficultyLevel){
        case .Hard:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 5, numberOfBackgroundObjects: 2, levelDescription: "The bats make their last stand!", enemySpawnInterval: 6.0, initialNumberOfEnemies: 3, minBatsSpawned: 2, maxBatsSpawned: 6, minBatComponentVelocity: 40, maxBatComponentVelocity: 80  , lightNodeFalloff: 1, maximumBatsAllowedToSpawn: 10, minimumBatsKilledForLevelCompleition: 20)
            break
        case .Medium:
             nextScene = loadSceneFrom(currentScene, withLevelNumber: 5, numberOfBackgroundObjects: 2, levelDescription: "The bats make their last stand!", enemySpawnInterval: 6.0, initialNumberOfEnemies: 3, minBatsSpawned: 2, maxBatsSpawned: 6, minBatComponentVelocity: 40, maxBatComponentVelocity: 80  , lightNodeFalloff: 1, maximumBatsAllowedToSpawn: 10, minimumBatsKilledForLevelCompleition: 20)
            break
        case .Easy:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 5, numberOfBackgroundObjects: 2, levelDescription: "The bats make their last stand!", enemySpawnInterval: 7.0, initialNumberOfEnemies: 3, minBatsSpawned: 2, maxBatsSpawned: 5, minBatComponentVelocity: 40, maxBatComponentVelocity: 80  , lightNodeFalloff: 1, maximumBatsAllowedToSpawn: 20, minimumBatsKilledForLevelCompleition: 15)
            break
        }
        
        
        currentScene.view?.presentScene(nextScene, transition: mainTransition)
    }
    
    
    static func loadLevel4From(currentScene: SKScene, difficultyLevel: DifficultyLevel){
        
     
        var nextScene: SKScene
        
        switch(difficultyLevel){
        case .Hard:
             nextScene = loadSceneFrom(currentScene, withLevelNumber: 4, numberOfBackgroundObjects: 3, levelDescription: "The bats are spawning faster!", enemySpawnInterval: 7.0, initialNumberOfEnemies: 3, minBatsSpawned: 2, maxBatsSpawned: 5, minBatComponentVelocity: 30, maxBatComponentVelocity: 60  , lightNodeFalloff: 1, maximumBatsAllowedToSpawn: 15, minimumBatsKilledForLevelCompleition: 30)
            break
        case .Medium:
             nextScene = loadSceneFrom(currentScene, withLevelNumber: 4, numberOfBackgroundObjects: 3, levelDescription: "The bats are spawning faster!", enemySpawnInterval: 7.0, initialNumberOfEnemies: 3, minBatsSpawned: 2, maxBatsSpawned: 5, minBatComponentVelocity: 30, maxBatComponentVelocity: 60  , lightNodeFalloff: 1, maximumBatsAllowedToSpawn: 20, minimumBatsKilledForLevelCompleition: 30)
            break
        case .Easy:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 4, numberOfBackgroundObjects: 3, levelDescription: "The bats are spawning faster!", enemySpawnInterval: 8.0, initialNumberOfEnemies: 3, minBatsSpawned: 1, maxBatsSpawned: 3, minBatComponentVelocity: 30, maxBatComponentVelocity: 60  , lightNodeFalloff: 1, maximumBatsAllowedToSpawn: 20, minimumBatsKilledForLevelCompleition: 20)
            break
        }
        
        
        currentScene.view?.presentScene(nextScene, transition: mainTransition)
    }
    
    
    static func loadLevel3From(currentScene: SKScene, difficultyLevel: DifficultyLevel){
        
     
        
        var nextScene: SKScene
        
        switch(difficultyLevel){
        case .Hard:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 3, numberOfBackgroundObjects: 3, levelDescription: "The bats are getting faster!", enemySpawnInterval: 15.0, initialNumberOfEnemies: 3, minBatsSpawned: 1, maxBatsSpawned: 3, minBatComponentVelocity: 30, maxBatComponentVelocity: 60  , lightNodeFalloff: 1, maximumBatsAllowedToSpawn: 40, minimumBatsKilledForLevelCompleition: 20)
            break
        case .Medium:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 3, numberOfBackgroundObjects: 3, levelDescription: "The bats are getting faster!", enemySpawnInterval: 15.0, initialNumberOfEnemies: 3, minBatsSpawned: 1, maxBatsSpawned: 3, minBatComponentVelocity: 20, maxBatComponentVelocity: 50  , lightNodeFalloff: 1, maximumBatsAllowedToSpawn: 40, minimumBatsKilledForLevelCompleition: 20)
            break
        case .Easy:
             nextScene = loadSceneFrom(currentScene, withLevelNumber: 3, numberOfBackgroundObjects: 3, levelDescription: "The bats are getting faster!", enemySpawnInterval: 15.0, initialNumberOfEnemies: 3, minBatsSpawned: 1, maxBatsSpawned: 2, minBatComponentVelocity: 10, maxBatComponentVelocity: 50  , lightNodeFalloff: 1, maximumBatsAllowedToSpawn: 40, minimumBatsKilledForLevelCompleition: 20)
            break
        }
        
        
        currentScene.view?.presentScene(nextScene, transition: mainTransition)
    }
    
    
    static func loadLevel2From(currentScene: SKScene, difficultyLevel: DifficultyLevel){
        
     
        
        var nextScene: SKScene
        
        switch(difficultyLevel){
        case .Hard:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 2, numberOfBackgroundObjects: 4, levelDescription: "It just got a little darker!", enemySpawnInterval: 15.0, initialNumberOfEnemies: 3, minBatsSpawned: 1, maxBatsSpawned: 2, minBatComponentVelocity: 0, maxBatComponentVelocity: 30  , lightNodeFalloff: 1, maximumBatsAllowedToSpawn: 40, minimumBatsKilledForLevelCompleition: 20)
            break
        case .Medium:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 2, numberOfBackgroundObjects: 4, levelDescription: "It just got a little darker!", enemySpawnInterval: 15.0, initialNumberOfEnemies: 3, minBatsSpawned: 1, maxBatsSpawned: 2, minBatComponentVelocity: 0, maxBatComponentVelocity: 30  , lightNodeFalloff: 1, maximumBatsAllowedToSpawn: 40, minimumBatsKilledForLevelCompleition: 20)
            break
        case .Easy:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 2, numberOfBackgroundObjects: 4, levelDescription: "It just got a little darker!", enemySpawnInterval: 15.0, initialNumberOfEnemies: 3, minBatsSpawned: 1, maxBatsSpawned: 2, minBatComponentVelocity: 0, maxBatComponentVelocity: 30  , lightNodeFalloff: 2, maximumBatsAllowedToSpawn: 40, minimumBatsKilledForLevelCompleition: 15)
            break
        }
        
        currentScene.view?.presentScene(nextScene, transition: mainTransition)

    }
    
        
    static func loadLevel1From(currentScene: SKScene, difficultyLevel: DifficultyLevel){
            
        
            var nextScene: SKScene
            
            switch(difficultyLevel){
            case .Hard:
                nextScene = loadSceneFrom(currentScene, withLevelNumber: 1, numberOfBackgroundObjects: 5, levelDescription: "Can you shoot the hidden bats?", enemySpawnInterval: 13.0, initialNumberOfEnemies: 3, minBatsSpawned: 0, maxBatsSpawned: 1, minBatComponentVelocity: 0, maxBatComponentVelocity: 20, lightNodeFalloff: 3, maximumBatsAllowedToSpawn: 40, minimumBatsKilledForLevelCompleition: 10)
                break
            case .Medium:
                nextScene = loadSceneFrom(currentScene, withLevelNumber: 1, numberOfBackgroundObjects: 5, levelDescription: "Can you shoot the hidden bats?", enemySpawnInterval: 14.0, initialNumberOfEnemies: 1, minBatsSpawned: 0, maxBatsSpawned: 1, minBatComponentVelocity: 0, maxBatComponentVelocity: 20, lightNodeFalloff: 3, maximumBatsAllowedToSpawn: 40, minimumBatsKilledForLevelCompleition: 10)
                break
            case .Easy:
                nextScene = loadSceneFrom(currentScene, withLevelNumber: 1, numberOfBackgroundObjects: 5, levelDescription: "Can you shoot the hidden bats?", enemySpawnInterval: 15.0, initialNumberOfEnemies: 1, minBatsSpawned: 0, maxBatsSpawned: 1, minBatComponentVelocity: 0, maxBatComponentVelocity: 20, lightNodeFalloff: 3, maximumBatsAllowedToSpawn: 40, minimumBatsKilledForLevelCompleition: 10)
                break
            }

        
        
        
        currentScene.view?.presentScene(nextScene, transition: mainTransition)
    }
    
    static func getLevel1Scene(size: CGSize, difficultyLevel: DifficultyLevel) -> SKScene{
        
        
        switch(difficultyLevel){
        case .Hard:
            return BatScene(size: size, levelNumber: 1, levelDescription: "Can you shoot the hidden bats?", numberOfBackgroundObjects: 5, spawnInterval: 13, initialNumberOfEnemiesSpawned: 2, minBatsSpawned: 0, maxBatsSpawned: 1, minBatComponentVelocity: 0, maxBatComponentVelocity: 20, lightNodeFallOff: 3, maximumBatsAllowedToSpawn: 40, minimumBatsKilledForLevelCompletion: 10)
            
        case .Medium:
            return BatScene(size: size, levelNumber: 1, levelDescription: "Can you shoot the hidden bats?", numberOfBackgroundObjects: 5, spawnInterval: 14, initialNumberOfEnemiesSpawned: 1, minBatsSpawned: 0, maxBatsSpawned: 1, minBatComponentVelocity: 0, maxBatComponentVelocity: 20, lightNodeFallOff: 3, maximumBatsAllowedToSpawn: 40, minimumBatsKilledForLevelCompletion: 10)
            
        case .Easy:
            return BatScene(size: size, levelNumber: 1, levelDescription: "Can you shoot the hidden bats?", numberOfBackgroundObjects: 5, spawnInterval: 15, initialNumberOfEnemiesSpawned: 1, minBatsSpawned: 0, maxBatsSpawned: 1, minBatComponentVelocity: 0, maxBatComponentVelocity: 20, lightNodeFallOff: 3, maximumBatsAllowedToSpawn: 40, minimumBatsKilledForLevelCompletion: 10)
            
        }
        
        
    }
    
    
    static private func loadSceneFrom(_ currentScene: SKScene, withLevelNumber levelNumber: Int, numberOfBackgroundObjects: Int, levelDescription: String, enemySpawnInterval: TimeInterval, initialNumberOfEnemies: Int, minBatsSpawned: Int, maxBatsSpawned: Int, minBatComponentVelocity: Double, maxBatComponentVelocity: Double, lightNodeFalloff: CGFloat, maximumBatsAllowedToSpawn: Int, minimumBatsKilledForLevelCompleition: Int) -> SKScene{
        
        
        let scene = BatScene(size: currentScene.size, levelNumber: levelNumber, levelDescription: levelDescription, numberOfBackgroundObjects: numberOfBackgroundObjects, spawnInterval: enemySpawnInterval, initialNumberOfEnemiesSpawned: initialNumberOfEnemies, minBatsSpawned: minBatsSpawned, maxBatsSpawned: maxBatsSpawned, minBatComponentVelocity: minBatComponentVelocity, maxBatComponentVelocity: maxBatComponentVelocity, lightNodeFallOff: lightNodeFalloff, maximumBatsAllowedToSpawn: maximumBatsAllowedToSpawn, minimumBatsKilledForLevelCompletion: minimumBatsKilledForLevelCompleition)
        
        return scene
    }
    
    
    
}
