//
//  UFO.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/15/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


class UFO: SKSpriteNode{
    
    enum UFOType{
        case Red
        case Blue
        case Green
        case Yellow
    }
    
    
    var inFieldEmittingMode: Bool = false {
        didSet{
            if let gravityNode = self.childNode(withName: NodeNames.UFOFieldNode) as? SKFieldNode{
                gravityNode.isEnabled = inFieldEmittingMode ? true : false
            }
            
            if(inFieldEmittingMode){
                self.run(emittingAnimation, withKey: "emittingAnimation")
            }else{
                self.removeAction(forKey: "emittingAnimation")
            }
        }
    }
    
    lazy var gravityField: SKFieldNode = {
        let gravityNode = SKFieldNode.noiseField(withSmoothness: 2.00, animationSpeed: 2.00)
        gravityNode.isEnabled = false
        gravityNode.name = NodeNames.UFOFieldNode
        return gravityNode
    
    }()
    
   
    //MARK: Actions
    var emittingAnimation = SKAction()
    var pathAction = SKAction()
    var damageAction = SKAction()
    var shapeOverlay = SKShapeNode()
    
    //MARK: RandomPoint Generator
    let randomPointGenerator = RandomPoint(algorithmType: .Faster)
    
    //MARK: Timing-Related Variables
    var frameCount: TimeInterval = 0.00
    var emittingInterval: TimeInterval = 5.00
    var lastUpdateTime: TimeInterval = 0.00
    
    //MARK: Variables related to health
    var health: Int = 1
    
    //MARK: *********** INITIALIZERS
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init?(ufoType: UFOType) {
        
        guard let textureAtlas = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .UFO) else { return nil }
        
        var texture: SKTexture
        
        switch(ufoType){
        case .Red:
            texture = textureAtlas.textureNamed("elephant")
            break
        case .Green:
            texture = textureAtlas.textureNamed("giraffe")
            break
        case .Yellow:
            texture = textureAtlas.textureNamed("monkey")
            break
        case .Blue:
            texture = textureAtlas.textureNamed("penguin")
            break
        
        }
        
        let ufoSize = texture.size()
        
        self.init(texture: texture, color: .clear, size: ufoSize)
        
        
        shapeOverlay = SKShapeNode(circleOfRadius: ufoSize.width/2)
        shapeOverlay.fillColor = SKColor.red
        shapeOverlay.strokeColor = SKColor.clear
        shapeOverlay.zPosition = -15
        shapeOverlay.alpha = 0
        
        self.addChild(shapeOverlay)
        
        configurePhysics(physicsBodyRadius: ufoSize.width/2)
        configureAnimations()
        configurePosition()
        
        self.health = 1
    }
    
    
    //MARK: ************* Configuration for position
    private func configurePosition(){
        let randomPoint = randomPointGenerator.getRandomPointInRandomQuadrant()
        self.position = randomPoint
    }
    
    //MARK: *********** Configuration for physics body
    private func configurePhysics(physicsBodyRadius: CGFloat){
        self.physicsBody = SKPhysicsBody(circleOfRadius: physicsBodyRadius)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
    
    }
    
    
    //MARK: ********* Configuration for animations
    
    private func configureAnimations(){
        configurePathAction()
        configureDamageAction()
        configureEmittingAction()
    
    }
    
    private func configureEmittingAction(){
        let colorizeAction = SKAction.colorize(with: UIColor.red, colorBlendFactor: 2.00, duration: 2.00)
        let reverseColorizeAction = SKAction.reversed(colorizeAction)()
        
        emittingAnimation = SKAction.repeatForever(SKAction.sequence([
            SKAction.group([
                colorizeAction,
                SKAction.scale(to: 1.20, duration: 0.30)
                ]),
            SKAction.group([
                reverseColorizeAction,
                SKAction.scale(to: 0.80, duration: 0.30)
                ])
            ]))
    }
    
    
    private func configureDamageAction(){
        let action = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.4, duration: 1.0),
            SKAction.fadeAlpha(to: 0.8, duration: 1.0)
            ])
        
        damageAction = SKAction.repeatForever(action)
    }
    
    private func configurePathAction(){
        let cgRect = CGRect(x: self.position.x, y: self.position.y, width: 100, height: 100)
        let path = CGPath(ellipseIn: cgRect, transform: nil)
        pathAction = SKAction.repeatForever(SKAction.follow(path, duration: 2.00))
        self.run(pathAction, withKey: "pathAction")
    }
    
    
    //MARK: *********** Game-Loop Related Functions
    func update(currentTime: TimeInterval){
        frameCount += currentTime - lastUpdateTime
        
        if(frameCount > emittingInterval){
            
            inFieldEmittingMode = !inFieldEmittingMode
            
            frameCount = 0
        }
        
        lastUpdateTime = currentTime
    }
    
    
    //MARK: ************** User touch/hit handlers
    
    func respondToTouch(){
        
        switch(getHealth()){
      
        case 1:
            takeDamage()
            decreaseHealthBy(healthUnits: 1)
            break
        case 0:
            die()
            break
        default:
            die()
        }
        
    }
    
    
    func takeDamage(){
        self.run(damageAction, withKey: "damageAction")
    }
    
  
    
    func die(){
        self.removeAllActions()
        
        let fallOffAction = SKAction.falloff(by: 2.00, duration: 3.00)
        shapeOverlay.zPosition = 15
        shapeOverlay.alpha = 1
        
        self.physicsBody?.affectedByGravity = true
        
        self.run(SKAction.sequence([
            fallOffAction,
            SKAction.wait(forDuration: 5.00),
            SKAction.removeFromParent()
            ]))
        
        
    }
    
    func getHealth() -> Int{
        return self.health
    }
    
    func decreaseHealthBy(healthUnits: Int){
        self.health -= healthUnits
    }
        
        
}

    
