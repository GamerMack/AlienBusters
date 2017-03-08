//
//  GameFonts.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/8/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class GameFonts{
    
    static let sharedInstance = GameFonts()
    
    //MARK: Public enum
    enum LabelType{
        case ButtonLabel,Message
    }
    
    //MARK: Private class constants
    private let labelSize: CGFloat = 16.0
    private let messageSize: CGFloat = 24.0
    
    //MARK: Private class variables 
    private let label = SKLabelNode()
    
    //MARK: - Init
    init(){
        setup()
    }
    
    //MARK: - Setup
    private func setup(){
        label.fontName = FontTypes.NoteWorthyBold
        label.verticalAlignmentMode = .center
    }
    
    
    func createLabel(string: String, type: LabelType) -> SKLabelNode{
        let copiedLabel = label.copy() as! SKLabelNode
        
        switch(type){
        case .Message:
            copiedLabel.horizontalAlignmentMode = .center
            copiedLabel.fontColor = SKColor.white
            copiedLabel.fontSize = messageSize
            copiedLabel.text = string
            break
        case .ButtonLabel:
            copiedLabel.horizontalAlignmentMode = .center
            copiedLabel.fontColor = SKColor.white
            copiedLabel.fontSize = labelSize
            copiedLabel.text = string
            break
        }
        
        return copiedLabel
    }
    
    //MARK: - Action
    
    func animate(label: SKLabelNode) -> SKAction{
        let action = SKAction.run({
            label.run(SKAction.sequence([
                SKAction.fadeIn(withDuration: 0.1),
                SKAction.scale(to: 1.25, duration: 0.1),
                SKAction.move(to: CGPoint(x: label.position.x , y: label.position.y + label.frame.size.height), duration: 0.1)
                ]), completion: {
                    label.removeFromParent()
            })
        
        })
        
        return action
    }
    
}
