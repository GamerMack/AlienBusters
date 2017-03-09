//
//  HelperFunctions.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

//Preload Sounds

func preloadSounds() {
    do {
        let sounds: [String] = [
            SoundEffectsNoFileExtension.Explosion2,
            SoundEffectsNoFileExtension.Explosion3,
            SoundEffectsNoFileExtension.Laser2,
            SoundEffectsNoFileExtension.Laser3,
            SoundEffectsNoFileExtension.Laser4,
            SoundEffectsNoFileExtension.Laser5,
            SoundEffectsNoFileExtension.Laser6,
            SoundEffectsNoFileExtension.Laser7,
            SoundEffectsNoFileExtension.Laser8,
            SoundEffectsNoFileExtension.Laser9
        ]
        
        for sound in sounds{
            let path: String = Bundle.main.path(forResource: sound, ofType: "wav")!
            let url: URL = URL(fileURLWithPath: path)
            let player: AVAudioPlayer = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
        }
        
    } catch {
        //Error handling code
    }

}






func createExplosionFor(spriteNode: SKSpriteNode){
    /** OPTIONAL CODE FOR ADDING A PLACEHOLDER NODE TO EXECUTE THE EXPLOSION ANIMATION
     let explodingNode = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: 50, height: 50))
     
     explodingNode.position = CGPoint.zero
     self.addChild(explodingNode)
     **/
    
    
    let explosionAnimationWithSound = AnimationsManager.sharedInstance.getAnimationWithNameOf(animationName: "explosionAnimationWithSound")
    
    spriteNode.run(explosionAnimationWithSound, withKey: "delayedExplosion")
    
}

func createIntroMessageWith(levelTitle: String, levelDescription: String, levelTimeLimit: TimeInterval, textureName: String = "yellow_panel") -> SKSpriteNode?{
    
    
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

