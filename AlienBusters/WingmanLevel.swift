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
    
    
    //MARK: Number for the Current Level
    var levelNumber: Int = 1
    
    //MARK: UI Buttons
    
    var menuButton = SKSpriteNode()
    var restartButton = SKSpriteNode()
    var sceneInterfaceManagerDelegate: SceneInterfaceManagerDelegate!
    
    
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
    
    
    //Enemy Prototype
    var enemy: Enemy = {
        let randomScalingFactor = RandomFloatRange(min: 0.7, max: 1.4)
        let wingman = Wingman(scalingFactor: randomScalingFactor)!
        return wingman
        
        }()
    
    var currentNumberOfEnemies: Int = 0
    var maximumNumberOFEnemies: Int = 10
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
    convenience init(size: CGSize, levelNumber: Int, numberOfBackgroundObjects: Int, hideInterval: TimeInterval, spawnInterval: TimeInterval, initialNumberOfEnemiesSpawned: Int, enemiesSpawnedPerInterval: Int, randomVectorConfigurationForUpdate: RandomVectorConfiguration) {
    
        self.init(size: size)
        self.levelNumber = levelNumber
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
        
        //Configure SceneInterfaceManagerDelegate
        sceneInterfaceManagerDelegate = SceneInterfaceManager(newManagedScene: self)
        sceneInterfaceManagerDelegate.setupIntroMessageBox(levelTitle: "Level \(levelNumber)", levelDescription: "Wingman likes to hide", enemyName: "Wingman", spawningLimit: self.maximumNumberOFEnemies)
        
        
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
        self.addChild(player)
        
        //Configure Background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: BackgroundMusic.MissionPlausible, forParentNode: self)
        
        //Populate WingmanArray
        spawnEnemyFromPrototype(numberOfEnemy: self.initialNumberOfEnemiesSpawned)
        
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
            self.showRestartButtons()
    
        }
        
        player.update()
        
        if(frameCount > spawnInterval){
            spawnEnemyFromPrototype(numberOfEnemy: enemiesSpawnedPerInterval)
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
        
        let randomDist = GKRandomDistribution(lowestValue: 0, highestValue: backgroundObjectsPositions.count-1)
        
        let randomIndex = randomDist.nextInt()
        
        return backgroundObjectsPositions[randomIndex]
 
        
    }
    
    
 

    
    private func spawnEnemyFromPrototype(numberOfEnemy: Int){
        
        for _ in 0..<numberOfEnemy{
            let randomScaleFactor = RandomFloatRange(min: 0.4, max: 0.7)
            
            let enemy = self.enemy as! Wingman
            let enemyCopy = enemy.copy() as! Wingman
            
            enemyCopy.xScale *= randomScaleFactor
            enemyCopy.yScale *= randomScaleFactor
            let randomSpawnPoint = randomPointGenerator.getRandomPointInRandomQuadrant()
            enemyCopy.position = randomSpawnPoint
            enemyCopy.name = "wingman"
            
            currentNumberOfEnemies += 1
            enemyCopy.move(toParent: self)
            
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


//MARK: *****************************SCENE EXTENSION

extension TestScene8{
    
    func setupMenuAndRestartButtons(){
        
        guard let menuButtonTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .HUD)?.textureNamed("button-menu") else { return }
        
        guard let restartButtonTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .HUD)?.textureNamed("button-restart") else { return }
        
        menuButton = SKSpriteNode(texture: menuButtonTexture)
        restartButton = SKSpriteNode(texture: restartButtonTexture)
        
            menuButton.name = NodeNames.ReturnToMenuButton
            restartButton.name = NodeNames.RestartGameButton
            
            menuButton.size = CGSize(width: kViewWidth*0.2, height: kViewHeight*0.3)
            restartButton.size = CGSize(width: kViewWidth*0.2, height: kViewHeight*0.3)
            
            menuButton.position = CGPoint(x: kViewWidth*0.5*0.2, y: 0)
            restartButton.position = CGPoint(x: menuButton.position.x - menuButton.size.width - 30, y: menuButton.position.y)
            
            let returnToMenuText = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
            returnToMenuText.text = "Main Menu"
            returnToMenuText.fontSize = 20.0
            returnToMenuText.fontColor = SKColor.white
            returnToMenuText.verticalAlignmentMode = .bottom
            returnToMenuText.position = CGPoint(x: 0, y: -menuButton.size.height)
            returnToMenuText.name = NodeNames.ReturnToMenuButton
            returnToMenuText.move(toParent: menuButton)
            
            let restartGameText = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
            restartGameText.text = "Restart Level"
            restartGameText.fontSize = 20.0
            restartGameText.fontColor = SKColor.white
            restartGameText.verticalAlignmentMode = .bottom
            restartGameText.position = CGPoint(x: 0, y: -restartButton.size.height)
            restartGameText.name = NodeNames.RestartGameButton
            restartGameText.move(toParent: restartButton)
            
            restartButton.zPosition = -15
            menuButton.zPosition = -15
            
            restartButton.alpha = 0
            menuButton.alpha = 0
            
        
            
        
        
    }
    
    func showRestartButtons(){
        //Set the button alpha to zero
        
            setupMenuAndRestartButtons()
            
            restartButton.alpha = 1
            menuButton.alpha = 1
        
            menuButton.move(toParent: self)
            restartButton.move(toParent: self)
            
            menuButton.zPosition = 15
            restartButton.zPosition = 15
            
            
            let fadeAnimation = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
            
            restartButton.run(fadeAnimation)
            menuButton.run(fadeAnimation)
    }
    
    
    

    
}

