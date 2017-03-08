//
//  StartButton.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/8/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

class StartButton: SKSpriteNode{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init() {
        
        self.init(texture: nil, color: .clear, size: CGSize(width: 50.0, height: 30.0))
    
        setup()
    }
    
    private func setup(){
        self.position = CGPoint.zero
    }
    
    //MARK: - Touch Events
    func buttonTapped(){
        animateOut()
    }
    
    //MARK: Animations
    private func animateOut(){
        self.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.run({
                [weak self] in
                self?.removeFromParent()
            })
            ]))
    }
    
}
