//
//  Background.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


import Foundation
import SpriteKit

class Background: SKSpriteNode{
    
    //MARK: Private class constants
    private let textureAtlas = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .BackgroundScenes)
  
    
    
    enum BackgroundType{
        case UncoloredForest
        case UncoloredHills
        case UncoloredPeaks
        case UncoloredPlain
        case UncoloredPiramids
        case UncoloredTallTrees
        case UncoloredDesert
        case ColoredForest
        case ColoredCastle
        case ColoredDesert
        case ColoredTallTrees
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    
    convenience init?(backgroundType: BackgroundType) {
        
        var texture: SKTexture?
        
        switch(backgroundType){
        case .UncoloredHills:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .BackgroundScenes)?.textureNamed("uncolored_hills")
            break
        case .UncoloredPeaks:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .BackgroundScenes)?.textureNamed("uncolored_peaks")
            break
        case .UncoloredPlain:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .BackgroundScenes)?.textureNamed("uncolored_plain")
            break
        case .UncoloredDesert:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .BackgroundScenes)?.textureNamed("uncolored_desert")
            break
        case .UncoloredForest:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .BackgroundScenes)?.textureNamed("uncolored_forest")
            break
        case .UncoloredPiramids:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .BackgroundScenes)?.textureNamed("uncolored_piramids")
            break
        case .UncoloredTallTrees:
             texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .BackgroundScenes)?.textureNamed("uncolored_talltrees")
            break
        case .ColoredCastle:
             texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .BackgroundScenes)?.textureNamed("colored_castle")
            break
        case .ColoredDesert:
             texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .BackgroundScenes)?.textureNamed("colored_desert")
            break
        case .ColoredForest:
             texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .BackgroundScenes)?.textureNamed("colored_forest")
            break
        case .ColoredTallTrees:
             texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .BackgroundScenes)?.textureNamed("colored_talltrees")
            break
        default:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .BackgroundScenes)?.textureNamed("uncolored_forest")
        }
        
        
        guard let backgroundTexture = texture else {  return nil }
        
        self.init(texture: backgroundTexture, color: .clear, size: backgroundTexture.size())
        setup()
        
    }
    
    private func setup(){
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = CGPoint(x: 0, y: 0.0)
        self.zPosition = ZPositionOrder.background
    }
    
    //MARK: - Update
    func update(){
    }
    
   

}
