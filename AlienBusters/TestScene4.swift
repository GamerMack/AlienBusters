//
//  TestScene4.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class TestScene4: TimeLimitScene{
    
    
    override func didMove(to view: SKView) {
        //Configure background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: BackgroundMusic.FarmFrolics, forParentNode: self)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let title = loadTextFromBatIntroSection(textType: "Title")!
        let mainText = loadTextFromBatIntroSection(textType: "MainText")!
        let instructions = loadTextFromBatIntroSection(textType: "Instructions")!
        
        let titleLabel = SKLabelNode(text: title)
        titleLabel.fontName = FontTypes.MarkerFeltThin
        titleLabel.fontSize = 40.0
        titleLabel.position = CGPoint(x: 0, y: 100)
        
        let mainTextLabel = SKLabelNode(text: mainText)
        mainTextLabel.fontName = FontTypes.MarkerFeltThin
        mainTextLabel.fontSize = 12.0
        mainTextLabel.position = CGPoint(x: 0, y: 0)
        
        let instructionLabel = SKLabelNode(text: instructions)
        instructionLabel.fontName = FontTypes.MarkerFeltThin
        instructionLabel.fontSize = 12.0
        instructionLabel.position = CGPoint(x: 0, y: -100)
        
        let textNode = SKSpriteNode()
        textNode.size = CGSize(width: ScreenSizeFloatConstants.HalfScreenWidth, height: ScreenSizeFloatConstants.HalfScreenHeight)
        textNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        textNode.position = CGPoint.zero
        
        textNode.addChild(titleLabel)
        textNode.addChild(mainTextLabel)
        textNode.addChild(instructionLabel)
        
        self.addChild(textNode)
            
    }
    
    private func loadTextFromBatIntroSection(textType: String) -> String?{
        if let introDict = PlistUnarchiver.loadSectionFromBatrackInfoDict(withSectionName: "Intro") as? [String: Any]?{
            if let text = introDict?[textType] as? String?{
                return text
            }
        }
        
        return nil
    }
    
    //MARK: Game Loop Functions
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func didSimulatePhysics() {
        
    }

    //MARK: User input event handlers

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
