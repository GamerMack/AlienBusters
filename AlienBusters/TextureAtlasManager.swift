//
//  TextureAtlasManager.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class TextureAtlasManager{
    
    static public let sharedInstance = TextureAtlasManager()
    
    enum TextureAtlasType{
        case BackgroundScenes
        case BackgroundObjects
        case GroundExplosion
        case RegularExplosion
        case FlyingAliens
        case Enemies
        case HUD
        case CrossHair
        case Trees
    }
    
    func getTextureAtlasOfType(textureAtlasType: TextureAtlasType) -> SKTextureAtlas?{
        
        
        
        switch(textureAtlasType)
        {
            case .CrossHair:
                return crosshairAtlas
            case .Enemies:
                return enemiesAtlas
            case .HUD:
                return hudAtlas
            case .BackgroundScenes:
                return backgroundScenesAtlas
            case .BackgroundObjects:
                return backgroundObjectsAtlas
            case .RegularExplosion:
                return regularExplosionAtlas
            case .GroundExplosion:
                return groundExplosionAtlas
            case .Trees:
                return treesAtlas
            case .FlyingAliens:
                return flyingAliensAtlas

        }
    }
    
    private var crosshairAtlas: SKTextureAtlas?
    private var enemiesAtlas: SKTextureAtlas?
    private var hudAtlas: SKTextureAtlas?
    private var treesAtlas: SKTextureAtlas?
    private var flyingAliensAtlas: SKTextureAtlas?
    private var regularExplosionAtlas: SKTextureAtlas?
    private var groundExplosionAtlas: SKTextureAtlas?
    private var backgroundObjectsAtlas: SKTextureAtlas?
    private var backgroundScenesAtlas: SKTextureAtlas?
    
    
    private init(){
        setup()
    }
    
    private func setup(){
          crosshairAtlas = SKTextureAtlas(named: "CrossHair")
          enemiesAtlas = SKTextureAtlas(named: "Enemies")
          hudAtlas = SKTextureAtlas(named: "HUD")
          treesAtlas = SKTextureAtlas(named: "Trees")
          flyingAliensAtlas = SKTextureAtlas(named: "FlyingAliens")
          regularExplosionAtlas = SKTextureAtlas(named: "RegularExplosion")
          groundExplosionAtlas = SKTextureAtlas(named: "GroundExplosion")
          backgroundObjectsAtlas = SKTextureAtlas(named: "BackgroundObjects")
          backgroundScenesAtlas = SKTextureAtlas(named: "BackgroundScenes")
    }
    
}
