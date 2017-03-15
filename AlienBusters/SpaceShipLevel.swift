//
//  TestScene8.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class SpaceShipLevel: TestScene8{
    
    //MARK: Particle emitter for damaged ship
    //Configure particle emitter for background
    
    /**
    let fireEmitterNode: SKEmitterNode = {
        let emitterPath = Bundle.main.path(forResource: "Fire", ofType: "sks")!
        let emitterNode = NSKeyedUnarchiver.unarchiveObject(withFile: emitterPath) as! SKEmitterNode
        return emitterNode
    
    }()
    **/
    /**SpaceShip types
    Red Color: Red1,Red2,Red3
    Blue Color: Blue1,Blue2,Blue3
    Green Color: Green1,Green2,Green3
    Orange Color: Orange1,Orange2,Orange3
     **/
    
    //SpaceShip Prototype
    var spaceShips: [SpaceShip] = [
        SpaceShip(spaceShipTypeOf: .Red1, travelSpeedOf: 5.0, scalingFactor: 0.8)!,
        SpaceShip(spaceShipTypeOf: .Red2, travelSpeedOf: 5.0, scalingFactor: 0.8)!,
        SpaceShip(spaceShipTypeOf: .Red3, travelSpeedOf: 5.0, scalingFactor: 0.8)!,
        SpaceShip(spaceShipTypeOf: .Blue1, travelSpeedOf: 5.0, scalingFactor: 0.8)!,
        SpaceShip(spaceShipTypeOf: .Blue2, travelSpeedOf: 5.0, scalingFactor: 0.8)!,
        SpaceShip(spaceShipTypeOf: .Blue3, travelSpeedOf: 5.0, scalingFactor: 0.8)!,
    
    ]
    
    var currentSpaceShipIndex: Int = 0
    
    var randomSpaceShipIndex: Int {
        get{
            return GKRandomDistribution(lowestValue: 0, highestValue: backgroundObjectsPositions.count-1).nextInt()
        }
    }
    
    
    //Timer Related Variables
    var stealthInterval: TimeInterval = 10.00
    var stealthIntervalCounter: TimeInterval = 0.00
    

    //MARK: ***************SCENE INITIALIZERS
    convenience init(size: CGSize, levelNumber: Int, numberOfBackgroundObjects: Int, spawnInterval: TimeInterval, initialNumberOfEnemiesSpawned: Int, enemiesSpawnedPerInterval: Int) {
        
        self.init(size: size)
        self.levelNumber = levelNumber
        self.spawnInterval = spawnInterval
        self.enemiesSpawnedPerInterval = enemiesSpawnedPerInterval
        self.initialNumberOfEnemiesSpawned = initialNumberOfEnemiesSpawned
        self.numberOfBackgroundObjects = numberOfBackgroundObjects
    }
    
    override func didMove(to view: SKView) {
        
        
        //Set anchor point of current scene to center
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = SKColor.black
        
        //Configure SceneInterfaceManagerDelegate
        sceneInterfaceManagerDelegate = SceneInterfaceManager(newManagedScene: self)
        sceneInterfaceManagerDelegate.setupIntroMessageBox(levelTitle: "Level \(levelNumber)", levelDescription: "Stealth ships appear and disappear!", enemyName: "Stealth Fighters", spawningLimit: self.maximumNumberOFEnemies)
        
        
        //Configure particle emitter for background
        let emitterPath = Bundle.main.path(forResource: "StarryNight", ofType: "sks")!
        let emitterNode = NSKeyedUnarchiver.unarchiveObject(withFile: emitterPath) as! SKEmitterNode
        emitterNode.targetNode = self
        emitterNode.move(toParent: self)
        
        
        //Configure explosion animation
        configureExplosionAnimation()
        
        //Configure initial HUD display
        currentNumberOfEnemies = 0
        numberOfEnemiesKilled = 0
        self.addChild(hud2)
        hud2.setNumberOfEnemiesTo(numberOfEnemies: currentNumberOfEnemies)
        hud2.setNumberOfEnemiesKilledTo(numberKilled: numberOfEnemiesKilled)
        
        //Configure player
        player = CrossHair(crossHairType: .BlueLarge)
        player.zPosition = 10
        self.addChild(player)
        
        //Configure Background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: BackgroundMusic.MissionPlausible, forParentNode: self)
        
        //Spawn first spaceship
        spawnSpaceShipFromArray()
        
        //Spawn Background Objects
        spawnBackgroundObjects(numberOfBackgroundObjects: self.numberOfBackgroundObjects, scaledByFactorOf: 0.40)
        
        
        
        
    }
    
    
    
    //MARK: *************** GAME LOOP FUNCTIONS
    
    override func didSimulatePhysics() {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        frameCount += currentTime - lastUpdateTime
        stealthIntervalCounter += currentTime - lastUpdateTime
        
        player.update()

        
        if(currentNumberOfEnemies > maximumNumberOFEnemies){
            self.isPaused = true
            self.showRestartButtons()
            
        }
        
        if(stealthIntervalCounter > stealthInterval){
            //spawn the spaceships from an array
            spawnSpaceShipFromArray()
            stealthIntervalCounter = 0
        }
        
        updateAllSpaceShips(currentTime: currentTime)
        lastUpdateTime = currentTime
    }
    
    
    //Helper function for update method
    private func updateAllSpaceShips(currentTime: TimeInterval){
        for node in self.children{
            if let node = node as? SpaceShip{
                node.update(currentTime: currentTime)
            }
        }
    }
    
    
    
    //MARK: ******************* USER INPUT HANDLERS
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let node = touches.first! as UITouch
        let touchLocation = node.location(in: self)
        
        player.updateTargetPosition(position: touchLocation)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        

        
        if(restartButton.contains(touchLocation)){
            
            LevelLoader.loadLevel2From(currentScene: self, difficultyLevel: .Hard)
            //self.view?.presentScene(self, transition: transition)
        }
        
        
        if(menuButton.contains(touchLocation)){
            let transition = SKTransition.crossFade(withDuration: 2.0)
            self.view?.presentScene(MenuScene(size: self.size), transition: transition)
        }
        
        for node in nodes(at: touchLocation){
            
            if node.name == NodeNames.StartButton{
                node.removeFromParent()
            }
            
        }
        
        
        if player.contains(touchLocation){
            player.run(shootingSound)

            for node in nodes(at: touchLocation){
                
                if node.name == "SpaceShip"{
                    
                    guard let node = node as? SpaceShip else { return }
                    
                    print("The space ship's health is \(node.getHealth())")
                    
                    switch(node.getHealth()){
                    case 2:
                        print("The space ship took damage")
                        node.takeDamage1()

                        break
                    case 1:
                        print("The space ship took damage")
                        node.takeDamage2()
        
                        break
                    case 0:
                        print("The space ship died")
                    
                        node.run(SKAction.group([
                            explosionSound,
                            explosionAnimation
                            ]))
                        node.run(SKAction.sequence([
                            SKAction.wait(forDuration: 2.0),
                            SKAction.removeFromParent()
                            ]))
                        currentNumberOfEnemies -= 1
                        numberOfEnemiesKilled += 1
                        break
                    default:
                        print("The space ship died")
                    
                        node.run(SKAction.group([
                            explosionSound,
                            explosionAnimation
                            ]))
                        node.run(SKAction.sequence([
                            SKAction.wait(forDuration: 2.0),
                            SKAction.removeFromParent()
                            ]))
            
                        currentNumberOfEnemies -= 1
                        numberOfEnemiesKilled += 1
                        break
                    
                }
                    
                hud2.setNumberOfEnemiesKilledTo(numberKilled: numberOfEnemiesKilled)
                hud2.setNumberOfEnemiesTo(numberOfEnemies: currentNumberOfEnemies)
                    
            }
        }
        
            
        }
        
    }
    
    
    private func spawnSpaceShipFromArray(){
        
        if(currentSpaceShipIndex > spaceShips.count-1){
            currentSpaceShipIndex = 0
        }
        
        let spaceShip = spaceShips[currentSpaceShipIndex].copy() as! SpaceShip
        
        spaceShip.zPosition = player.zPosition-1
        spaceShip.name = "SpaceShip"
        spaceShip.userData?.setValue(2, forKey: "health")
        
        spaceShip.move(toParent: self)
        currentSpaceShipIndex += 1
        currentNumberOfEnemies += 1
        
        hud2.setNumberOfEnemiesTo(numberOfEnemies: currentNumberOfEnemies)

        
    }

    
    private func spawnEnemyFromRandomArrayIndex(){
        
        let spaceShip = spaceShips[randomSpaceShipIndex]
        
        spaceShip.name = "SpaceShip"
        
        spaceShip.userData?.setValue(2, forKey: "health")
        currentNumberOfEnemies += 1
        spaceShip.move(toParent: self)
        
        
        hud2.setNumberOfEnemiesTo(numberOfEnemies: currentNumberOfEnemies)
        
    }
    
    
 

    
    private func configureExplosionAnimation(){
        if let textureAtlas = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .RegularExplosion){
            
            self.explosionAnimation = SKAction.animate(with: [
                textureAtlas.textureNamed("regularExplosion00"),
                textureAtlas.textureNamed("regularExplosion01"),
                textureAtlas.textureNamed("regularExplosion02"),
                textureAtlas.textureNamed("regularExplosion03"),
                textureAtlas.textureNamed("regularExplosion04"),
                textureAtlas.textureNamed("regularExplosion05"),
                textureAtlas.textureNamed("regularExplosion06"),
                textureAtlas.textureNamed("regularExplosion07"),
                textureAtlas.textureNamed("regularExplosion08")
                ], timePerFrame: 0.25)
            
        }
    }
    
    
    
}




extension SpaceShipLevel{
    
    func processResponseForSpaceShipNode(_ spaceShipNode: SpaceShip){
        
        let isInStealthMode = spaceShipNode.userData?.value(forKey: "isInStealthMode") as! Bool
        
        let health = spaceShipNode.userData?.value(forKey: "health") as! Int
        
        if(isInStealthMode) { return }
        
    
            switch(health){
            case 2:
                let emitterNode = SmokeEmitterManager.sharedInstance.createSmokeEmitterFor(engineState: .NormalRunning)
                emitterNode.position = CGPoint(x: 0, y: -10)
                emitterNode.zPosition = 2
                spaceShipNode.addChild(emitterNode)
                spaceShipNode.userData?.setValue(1, forKey: "health")
                break
            case 1:
                self.removeAllChildren()
                let emitterNode = SmokeEmitterManager.sharedInstance.createSmokeEmitterFor(engineState: .Accelerated)
                emitterNode.position = CGPoint(x: 0, y: -10)
                emitterNode.zPosition = 2
                
                spaceShipNode.addChild(emitterNode)
                spaceShipNode.userData?.setValue(0, forKey: "health")
                break
            case 0:
                
                spaceShipNode.run(SKAction.sequence([
                            explosionSound,
                            explosionAnimation
                        ]))
                
                spaceShipNode.run(SKAction.sequence([
                    SKAction.wait(forDuration: 2.0),
                    SKAction.removeFromParent()
                    ]))
                break
            default:
                spaceShipNode.run(SKAction.sequence([
                    explosionSound,
                    explosionAnimation
                    ]))
                
                spaceShipNode.run(SKAction.sequence([
                    SKAction.wait(forDuration: 2.0),
                    SKAction.removeFromParent()
                    ]))
            }
        
    
    
    
}


}
