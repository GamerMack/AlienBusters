//
//  PauseButton.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/8/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import SpriteKit

func createPauseButton(withPosition position: CGPoint = CGPoint(x: -kViewWidth/2 + 5, y: -kViewHeight/2 + 5), andWithSizeOf size: CGSize = CGSize(width: kViewWidth*0.10, height: kViewHeight*0.06) ) -> SKSpriteNode{
    
        let pauseNodeTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .UI)?.textureNamed("yellow_button09")
        let pauseNode = SKSpriteNode(texture: pauseNodeTexture)
    
        //Set the pauseNode's name to PauseButton
        pauseNode.name = NodeNames.PauseButton
    
        //Set the anchor point to be the top right corner of the button
        pauseNode.anchorPoint = CGPoint(x: 0, y: 0)
    
        //Position button in the top right corner of the screen
        pauseNode.position = CGPoint(x: -kViewWidth/2 + 5, y: -kViewHeight/2 + 5)
    
        //Rescale the size of the buttons
        pauseNode.size = CGSize(width: kViewWidth*0.10, height: kViewHeight*0.06)
    
        //Set the zPosition
        pauseNode.zPosition = 10
    
        //Set initial value for isPaused attribute in userData to false
        pauseNode.userData?.setValue(false, forKey: "isPaused")
    
        let pauseLabelNode = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
        pauseLabelNode.text = "Pause"
        pauseLabelNode.name = NodeNames.PauseButton
        pauseLabelNode.verticalAlignmentMode = .center
        pauseLabelNode.horizontalAlignmentMode = .center
        pauseLabelNode.fontSize = 15.0
        pauseLabelNode.fontColor = SKColor.blue
        pauseLabelNode.position = CGPoint(x: 25, y: 15)
        pauseLabelNode.zPosition = 12
        pauseNode.addChild(pauseLabelNode)
    
        return pauseNode
        
}



