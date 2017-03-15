//
//  BatLevel.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/15/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//



import Foundation
import SpriteKit
import GameplayKit

class BatScene: TestScene8{
    
    //MARK: ******************** BAT CONFIGURATION PARAMTERS
    var batController = BatController(batSpawningInterval: 4.00, minBatsSpawned: 0, maxBatsSpawned: 0)
    var minBatsSpawned: Int = 0
    var maxBatsSpawned: Int = 0
    var minBatComponentVelocity: Double = 0
    var maxBatComponentVelocity: Double = 0
    var maximumBatsAllowedToSpawn: Int = 0
    var minimumBatsKilledForLevelCompletion: Int = 0
    
    //MARK: ****************** CrossHair LightNode Configuration
    var lightNodeFallOff: CGFloat = 2.0
    
    
    //MARK: ******************** Start Button Configuration Parameters
    var levelDescription: String = ""
    
    
    //MARK: ***************SCENE INITIALIZERS
    convenience init(size: CGSize, levelNumber: Int, levelDescription: String, numberOfBackgroundObjects: Int, spawnInterval: TimeInterval, initialNumberOfEnemiesSpawned: Int, minBatsSpawned: Int, maxBatsSpawned: Int, minBatComponentVelocity: Double, maxBatComponentVelocity: Double,lightNodeFallOff: CGFloat, maximumBatsAllowedToSpawn: Int, minimumBatsKilledForLevelCompletion: Int) {
        
        self.init(size: size)
        self.levelNumber = levelNumber
        self.levelDescription = levelDescription
        self.numberOfBackgroundObjects = numberOfBackgroundObjects
        self.initialNumberOfEnemiesSpawned = initialNumberOfEnemiesSpawned
        self.spawnInterval = spawnInterval
        self.minBatsSpawned = minBatsSpawned
        self.maxBatsSpawned = maxBatsSpawned
        self.batController = BatController(batSpawningInterval: spawnInterval, minBatsSpawned: minBatsSpawned, maxBatsSpawned: maxBatsSpawned)
        self.maxBatComponentVelocity = maxBatComponentVelocity
        self.minBatComponentVelocity = minBatComponentVelocity
        self.lightNodeFallOff = lightNodeFallOff
        self.maximumBatsAllowedToSpawn = maximumBatsAllowedToSpawn
        self.minimumBatsKilledForLevelCompletion = minimumBatsKilledForLevelCompletion
        
    }
    
    
    override func didMove(to view: SKView) {
        
        
        //Set anchor point of current scene to center
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = SKColor.black
    
        
        //Configure SceneInterfaceManagerDelegate
        sceneInterfaceManagerDelegate = SceneInterfaceManager(newManagedScene: self)
        sceneInterfaceManagerDelegate.setupIntroMessageBox(levelTitle: "Level \(levelNumber)", levelDescription: self.levelDescription, enemyName: "Bat", spawningLimit: self.maximumBatsAllowedToSpawn)
        
        
        //Configure particle emitter for background
        let emitterPath = Bundle.main.path(forResource: "StarryNight", ofType: "sks")!
        let emitterNode = NSKeyedUnarchiver.unarchiveObject(withFile: emitterPath) as! SKEmitterNode
        emitterNode.particleColor = SKColor.orange
        emitterNode.targetNode = self
        emitterNode.move(toParent: self)
        
        
        //Configure explosion animation
        configureExplosionAnimation()
        
        //Configure initial HUD display
        currentNumberOfEnemies = 0
        numberOfEnemiesKilled = 0
        self.addChild(hud2)
        hud2.setNumberOfEnemiesKilledTo(numberKilled: numberOfEnemiesKilled)
        
        //Configure player
        player = CrossHair(crossHairType: .BlueLarge)
        player.zPosition = 15
        let lightNode = player.childNode(withName: NodeNames.CrossHairLight) as! SKLightNode
        lightNode.falloff = self.lightNodeFallOff
    
        self.addChild(player)
        
        //Configure Background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: BackgroundMusic.MissionPlausible, forParentNode: self)
        
        //Spawn inital number of bats
        self.addChild(batController)
        batController.spawnBats(numberOfBats: self.initialNumberOfEnemiesSpawned)
        let totalNumberOfBatsSpawned = batController.getTotalNumberOfBatsSpawned()
        hud2.setNumberOfEnemiesTo(numberOfEnemies: totalNumberOfBatsSpawned)
        
        //Spawn Background Objects
        spawnBackgroundObjects(numberOfBackgroundObjects: self.numberOfBackgroundObjects, scaledByFactorOf: 0.40)
        
        
        
        
        
        
    }

    
    
    //MARK: *************** GAME LOOP FUNCTIONS
    
    override func didSimulatePhysics() {
        batController.checkForRepositioning()
    }
    
    override func update(_ currentTime: TimeInterval) {
        frameCount += currentTime - lastUpdateTime
        hideIntervalFrameCount += currentTime - lastUpdateTime
        
        if(batController.getTotalNumberOfBatsSpawned() > maximumNumberOFEnemies){
            self.isPaused = true
            self.showRestartButtons()
            
        }
        
        player.update()
        batController.update(currentTime: currentTime)
        hud2.setNumberOfEnemiesTo(numberOfEnemies: batController.getTotalBatCount())
    
        
        lastUpdateTime = currentTime
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
            
            WingmanLevelLoader.loadLevel2From(currentScene: self, difficultyLevel: .Hard)
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
            
            if let node = node as? Bat, player.contains(touchLocation){
                node.run(SKAction.sequence([
                    explosionSound,
                    explosionAnimation
                    ]))
                
                numberOfEnemiesKilled += 1
                hud2.setNumberOfEnemiesKilledTo(numberKilled: numberOfEnemiesKilled)
                hud2.setNumberOfEnemiesTo(numberOfEnemies: batController.getTotalBatCount())
               
                
            } else {
                player.run(shootingSound)
            }
        }
        
    }
    
    

    private func getPositionOfRandomBackgroundObject() -> CGPoint{
        
        let randomDist = GKRandomDistribution(lowestValue: 0, highestValue: backgroundObjectsPositions.count-1)
        
        let randomIndex = randomDist.nextInt()
        
        return backgroundObjectsPositions[randomIndex]
        
        
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

