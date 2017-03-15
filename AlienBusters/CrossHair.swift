//
//  CrossHair.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class CrossHair: SKSpriteNode{
    
    //MARK: Private class constants
    private let textureAtlas = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .CrossHair)
    
    private let touchOffset = 44.0
    private let moveFilter = 0.80
    
    //MARK: Private class variables
    private var targetPosition = CGPoint()
    
    
    enum CrossHairType{
        case RedSmall
        case RedLarge
        case BlueSmall
        case BlueLarge
        case WhiteSmall
        case WhiteLarge
        case OutlineSmall
        case OutlineLarge
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    
    convenience init?(crossHairType: CrossHairType) {
        
        var texture: SKTexture?
        
        switch(crossHairType){
        case .BlueLarge:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .CrossHair)?.textureNamed("crosshair_blue_large")
            break
        case .BlueSmall:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .CrossHair)?.textureNamed("crosshair_blue_small")
            break
        case .RedLarge:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .CrossHair)?.textureNamed("crosshair_red_large")
            break
        case .RedSmall:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .CrossHair)?.textureNamed("crosshair_red_small")
            break
        case .OutlineLarge:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .CrossHair)?.textureNamed("crosshair_outline_large")
            break
        case .OutlineSmall:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .CrossHair)?.textureNamed("crosshair_outline_small")
            break
        default:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .CrossHair)?.textureNamed("crosshair_blue_small")
        }
        
        
        guard let crosshairTexture = texture else { return nil}
        
        self.init(texture: crosshairTexture, color: .clear, size: crosshairTexture.size())
        configureLighting()
        configurePhysics()
        setup()
        
    }
    
    private func setup(){
        self.position = CGPoint(x: 0, y: 0)
        targetPosition = self.position
    }
    
    private func configureLighting(){
        let crosshairLight = SKLightNode()
        crosshairLight.name = NodeNames.CrossHairLight
        crosshairLight.categoryBitMask = 1
        crosshairLight.lightColor = SKColor.yellow
        crosshairLight.shadowColor = SKColor.gray
        crosshairLight.ambientColor = SKColor.clear
        self.addChild(crosshairLight)
    }
    
    private func configurePhysics(){
        let radius = self.size.width/2.0
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody?.fieldBitMask = PhysicsCategory.Player
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
    
    }
    
    //MARK: - Update
    func update(){
        move()
    }
    
    //MARK: - Movement
    func updateTargetPosition(position: CGPoint){
        targetPosition = CGPoint(x: Double(position.x), y: Double(position.y) + touchOffset)
    }
    
    private func move(){
        let newX = Smooth(startPoint: self.position.x, endPoint: targetPosition.x, percentToMove: NumberUnit(moveFilter))
        let newY = Smooth(startPoint: self.position.y, endPoint: targetPosition.y, percentToMove: NumberUnit(moveFilter))
        
        self.position = CGPoint(x: newX, y: newY)
    }
    
}
