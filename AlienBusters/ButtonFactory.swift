//
//  ButtonFactory.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/9/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonFactory{
    
    
    static func createIntroMessageWith(levelTitle: String, levelDescription: String, enemyName: String, spawningLimit: Int, textureName: String = "yellow_panel") -> SKSpriteNode?{
        
        
        //The texture for IntroMessage Box must be loaded in order for the rest of the function bloc to be executed
        guard let introBoxTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .UI)?.textureNamed(textureName) else { return nil }
        
        
        
        
        
        
        //The IntroMessage Box dimensions for width and height are 40% of the width and 40% of the height of the UIScreen, respectively; zPosition is set at 10 so that the IntroMessage Box appears in front of all other game objets
        let introBox = SKSpriteNode(texture: introBoxTexture, color: .clear, size: CGSize(width: kViewWidth*0.4, height: kViewHeight*0.4))
        introBox.position = CGPoint.zero
        introBox.zPosition = 10
        
        //The node name for the IntroBox will be StartButton; when the user clicks, the game begins
        introBox.name = NodeNames.StartButton
        
        
        //The message text is position relative to the height of the message box
        let introxBoxHeight = ScreenSizeFloatConstants.ScrrenHeight*0.4
        
        //Configure the top text: Level Title
        let introText1 = SKLabelNode(fontNamed: FontTypes.NoteWorthyBold)
        introBox.addChild(introText1)
        introText1.position = CGPoint(x: 0, y: introxBoxHeight*0.2 )
        introText1.text = levelTitle
        introText1.fontSize = 30.0
        introText1.zPosition = 12
        introText1.name = NodeNames.StartButton
        
        //Configure the center text: Level Description
        let introText2 = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
        introBox.addChild(introText2)
        introText2.position = CGPoint(x: 0, y: 0 )
        introText2.text = levelDescription
        introText2.fontSize = 20.0
        introText2.zPosition = 12
        introText2.name = NodeNames.StartButton
        
        //Configure the bottom text: Time Limit Reminder
        let introText3 = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
        introBox.addChild(introText3)
        introText3.position = CGPoint(x: 0, y: -introxBoxHeight*0.2 )
        introText3.fontSize = 10.0
        introText3.text = "Shoot every \(enemyName). If \(spawningLimit) are spawned, you lose"
        introText3.zPosition = 12
        introText3.name = NodeNames.StartButton
        
        //Configure a pulsing action for the display box
        let introTextPulseAction = SKAction.sequence([
            SKAction.fadeIn(withDuration: 0.2),
            SKAction.fadeOut(withDuration: 0.2)
            ])
        
        let pulsingAction = SKAction.repeatForever(introTextPulseAction)
        
        introText1.run(pulsingAction)
        
        return introBox
        
    }

    
    
    static func createIntroMessageWith(levelTitle: String, levelDescription: String, levelTimeLimit: TimeInterval, textureName: String = "yellow_panel") -> SKSpriteNode?{
        
        
        //The texture for IntroMessage Box must be loaded in order for the rest of the function bloc to be executed
        guard let introBoxTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .UI)?.textureNamed(textureName) else { return nil }
        
        
        
        
        
        
        //The IntroMessage Box dimensions for width and height are 40% of the width and 40% of the height of the UIScreen, respectively; zPosition is set at 10 so that the IntroMessage Box appears in front of all other game objets
        let introBox = SKSpriteNode(texture: introBoxTexture, color: .clear, size: CGSize(width: kViewWidth*0.4, height: kViewHeight*0.4))
        introBox.position = CGPoint.zero
        introBox.zPosition = 10
        
        //The node name for the IntroBox will be StartButton; when the user clicks, the game begins
        introBox.name = NodeNames.StartButton
        
        
        //The message text is position relative to the height of the message box
        let introxBoxHeight = kViewHeight*0.4
        
        //Configure the top text: Level Title
        let introText1 = SKLabelNode(fontNamed: FontTypes.NoteWorthyBold)
        introBox.addChild(introText1)
        introText1.position = CGPoint(x: 0, y: introxBoxHeight*0.2 )
        introText1.text = levelTitle
        introText1.fontSize = 30.0
        introText1.zPosition = 12
        introText1.name = NodeNames.StartButton
        
        //Configure the center text: Level Description
        let introText2 = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
        introBox.addChild(introText2)
        introText2.position = CGPoint(x: 0, y: 0 )
        introText2.text = levelDescription
        introText2.fontSize = 20.0
        introText2.zPosition = 12
        introText2.name = NodeNames.StartButton
        
        //Configure the bottom text: Time Limit Reminder
        let introText3 = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
        introBox.addChild(introText3)
        introText3.position = CGPoint(x: 0, y: -introxBoxHeight*0.2 )
        introText3.fontSize = 20.0
        introText3.text = "Time Limit: \(levelTimeLimit) seconds"
        introText3.zPosition = 12
        introText3.name = NodeNames.StartButton
        
        //Configure a pulsing action for the display box
        let introTextPulseAction = SKAction.sequence([
            SKAction.fadeIn(withDuration: 0.2),
            SKAction.fadeOut(withDuration: 0.2)
            ])
        
        let pulsingAction = SKAction.repeatForever(introTextPulseAction)
        
        introText1.run(pulsingAction)
        
        return introBox
        
    }
    
    
    static func createPauseButton(withPosition position: CGPoint = CGPoint(x: -kViewWidth/2 + 5, y: -kViewHeight/2 + 5), andWithSizeOf size: CGSize = CGSize(width: kViewWidth*0.10, height: kViewHeight*0.06) ) -> SKSpriteNode{
        
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
    
    static func resetPauseButton(pauseButton: SKSpriteNode, withLabelTextOf labelText: String, andWithNodeNameOf nodeName: String, withPauseState pauseState: Bool){
        
        pauseButton.name = nodeName
        pauseButton.userData?.setValue(pauseState, forKey: "isPaused")
        
        for node in pauseButton.children{
            if let node = node as? SKLabelNode{
                node.text = labelText
                node.name = nodeName
            }
        }
    }
    
    
}
