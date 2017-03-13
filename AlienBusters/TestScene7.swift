//
//  TestScene7.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/13/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


/**  This scene animates the dialogue between the player and the enemy
 **/

class TestScene7: TimeLimitScene{
    
    let sceneDialogue = [
        ["Player": "Who are you?",
         "Enemy":"I am your worst nightmare"],
        
        ["Player":"Why are you here?",
         "Enemy":"To take over the earth!"],
        
        ["Player":"I can't let you do that!",
         "Enemy":"Haha! Try and stop me!"],
        
        ["Player":"Then come and fight!",
         "Enemy":"Ok, but first..."],
        
        ["Player":"First what?",
         "Enemy":"Let me introduce you to my pets! Hahaha..."]
    
    
    ]
    
    var dialogueIndex = 0
    
    let playerDialogueWindow = SKSpriteNode()
    let enemyDialogueWindow = SKSpriteNode()
    
    
    override func didMove(to view: SKView) {
        
        //Set anchor point of skView
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //Configure background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: BackgroundMusic.CheerfulAnnoyance, forParentNode: self)
        
        //ConfigureDialogueWindow
        configureDialogueWindows()
        
        //Animate entrance of dialogue windows
        playerDialogueWindow.run(SKAction.move(to: CGPoint(x: -200, y: 0), duration: 2.0))
        enemyDialogueWindow.run(SKAction.move(to: CGPoint(x: 200, y: 0), duration: 2.0))
        
    }
    
    private func configureDialogueWindows(){
        
        let dialogue = sceneDialogue[dialogueIndex]
        let playerDialogueText = dialogue["Player"]
        let enemyDialogueText = dialogue["Enemy"]
        
        //Player dialogue window configuration
        let playerTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .DialogueAvatars)?.textureNamed("face_man")
        
        let playerAvatar = SKSpriteNode(texture: playerTexture)
        playerAvatar.position = CGPoint(x: 0, y: 50)
        playerAvatar.name = "avatar"
        
        let playerText = SKLabelNode(fontNamed: FontTypes.MarkerFeltThin)
        playerText.name = "text"
        playerText.position = CGPoint(x: 0, y: -150)
        playerText.text = playerDialogueText
        
        playerDialogueWindow.addChild(playerAvatar)
        playerDialogueWindow.addChild(playerText)
        
        
        //Enemy Dialogue Window Configuration
        let enemyTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .DialogueAvatars)?.textureNamed("face_orc")
        
        let enemyAvatar = SKSpriteNode(texture: enemyTexture)
        enemyAvatar.position = CGPoint(x: 0, y: 50)
        enemyAvatar.name = "avatar"
        
        
        let enemyText = SKLabelNode(fontNamed: FontTypes.MarkerFeltThin)
        enemyText.name = "text"
        enemyText.position = CGPoint(x: 0, y: -150)
        enemyText.text = enemyDialogueText
        
        playerDialogueWindow.position = CGPoint(x: -700, y: 0)
        enemyDialogueWindow.position = CGPoint(x: 700, y: 0)
        
        
        enemyDialogueWindow.addChild(enemyAvatar)
        enemyDialogueWindow.addChild(enemyText)
        
        self.addChild(playerDialogueWindow)
        self.addChild(enemyDialogueWindow)
    }
    
    
    private func advanceDialogueText(){
        let dialogue = sceneDialogue[dialogueIndex]
        let playerDialogueText = dialogue["Player"]
        let enemyDialogueText = dialogue["Enemy"]
        
      
        for node in playerDialogueWindow.children{
            if let node = node as? SKLabelNode{
                node.text = playerDialogueText
                
            }
        }
        
        for node in enemyDialogueWindow.children{
            if let node = node as? SKLabelNode{
                node.text = enemyDialogueText
                
            }
        }
        
      
        
       
        if(dialogueIndex == sceneDialogue.count-1){
            playerDialogueWindow.run(SKAction.move(to: CGPoint(x: -750, y: 0), duration: 2.00))
            enemyDialogueWindow.run(SKAction.move(to: CGPoint(x: 750, y:0), duration: 2.00))
        }
        
        if(dialogueIndex < sceneDialogue.count-1){
            dialogueIndex += 1
        } else {
            dialogueIndex = 0
        }

    }
    
    //Game loop function
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func didSimulatePhysics() {
        
    }
    
    
    //User input handlers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
