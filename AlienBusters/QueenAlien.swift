//
//  QueenAlien.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/8/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

/** The Queen alien can appear in scenes to create physics fields that create noise and destabilize the player's crosshair or that create other gravity fields that suck up characters that need to be protected; a noise field can cause players to move erratically in their position
 
 
 **/

class QueenAlien: SKSpriteNode{
    
    public var noiseField: SKFieldNode = SKFieldNode()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {

        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init() {

        let texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .FlyingAliens)!.textureNamed("shipPink_manned")
        
        let size = texture.size()
        
        self.init(texture: texture, color: .clear, size: size)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.fieldBitMask = 0
        
        //noiseField = SKFieldNode.noiseField(withSmoothness: 2.0, animationSpeed: 1.0)
        noiseField = SKFieldNode.radialGravityField()
        noiseField.categoryBitMask = 0
        noiseField.strength = 0.5
        self.addChild(noiseField)
        setup()
    }
    
    private func setup(){
        self.position = CGPoint.zero
    }
    
    func changeNoiseFieldBitMaskCategoryTo(noiseFieldBitmaskCategory: UInt32){
        noiseField.categoryBitMask = noiseFieldBitmaskCategory
    }
    
    
    
}
