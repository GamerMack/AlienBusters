//
//  ButtonManager.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/9/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

/**
 This class is only for demonstrating and teaching purposes.  Avoid use in production.
 **/
import Foundation
import SpriteKit


class ButtonManager{
    
    static let sharedInstance = ButtonManager()
    
    private var introMessageButton: SKSpriteNode?

    
    func getIntroMessageButton(withLevelTitleOf levelTitle: String, levelDescriptionOf levelDescription: String, andWithTimeLimitOf timeLimit: TimeInterval, andWithTextureNamed textureName: String = "yellow_panel") -> SKSpriteNode?{
        
        guard let introMessageButton = introMessageButton else { return nil}
        
        let newMessageButton = introMessageButton.copy() as! SKSpriteNode
        
        newMessageButton.texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .UI)?.textureNamed(textureName)
        
        for node in newMessageButton.children{
            if(node.name == "text1"){
                if let node = node as? SKLabelNode{
                    node.text = levelTitle
                    node.name = NodeNames.StartButton
                }
            }
            
            if(node.name == "text2"){
                if let node = node as? SKLabelNode{
                    node.text = levelDescription
                    node.name = NodeNames.StartButton
                }
            }
            
            if(node.name == "text3"){
                if let node = node as? SKLabelNode{
                    node.text = "Time Limit: \(timeLimit)"
                    node.name = NodeNames.StartButton
                }
            }
        }
        
        return newMessageButton
    }
    
    
    
    private init(){
        setup()
    }

    
    private func setup(){
        introMessageButton = GenerateIntroMessageBoxWith(levelTitle: "Level 1", levelDescription: "Shoot Enemies", levelTimeLimitWarning: "Time Limit: 30.00")
    }
    
    
    private func GenerateIntroMessageBoxWith(levelTitle: String, levelDescription: String, levelTimeLimitWarning: String, textureName: String = "yellow_panel") -> SKSpriteNode?{
        
        
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
        introText1.name = "text1"
        
        //Configure the center text: Level Description
        let introText2 = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
        introBox.addChild(introText2)
        introText2.position = CGPoint(x: 0, y: 0 )
        introText2.text = levelDescription
        introText2.fontSize = 20.0
        introText2.zPosition = 12
        introText2.name = "text2"
        
        //Configure the bottom text: Time Limit Reminder
        let introText3 = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
        introBox.addChild(introText3)
        introText3.position = CGPoint(x: 0, y: -introxBoxHeight*0.2 )
        introText3.fontSize = 20.0
        introText3.text = levelTimeLimitWarning
        introText3.zPosition = 12
        introText3.name = "text3"
        
        //Configure a pulsing action for the display box
        let introTextPulseAction = SKAction.sequence([
            SKAction.fadeIn(withDuration: 0.2),
            SKAction.fadeOut(withDuration: 0.2)
            ])
        
        let pulsingAction = SKAction.repeatForever(introTextPulseAction)
        
        introText1.run(pulsingAction)
        
        return introBox
        
    }
    
}
