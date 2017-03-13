//
//  BackgroundObject.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/13/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


class BackgroundObject: SKSpriteNode{
    
    enum BackgroundObjectType{
        case Cloud1
        case Cloud2
        case Cloud3
        case Cloud4
        case Cloud5
        case Cloud6
        case Sun
        case FullMoon
        case HalfMoon
    }
    
    let textureAtlas = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .BackgroundObjects)!
    
    
    let randomPointGenerator = RandomPoint(algorithmType: .Faster)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(backgroundObjectType: BackgroundObjectType) {
        
        let backgroundObjectsAtlas = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .BackgroundObjects)!
        
        var texture: SKTexture
        
        switch(backgroundObjectType){
        case .Cloud1:
            texture = backgroundObjectsAtlas.textureNamed("cloud1")
            break
        case .Cloud2:
            texture = backgroundObjectsAtlas.textureNamed("cloud2")
            break
        case .Cloud3:
            texture = backgroundObjectsAtlas.textureNamed("cloud3")
            break
        case .Cloud4:
            texture = backgroundObjectsAtlas.textureNamed("cloud4")
            break
        case .Cloud5:
            texture = backgroundObjectsAtlas.textureNamed("cloud5")
            break
        case .Cloud6:
            texture = backgroundObjectsAtlas.textureNamed("cloud6")
            break
        case .Sun:
            texture = backgroundObjectsAtlas.textureNamed("sun")
            break
        case .FullMoon:
            texture = backgroundObjectsAtlas.textureNamed("moon_full")
            break
        case .HalfMoon:
            texture = backgroundObjectsAtlas.textureNamed("moon_half")
            break
        }
        
        let spriteSize = texture.size()
        
        self.init(texture: texture, color: .clear, size: spriteSize)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = randomPointGenerator.getUpperScreenPoint()
        
        
    }
}
