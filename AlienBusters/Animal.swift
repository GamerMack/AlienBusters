//
//  Animal.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/13/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class Animal: SKSpriteNode{
    
    let textureAtlas = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .Animals)
    
    enum AnimalType{
        case Elephant
        case Giraffe
        case Monkey
        case Hippo
        case Panda
        case Parrot
        case Penguin
        case Pig
        case Rabbit
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init?(animalType: AnimalType) {
        
        guard let textureAtlas = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .Animals) else { return nil }
        
        var texture: SKTexture
        
        switch(animalType){
            case .Elephant:
            texture = textureAtlas.textureNamed("elephant")
            break
        case .Giraffe:
            texture = textureAtlas.textureNamed("giraffe")
            break
        case .Monkey:
            texture = textureAtlas.textureNamed("monkey")
            break
        case .Penguin:
            texture = textureAtlas.textureNamed("penguin")
            break
        case .Rabbit:
            texture = textureAtlas.textureNamed("rabbit")
            break
        case .Pig:
            texture = textureAtlas.textureNamed("pig")
            break
        case .Panda:
            texture = textureAtlas.textureNamed("panda")
            break
        case .Parrot:
            texture = textureAtlas.textureNamed("parrot")
            break
        case .Hippo:
            texture = textureAtlas.textureNamed("hippo")
            break
        }
        
        let animalSize = texture.size()
        
        self.init(texture: texture, color: .clear, size: animalSize)
        
        configurePhysics(physicsBodyRadius: animalSize.width/2)
    
    }
    
    
    private func configurePhysics(physicsBodyRadius: CGFloat){
        self.physicsBody = SKPhysicsBody(circleOfRadius: physicsBodyRadius)
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.isDynamic = true
        self.physicsBody?.mass = 0.02
        self.physicsBody?.linearDamping = 0.0
        
    }
}
