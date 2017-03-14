//
//  AnimationsManager.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


class AnimationNames{
    static let ExplosionAnimation = "explosionAnimation"
    static let ExplosionAnimationWithSound = "explosionAnimationWithSound"
}

class AnimationsManager{
    
    static let sharedInstance = AnimationsManager()
    
    private let textureAtlasManager = TextureAtlasManager.sharedInstance
    
    private var animationsDictionary = [String:SKAction]()
    
    
    func getAnimationWithNameOf(animationName: String) -> SKAction{
        
        if let requestedAction = animationsDictionary[animationName]{
            return requestedAction
        }
        
        return SKAction()
    }
    
    
    private init(){
        configureAnimationsDict()
    }
    
    
    private func configureAnimationsDict(){
        
        guard let explosionTextureAtlas = textureAtlasManager.getTextureAtlasOfType(textureAtlasType: .RegularExplosion) else { return }
        
        let explosionAnimation = SKAction.animate(with: [
            explosionTextureAtlas.textureNamed("regularExplosion00"),
            explosionTextureAtlas.textureNamed("regularExplosion01"),
            explosionTextureAtlas.textureNamed("regularExplosion02"),
            explosionTextureAtlas.textureNamed("regularExplosion03"),
            explosionTextureAtlas.textureNamed("regularExplosion04"),
            explosionTextureAtlas.textureNamed("regularExplosion05"),
            explosionTextureAtlas.textureNamed("regularExplosion06"),
            explosionTextureAtlas.textureNamed("regularExplosion07"),
            explosionTextureAtlas.textureNamed("regularExplosion08"),
            explosionTextureAtlas.textureNamed("regularExplosion09")
            ], timePerFrame: 0.30)
        
        
        let explosionAnimationWithSound = SKAction.group([
            SKAction.playSoundFileNamed("rumble3", waitForCompletion: false),
            explosionAnimation
            ])
        
        animationsDictionary["explosionAnimation"] = explosionAnimation
        animationsDictionary["explosionAnimationWithSound"] = explosionAnimationWithSound
        
    }
}
