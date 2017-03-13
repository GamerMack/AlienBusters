//
//  HelperFunctions.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class AnimationsFactory{


    static func createExplosionFor(spriteNode: SKSpriteNode){
        /** OPTIONAL CODE FOR ADDING A PLACEHOLDER NODE TO EXECUTE THE EXPLOSION ANIMATION
         let explodingNode = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: 50, height: 50))
         
         explodingNode.position = CGPoint.zero
         self.addChild(explodingNode)
         **/
        
        
        let explosionAnimationWithSound = AnimationsManager.sharedInstance.getAnimationWithNameOf(animationName: "explosionAnimationWithSound")
        
        spriteNode.run(explosionAnimationWithSound, withKey: "delayedExplosion")
        
    }
    
}


private func configureHelpButton(forParentNode parentNode: SKNode)-> SKSpriteNode{
    
    let helpButtonTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .UI)?.textureNamed("yellow_button01")
    
    let helpButtonHeight = kViewHeight*0.05
    let helpButtonWidth = kViewWidth*0.06
    let helpButtonSize = CGSize(width: helpButtonWidth, height: helpButtonHeight)
    
    let helpButton = SKSpriteNode(texture: helpButtonTexture!, color: SKColor.blue, size: helpButtonSize)
    
    
    
    helpButton.name = "Help"
    helpButton.anchorPoint = CGPoint(x: 1.0, y: 1.0)
    helpButton.zPosition = 12
    helpButton.position = CGPoint(x: kViewWidth/2-helpButtonWidth-10, y: kViewHeight/2-helpButtonHeight-5)
    
    let helpButtonText = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
    helpButtonText.fontSize = 10.0
    helpButtonText.fontColor = SKColor.blue
    helpButtonText.text = "Help"
    helpButtonText.name = "Help"
    helpButtonText.verticalAlignmentMode = .center
    helpButtonText.horizontalAlignmentMode = .center
    helpButtonText.position = CGPoint(x: -15.0, y: -10.0)
    helpButtonText.zPosition = 13
    
    helpButton.addChild(helpButtonText)

    return helpButton
}

