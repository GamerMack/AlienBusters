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
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .UI)?.textureNamed("yellow_button_09")
        case .Resume:
            texture = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .UI)?.textureNamed("yellow_button_09")
            break
        }
        
        guard let finalTexture = texture else {return nil}
        
        let size = finalTexture.size()
        
        self.init(texture: finalTexture, color: .clear, size: size )

        
    }
    
    //MARK: Private class variables
    private var gamePaused = false
    
    
    private func setup(){
        //Set the anchor point to be the top right corner of the button
        self.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        
        //Position button in the top right corner of the screen
        self.position = CGPoint(x: kViewWidth/2, y: kViewHeight/2)
    }
    
    //MARK: - Actions
    func tapped(){
        //toggle gamePaused
        gamePaused = !gamePaused
        
        self.texture = gamePaused ? resumeTexture: pauseTexture
    }
    
    func getPauseState() -> Bool{
        return gamePaused
    }
}
