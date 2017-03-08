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
