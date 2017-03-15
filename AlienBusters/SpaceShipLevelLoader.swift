//
//  SpaceShipLevelLoader.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/15/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class SpaceShipLevelLoader{
    
    enum DifficultyLevel{
        case Hard
        case Medium
        case Easy
    }
    
    static let mainTransition = SKTransition.crossFade(withDuration: 2.0)
    
    
    static func loadLevel5From(currentScene: SKScene, difficultyLevel: DifficultyLevel){
        
        let randomVectorConfiguration = RandomVectorConfiguration(minimumVectorYComponent: -50, maximumVectorYComponent: 50, minimumVectorXComponent: -50, maximumVectorXComponent: 50)
        
        var nextScene: SKScene
        
        switch(difficultyLevel){
        case .Hard:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 2, numberOfBackgroundObjects: 3, enemyHideInterval: 6, enemySpawnInterval: 6, initialNumberOfEnemies: 2, perIntervalSpawningRate: 2, randomVectorConfigurationForEnemyUpdate: randomVectorConfiguration)
            break
        case .Medium:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 2, numberOfBackgroundObjects: 3, enemyHideInterval: 6, enemySpawnInterval: 6, initialNumberOfEnemies: 2, perIntervalSpawningRate: 2, randomVectorConfigurationForEnemyUpdate: randomVectorConfiguration)
            break
        case .Easy:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 2, numberOfBackgroundObjects: 3, enemyHideInterval: 6, enemySpawnInterval: 6, initialNumberOfEnemies: 2, perIntervalSpawningRate: 2, randomVectorConfigurationForEnemyUpdate: randomVectorConfiguration)
            break
        }
        
        
        currentScene.view?.presentScene(nextScene, transition: mainTransition)
    }
    
    
    static func loadLevel4From(currentScene: SKScene, difficultyLevel: DifficultyLevel){
        
        let randomVectorConfiguration = RandomVectorConfiguration(minimumVectorYComponent: -40, maximumVectorYComponent: 40, minimumVectorXComponent: -40, maximumVectorXComponent: 40)
        
        var nextScene: SKScene
        
        switch(difficultyLevel){
        case .Hard:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 2, numberOfBackgroundObjects: 3, enemyHideInterval: 6, enemySpawnInterval: 6, initialNumberOfEnemies: 2, perIntervalSpawningRate: 2, randomVectorConfigurationForEnemyUpdate: randomVectorConfiguration)
            break
        case .Medium:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 2, numberOfBackgroundObjects: 3, enemyHideInterval: 6, enemySpawnInterval: 6, initialNumberOfEnemies: 2, perIntervalSpawningRate: 2, randomVectorConfigurationForEnemyUpdate: randomVectorConfiguration)
            break
        case .Easy:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 2, numberOfBackgroundObjects: 3, enemyHideInterval: 6, enemySpawnInterval: 6, initialNumberOfEnemies: 2, perIntervalSpawningRate: 2, randomVectorConfigurationForEnemyUpdate: randomVectorConfiguration)
            break
        }
        
        
        currentScene.view?.presentScene(nextScene, transition: mainTransition)
    }
    
    
    static func loadLevel3From(currentScene: SKScene, difficultyLevel: DifficultyLevel){
        
        let randomVectorConfiguration = RandomVectorConfiguration(minimumVectorYComponent: -30, maximumVectorYComponent: 30, minimumVectorXComponent: -30, maximumVectorXComponent: 30)
        
        var nextScene: SKScene
        
        switch(difficultyLevel){
        case .Hard:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 2, numberOfBackgroundObjects: 3, enemyHideInterval: 6, enemySpawnInterval: 6, initialNumberOfEnemies: 2, perIntervalSpawningRate: 2, randomVectorConfigurationForEnemyUpdate: randomVectorConfiguration)
            break
        case .Medium:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 2, numberOfBackgroundObjects: 3, enemyHideInterval: 6, enemySpawnInterval: 6, initialNumberOfEnemies: 2, perIntervalSpawningRate: 2, randomVectorConfigurationForEnemyUpdate: randomVectorConfiguration)
            break
        case .Easy:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 2, numberOfBackgroundObjects: 3, enemyHideInterval: 6, enemySpawnInterval: 6, initialNumberOfEnemies: 2, perIntervalSpawningRate: 2, randomVectorConfigurationForEnemyUpdate: randomVectorConfiguration)
            break
        }
        
        
        currentScene.view?.presentScene(nextScene, transition: mainTransition)
    }
    
    
    static func loadLevel2From(currentScene: SKScene, difficultyLevel: DifficultyLevel){
        
        let randomVectorConfiguration = RandomVectorConfiguration(minimumVectorYComponent: -20, maximumVectorYComponent: 20, minimumVectorXComponent: -20, maximumVectorXComponent: 20)
        
        var nextScene: SKScene
        
        switch(difficultyLevel){
        case .Hard:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 2, numberOfBackgroundObjects: 3, enemyHideInterval: 6, enemySpawnInterval: 6, initialNumberOfEnemies: 2, perIntervalSpawningRate: 2, randomVectorConfigurationForEnemyUpdate: randomVectorConfiguration)
            break
        case .Medium:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 2, numberOfBackgroundObjects: 3, enemyHideInterval: 6, enemySpawnInterval: 6, initialNumberOfEnemies: 2, perIntervalSpawningRate: 2, randomVectorConfigurationForEnemyUpdate: randomVectorConfiguration)
            break
        case .Easy:
            nextScene = loadSceneFrom(currentScene, withLevelNumber: 2, numberOfBackgroundObjects: 3, enemyHideInterval: 6, enemySpawnInterval: 6, initialNumberOfEnemies: 2, perIntervalSpawningRate: 2, randomVectorConfigurationForEnemyUpdate: randomVectorConfiguration)
            break
        }
        
        
        
        currentScene.view?.presentScene(nextScene, transition: mainTransition)
    }
    
    
    static private func loadSceneFrom(_ currentScene: SKScene, withLevelNumber levelNumber: Int, numberOfBackgroundObjects: Int, enemyHideInterval: TimeInterval, enemySpawnInterval: TimeInterval, initialNumberOfEnemies: Int, perIntervalSpawningRate: Int, randomVectorConfigurationForEnemyUpdate: RandomVectorConfiguration) -> SKScene{
        
        
        let scene = TestScene8(size: currentScene.size, levelNumber: levelNumber, numberOfBackgroundObjects: numberOfBackgroundObjects, hideInterval: enemyHideInterval, spawnInterval: enemySpawnInterval, initialNumberOfEnemiesSpawned: initialNumberOfEnemies, enemiesSpawnedPerInterval: perIntervalSpawningRate, randomVectorConfigurationForUpdate: randomVectorConfigurationForEnemyUpdate)
        
        return scene
    }
    
    
    
}
