//
//  PauseButton.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/8/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class PauseButton: SKSpriteNode{
    
    enum ButtonType{
        case Pause
        case Resume
    }
    
    let pauseLabelNode = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
    let resumeLabelNode = SKLabelNode(fontNamed: FontTypes.NoteWorthyLight)
    
    //MARK: Private class constants
    private let pauseTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .UI)?.textureNamed("yellow_button_09")
    
    private let resumeTexture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .UI)?.textureNamed("yellow_button_08")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init?(buttonType: ButtonType) {
        
        var texture: SKTexture?
        
        switch(buttonType){
        case .Pause:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .UI)?.textureNamed("yellow_button09")
            break
        case .Resume:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .UI)?.textureNamed("yellow_button09")
            break
        }
        
        guard let finalTexture = texture else {return nil}
        
        let size = finalTexture.size()
       
        
        self.init(texture: finalTexture, color: .clear, size: size )
        
        
        configureBasicParameters()
        configureLabelNodes()
        
        switch(buttonType){
            case .Pause:
                self.name = NodeNames.PauseButton
                self.addChild(pauseLabelNode)
                break
            case .Resume:
                self.name = NodeNames.ResumeButton
                self.addChild(resumeLabelNode)
                break
        }
    }
    
    //MARK: Private class variables
    private var gamePaused = false
    
    
    private func configureLabelNodes(){
        //Configure pause label node
        pauseLabelNode.text = "Pause"
        pauseLabelNode.name = NodeNames.PauseButton
        pauseLabelNode.verticalAlignmentMode = .center
        pauseLabelNode.horizontalAlignmentMode = .center
        pauseLabelNode.fontSize = 10.0
        pauseLabelNode.fontColor = SKColor.blue
        pauseLabelNode.position = CGPoint(x: -10, y: -10)
        pauseLabelNode.zPosition = 12
        
        //Configure resume label node
        resumeLabelNode.text = "Resume"
        resumeLabelNode.name = NodeNames.ResumeButton
        resumeLabelNode.verticalAlignmentMode = .center
        resumeLabelNode.verticalAlignmentMode = .center
        resumeLabelNode.fontSize = 10.0
        resumeLabelNode.fontColor = SKColor.blue
        resumeLabelNode.position = CGPoint(x: -30, y: -30)
        resumeLabelNode.zPosition = 12
    }
    
    private func configureBasicParameters(){
        //Set the anchor point to be the top right corner of the button
        self.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        
        //Position button in the top right corner of the screen
        self.position = CGPoint(x: kViewWidth/2, y: kViewHeight/2)
        
        //Rescale the size of the buttons
        self.size = CGSize(width: kViewWidth*0.10, height: kViewHeight*0.06)
        
        //Set the zPosition
        self.zPosition = 10
    }
    
    //MARK: - Actions
    func tapped(){
        //toggle gamePaused
        gamePaused = !gamePaused
        
        self.texture = gamePaused ? resumeTexture: pauseTexture
        
        if(gamePaused){
            self.removeAllChildren()
            self.addChild(resumeLabelNode)
            self.name = NodeNames.ResumeButton
        }else{
            self.removeAllChildren()
            self.addChild(pauseLabelNode)
            self.name = NodeNames.PauseButton
        }
    }
    
    func getPauseState() -> Bool{
        return gamePaused
    }
}
