//
//  FlyingAlienScene.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

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

class FlyingAlienScene: SKScene{
    
    
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
    var backgroundObjects: [BackgroundObject] = [
        BackgroundObject(backgroundObjectType: .Sun),
        BackgroundObject(backgroundObjectType: .Cloud1),
        BackgroundObject(backgroundObjectType: .Cloud2),
        BackgroundObject(backgroundObjectType: .Cloud3),
        BackgroundObject(backgroundObjectType: .Cloud4),
        BackgroundObject(backgroundObjectType: .FullMoon),
        BackgroundObject(backgroundObjectType: .HalfMoon),
        
        ]
    
    
    var numberOfBackgroundObjectsSpecified: Int = 7
    var backgroundObjectsPositions = [CGPoint]()
    
    
    //Enemy Prototype
    var flyingAlien: FlyingAlien!
    
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
    
    var fieldActionIntervalCounter: TimeInterval = 0.00
    var fieldActionInterval: TimeInterval = 8.00
    
    
    //Random Point Generator
    let randomPointGenerator = RandomPoint(algorithmType: .Faster)
    var randomDistFromBackgroundObjectsArray: GKRandomDistribution {
        
        get{
            return GKRandomDistribution(lowestValue: 0, highestValue: backgroundObjects.count-1)
        }
    }
    
    //HUD display
    var hud2 = HUD2()
    
    //MARK: ***************SCENE INITIALIZERS
    convenience init(size: CGSize, levelNumber: Int) {
        
        self.init(size: size)
        self.levelNumber = levelNumber
    
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
        
        //Configure barrier node
    
        
        let barrierNode = SKSpriteNode(texture: nil, color: .clear, size: self.size)
        barrierNode.zPosition = 2
        barrierNode.anchorPoint = CGPoint(x: 0, y: 0)
        barrierNode.position = CGPoint.zero
        
        let cgSize = CGSize(width: ScreenSizeFloatConstants.ScreenWidth*0.6, height: ScreenSizeFloatConstants.ScrrenHeight*0.6)
        let startingPoint = CGPoint(x: 0.00, y: 0.00)
        let cgRect = CGRect(origin: startingPoint, size: cgSize)
        barrierNode.physicsBody = SKPhysicsBody(edgeLoopFrom: cgRect)
        
        print(barrierNode.size)
        print(barrierNode.position)
        
        barrierNode.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        barrierNode.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
        barrierNode.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        
        self.addChild(barrierNode)
 
       
        
        //Add initial flying aliens
        flyingAlien = FlyingAlien(alienColor: .blue)
        let randomPoint = randomPointGenerator.getRandomPointInRandomQuadrant()
        flyingAlien.position = self.anchorPoint//randomPoint
        flyingAlien.physicsBody?.fieldBitMask = PhysicsCategory.Enemy
        flyingAlien.physicsBody?.mass = 5.00
        flyingAlien.physicsBody?.linearDamping = 0.00
        
        self.addChild(flyingAlien)
        
        //Spawn Background Objects
        spawnBackgroundObjects(numberOfBackgroundObjects: self.numberOfBackgroundObjectsSpecified, scaledByFactorOf: 0.40)
        
        
        
        
        
        
    }
    
    //MARK: ************** Helper Function that uses user dictionary to update physics and handle touch input for individual alien node
    
    private func updatePhysicsForFlyingAlien(){
        
        var randomVector: RandomVector
        
        guard let health = flyingAlien.userData?.value(forKey: "health") as? Int else { return}
        
        switch(health){
        case 2:
            randomVector = RandomVector(yComponentMin: -40, yComponentMax: 40, xComponentMin: -40, xComponentMax: 40)
            break
        case 1:
            randomVector = RandomVector(yComponentMin: -30, yComponentMax: 30, xComponentMin: -30, xComponentMax: 30)
            break
        case 0:
            randomVector = RandomVector(yComponentMin: -10, yComponentMax: 10, xComponentMin: -10, xComponentMax: 10)
            break
        default:
            randomVector = RandomVector(yComponentMin: -10, yComponentMax: 10, xComponentMin: -10, xComponentMax: 10)
            break
        }
        
        flyingAlien.physicsBody?.velocity = randomVector.getVector()

    }
    
    private func performResponseForFlyingAlien(){
        
        guard let health = flyingAlien.userData?.value(forKey: "health") as? Int else { return }
        
        switch(health){
        case 2:
            flyingAlien.run(SKAction.sequence([
                SKAction.rotate(byAngle: 90, duration: 0.50),
                SKAction.rotate(byAngle: 90, duration: 0.50),
                SKAction.rotate(byAngle: 90, duration: 0.50),
                SKAction.rotate(byAngle: 90, duration: 0.50)
                ]))
            flyingAlien.userData?.setValue(1, forKey: "health")
            break
        case 1:
            flyingAlien.run(SKAction.sequence([
                SKAction.rotate(byAngle: 90, duration: 0.50),
                SKAction.rotate(byAngle: 90, duration: 0.50),
                SKAction.rotate(byAngle: 90, duration: 0.50),
                SKAction.rotate(byAngle: 90, duration: 0.50)
                ]))
            flyingAlien.userData?.setValue(0, forKey: "health")
            break
        case 0:
            AnimationsFactory.createExplosionFor(spriteNode: flyingAlien)
            flyingAlien.run(SKAction.sequence([
                SKAction.wait(forDuration: 2.0),
                SKAction.removeFromParent()
                ]))
            break
        default:
            AnimationsFactory.createExplosionFor(spriteNode: flyingAlien)
            flyingAlien.run(SKAction.sequence([
                SKAction.wait(forDuration: 2.0),
                SKAction.removeFromParent()
                ]))
            
        }

    }
    
    //MARK: *************** GAME LOOP FUNCTIONS
    
    override func didSimulatePhysics() {
        flyingAlien.updatePhysics()
    }
    
    override func update(_ currentTime: TimeInterval) {
        frameCount += currentTime - lastUpdateTime
        fieldActionIntervalCounter += currentTime - lastUpdateTime
        
        if(fieldActionIntervalCounter > fieldActionInterval){
            disableGravityFields()
            
            fieldActionIntervalCounter = 0
        }
        
        if(currentNumberOfEnemies > maximumNumberOFEnemies){
            self.isPaused = true
            self.showRestartButtons()
            
        }
        
        player.update()
        flyingAlien.updateFlyingMode(currentTime: currentTime)
        
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
            
            
            let num = randomDistFromBackgroundObjectsArray.nextInt()
            
            if node.name == "backgroundObject\(num)"{
                for subNode in node.children{
                    if let subNode = subNode as? SKFieldNode{
                        subNode.isEnabled = true
                    }
                    
                    node.run(SKAction.repeatForever(SKAction.sequence([
                        SKAction.group([
                            SKAction.fadeAlpha(to: 0.4, duration: 1.0),
                            SKAction.scale(to: 0.4, duration: 1.0)
                            ]),
                        SKAction.group([
                            SKAction.fadeAlpha(to: 1.0, duration: 1.0),
                            SKAction.scale(to: 1.0, duration: 1.0)
                            ])
                        ])), withKey: "fieldAction")
                }
                
                
            }
            
            
            
            if flyingAlien.contains(touchLocation), player.contains(touchLocation){
                
                    flyingAlien.respondToHit()
                
            } else {
                player.run(shootingSound)
            }
        }
        
    }
    
    private func spawnBackgroundObjects(numberOfBackgroundObjects: Int, scaledByFactorOf scaleFactor: CGFloat){
        
        let numberOfObjects: Int = numberOfBackgroundObjects > (backgroundObjects.count-1) ? (backgroundObjects.count-1) : numberOfBackgroundObjects
        
        
        for index in 0..<numberOfObjects{
            
            let randomSpawnPoint = index % 2 == 0 ? randomPointGenerator.getUpperScreenPoint() : randomPointGenerator.getLowerScreenPoint()
            
            backgroundObjects[index].name = "backgroundObject\(index)"
            backgroundObjects[index].zPosition = -1
            backgroundObjects[index].position = randomSpawnPoint
            backgroundObjectsPositions.append(randomSpawnPoint)
            
            let gravityFieldNode = SKFieldNode.radialGravityField()
            gravityFieldNode.isEnabled = false
            gravityFieldNode.categoryBitMask = PhysicsCategory.Enemy
            gravityFieldNode.strength = 200.0
            gravityFieldNode.minimumRadius = 200.0
            backgroundObjects[index].addChild(gravityFieldNode)
            
            self.addChild(backgroundObjects[index])
        }
    }
    
    private func getPositionOfRandomBackgroundObject() -> CGPoint{
        
        let randomDist = GKRandomDistribution(lowestValue: 0, highestValue: backgroundObjectsPositions.count-1)
        
        let randomIndex = randomDist.nextInt()
        
        return backgroundObjectsPositions[randomIndex]
        
        
    }
    
    
    
    
    
    private func disableGravityFields(){
        for object in backgroundObjects{
            
            
            for node in object.children{
                if let node = node as? SKFieldNode{
                    if(node.isEnabled){
                        node.isEnabled = false
                        node.parent?.removeAction(forKey: "fieldAction")
                    }
                }
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

extension FlyingAlienScene{
    
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

