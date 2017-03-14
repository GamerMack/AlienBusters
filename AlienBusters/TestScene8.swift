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

class TestScene8: SKScene{
    
    
    //MARK: Explosion Animation
    var explosionAnimation = SKAction()
    var explosionSound = SKAction.playSoundFileNamed(SoundEffects.Explosion3, waitForCompletion: false)
    
    //MARK: Variables related to background objects
    lazy var backgroundObjects: [BackgroundObject] = [
        BackgroundObject(backgroundObjectType: .Sun),
        BackgroundObject(backgroundObjectType: .Cloud1),
        BackgroundObject(backgroundObjectType: .Cloud2),
        BackgroundObject(backgroundObjectType: .FullMoon),
        BackgroundObject(backgroundObjectType: .HalfMoon),
        BackgroundObject(backgroundObjectType: .Cloud3),
        BackgroundObject(backgroundObjectType: .Cloud5),
        BackgroundObject(backgroundObjectType: .Cloud6),
        BackgroundObject(backgroundObjectType: .Cloud4)
    
    ]
    
    var numberOfBackgroundObjects: Int = 3
    var backgroundObjectsPositions = [CGPoint]()
    
    
    //Wingman Array Variables
    var wingmanArray = [Wingman]()
    var currentWingmanIndex: Int = 0
    
    //Wingman Prototype
    var wingman: Wingman = {
        let randomScalingFactor = RandomFloatRange(min: 0.7, max: 1.4)
        let wingman = Wingman(scalingFactor: randomScalingFactor)!
        return wingman
        
        }()
    
    var currentNumberOfEnemies: Int = 0
    var maximumNumberOFEnemies: Int = 20
    var numberOfEnemiesKilled: Int = 0
    
    var initialNumberOfEnemiesSpawned: Int = 2
    var randomVectorConfigurationForUpdate: RandomVectorConfiguration = RandomVectorConfiguration(minimumVectorYComponent: -50.00, maximumVectorYComponent: 50.00, minimumVectorXComponent: -50.00, maximumVectorXComponent: 50.00)
    
    //Player Variables
    var player: CrossHair!
    var shootingSound = SKAction.playSoundFileNamed(SoundEffects.Laser3, waitForCompletion: false)
    
    //Timer Related Variables
    var frameCount: TimeInterval = 0.00
    var lastUpdateTime: TimeInterval = 0.00
    var spawnInterval: TimeInterval = 5.00
    var enemiesSpawnedPerInterval: Int = 2
    
    var hideIntervalFrameCount: TimeInterval = 0.00
    var hideInterval: TimeInterval = 8.00
    
    
    //Random Point Generator
    let randomPointGenerator = RandomPoint(algorithmType: .Faster)
    
    //HUD display
    var hud2 = HUD2()
    
    //MARK: ***************SCENE INITIALIZERS
    convenience init(size: CGSize, numberOfBackgroundObjects: Int, hideInterval: TimeInterval, spawnInterval: TimeInterval, initialNumberOfEnemiesSpawned: Int, enemiesSpawnedPerInterval: Int, randomVectorConfigurationForUpdate: RandomVectorConfiguration) {
    
        self.init(size: size)
        self.hideInterval = hideInterval
        self.spawnInterval = spawnInterval
        self.enemiesSpawnedPerInterval = enemiesSpawnedPerInterval
        self.initialNumberOfEnemiesSpawned = initialNumberOfEnemiesSpawned
        self.randomVectorConfigurationForUpdate = randomVectorConfigurationForUpdate
        self.numberOfBackgroundObjects = numberOfBackgroundObjects
    }
    
    override func didMove(to view: SKView) {
        
        
        //Set anchor point of current scene to center
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = SKColor.black
        
        
        //Configure particle emitter for background
        
        let emitterPath = Bundle.main.path(forResource: "StarryNight", ofType: "sks")!
        let emitterNode = NSKeyedUnarchiver.unarchiveObject(withFile: emitterPath) as! SKEmitterNode
        emitterNode.targetNode = emitterNode
        self.addChild(emitterNode)
        
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
        self.addChild(player)
        
        //Configure Background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: BackgroundMusic.MissionPlausible, forParentNode: self)
        
        //Populate WingmanArray
        spawnWingmanFromPrototype(numberOfWingman: self.initialNumberOfEnemiesSpawned)
        
        //Spawn Background Objects
        spawnBackgroundObjects(numberOfBackgroundObjects: self.numberOfBackgroundObjects, scaledByFactorOf: 0.40)
        
        
       
        
      
        
    }
    
 
    
    //MARK: *************** GAME LOOP FUNCTIONS
    
    override func didSimulatePhysics() {
        updateAllWingmanPhysics()
    }
    
    override func update(_ currentTime: TimeInterval) {
        frameCount += currentTime - lastUpdateTime
        hideIntervalFrameCount += currentTime - lastUpdateTime
        
        if(currentNumberOfEnemies > maximumNumberOFEnemies){
            self.isPaused = true
            hud2.showRestartButtons()
    
        }
        
        player.update()
        
        if(frameCount > spawnInterval){
            spawnWingmanFromPrototype(numberOfWingman: enemiesSpawnedPerInterval)
            frameCount = 0
        }
        
        
        if(hideIntervalFrameCount > hideInterval){
            hideAllWingman()
            hideIntervalFrameCount = 0
        }
        
        lastUpdateTime = currentTime
    }
    
    
    //Helper function for update method
    private func updateAllWingmanPhysics(){
        for node in self.children{
            if let node = node as? Wingman{
                node.updatePhysicsWith(randomVectorConfiguration: self.randomVectorConfigurationForUpdate)
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
        
       
        
        
        for node in nodes(at: touchLocation){
            if let node = node as? Wingman, player.contains(touchLocation){
               node.run(SKAction.sequence([
                explosionSound,
                explosionAnimation
                ]))
                
                currentNumberOfEnemies -= 1
                numberOfEnemiesKilled += 1
                
                hud2.setNumberOfEnemiesKilledTo(numberKilled: numberOfEnemiesKilled)
                hud2.setNumberOfEnemiesTo(numberOfEnemies: currentNumberOfEnemies)
                
            } else {
                player.run(shootingSound)
            }
        }
        
    }
    
    private func spawnBackgroundObjects(numberOfBackgroundObjects: Int, scaledByFactorOf scaleFactor: CGFloat){
        
        let numberOfObjects: Int = numberOfBackgroundObjects > (backgroundObjects.count-1) ? (backgroundObjects.count-1) : numberOfBackgroundObjects
        
        
        for index in 0..<numberOfObjects{
            
            let randomSpawnPoint = index % 2 == 0 ? randomPointGenerator.getUpperScreenPoint() : randomPointGenerator.getLowerScreenPoint()
            
            backgroundObjects[index].zPosition = -1
            backgroundObjects[index].position = randomSpawnPoint
            backgroundObjectsPositions.append(randomSpawnPoint)
            
            self.addChild(backgroundObjects[index])
        }
    }
    
    private func getPositionOfRandomBackgroundObject() -> CGPoint{
        
        let numberOfPositions: UInt32 = UInt32(backgroundObjectsPositions.count-1)
        
        let randomIndex = Int(arc4random_uniform(numberOfPositions))
        
        return backgroundObjectsPositions[randomIndex]
 
        
    }
    
    
 
    
    private func spawnWingman(){
        
        if(currentWingmanIndex < wingmanArray.count-1){
            
            let currentWingman = wingmanArray[currentWingmanIndex]
            let randomSpawnPoint = randomPointGenerator.getRandomPointInRandomQuadrant()
            currentWingman.position = randomSpawnPoint
            self.addChild(currentWingman)
            
            currentWingmanIndex += 1
            
        }
    }
    

    
    private func spawnWingmanFromPrototype(numberOfWingman: Int){
        
        for _ in 0..<numberOfWingman{
            let randomScaleFactor = RandomFloatRange(min: 0.4, max: 0.7)
            let wingmanCopy = self.wingman.copy() as! Wingman
            wingmanCopy.xScale *= randomScaleFactor
            wingmanCopy.yScale *= randomScaleFactor
            let randomSpawnPoint = randomPointGenerator.getRandomPointInRandomQuadrant()
            wingmanCopy.position = randomSpawnPoint
            wingmanCopy.name = "wingman"
            
            currentNumberOfEnemies += 1
            self.addChild(wingmanCopy)
            
        }
        
        hud2.setNumberOfEnemiesTo(numberOfEnemies: currentNumberOfEnemies)

    }
    
 
    
    private func hideAllWingman(){
        for node in self.children{
            if let node = node as? Wingman{
                node.run(SKAction.move(to: getPositionOfRandomBackgroundObject(), duration: 0.50))
                node.zPosition = -2
            }
        }
    }
    
    
    //Optional function for populating an array with wingman
    private func populateWingmanArrayWith(wingmanNumberOf wingmanNumber: Int){
        
        
        for index in 0..<wingmanNumber{
            let randomScalingFactor = RandomFloatRange(min: 0.5, max: 1.5)
            let newWingman = Wingman(scalingFactor: randomScalingFactor)!
            newWingman.name = "wingman\(index)"
            wingmanArray.append(newWingman)
        }
        
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
