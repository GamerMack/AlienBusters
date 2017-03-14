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

class SpaceShipLevel: SKScene{
    
    
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
    
    /**SpaceShip types
    Red Color: Red1,Red2,Red3
    Blue Color: Blue1,Blue2,Blue3
    Green Color: Green1,Green2,Green3
    Orange Color: Orange1,Orange2,Orange3
     **/
    
    //SpaceShip Prototype
    var spaceShips: [SpaceShip] = [
        SpaceShip(spaceShipTypeOf: .Red1, travelSpeedOf: 20.0, scalingFactor: 0.8)!,
        SpaceShip(spaceShipTypeOf: .Red2, travelSpeedOf: 20.0, scalingFactor: 0.8)!,
        SpaceShip(spaceShipTypeOf: .Red3, travelSpeedOf: 20.0, scalingFactor: 0.8)!,
        SpaceShip(spaceShipTypeOf: .Blue1, travelSpeedOf: 20.0, scalingFactor: 0.8)!,
        SpaceShip(spaceShipTypeOf: .Blue2, travelSpeedOf: 20.0, scalingFactor: 0.8)!,
        SpaceShip(spaceShipTypeOf: .Blue3, travelSpeedOf: 20.0, scalingFactor: 0.8)!,
        SpaceShip(spaceShipTypeOf: .Orange1, travelSpeedOf: 20.0, scalingFactor: 0.8)!,
        SpaceShip(spaceShipTypeOf: .Orange2, travelSpeedOf: 20.0, scalingFactor: 0.8)!,
        SpaceShip(spaceShipTypeOf: .Orange3, travelSpeedOf: 20.0, scalingFactor: 0.8)!,
    
    ]
    
    var currentSpaceShipIndex: Int = 0
    
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
    var stealthInterval: TimeInterval = 4.00
    var stealthIntervalCounter: TimeInterval = 0.00
    
    //Random Point Generator
    let randomPointGenerator = RandomPoint(algorithmType: .Faster)
    
    //HUD display
    var hud2 = HUD2()
    
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
        
        if(currentNumberOfEnemies > maximumNumberOFEnemies){
            self.isPaused = true
            self.showRestartButtons()
            
        }
        
        player.update()
        
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
            
            if let node = node as? SpaceShip, player.contains(touchLocation){
                
                
                processResponseForSpaceShipNode(node)
                
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
    
    
    
    
    private func spawnSpaceShipFromArray(){
        
        if(currentSpaceShipIndex > spaceShips.count-1){
            currentSpaceShipIndex = 0
        }
        
        let spaceShip = spaceShips[currentSpaceShipIndex].copy() as! SpaceShip
        
        
        spaceShip.name = "SpaceShip"
        spaceShip.userData?.setValue(2, forKey: "health")
        spaceShip.userData?.setValue(false, forKey: "isInStealthMode")
        
        spaceShip.move(toParent: self)
        currentSpaceShipIndex += 1
        currentNumberOfEnemies += 1
        
        hud2.setNumberOfEnemiesTo(numberOfEnemies: currentNumberOfEnemies)

        
    }

    
    private func spawnEnemyFromRandomArrayIndex(){
        
        let randomDist = GKRandomDistribution(lowestValue: 0, highestValue: spaceShips.count-1)
        
        let spaceShip = spaceShips[randomDist.nextInt()] as! SpaceShip
        
        spaceShip.name = "SpaceShip"
        spaceShip.userData?.setValue(2, forKey: "health")
        spaceShip.userData?.setValue(false, forKey: "isInStealthMode")
            
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
