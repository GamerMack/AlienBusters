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
    private let moveFilter = 0.02
    
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
        setup()
        
    }
    
    private func setup(){
        self.position = CGPoint(x: 0, y: 0.2*kViewHeight/2)
        targetPosition = self.position
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
        let newX = Smooth(startPoint: Double(self.position.x), endPoint: Double(targetPosition.x), percentToMove: moveFilter)
        let newY = Smooth(startPoint: Double(self.position.y), endPoint: Double(targetPosition.y), percentToMove: moveFilter)
        
        self.position = CGPoint(x: newX, y: newY)
    }
    
}
