//
//  TimeLimitMode+GameStateExtension.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/8/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

/**
 Gameplay Mode is determined at the MenuScene, along with Difficulty Level.  Scenes that conform to the NoTimeLimitMode Protocol restrict the ammunition (i.e. number of bullets) of the player and require that the player destroy all enemies with the given ammunition in order to advance to the next level.  Game ends when the player's number of bullets has reached zero or when all enemies in a given level have been destroyed.
 
 Scenes that conform to the TimeLimitModeProtocol do not restrict the player's ammunition but require a timer as a stored property to keep track of total time elapsed.  Maximum time allowed can vary with GamePlayDifficulty.  Game ends when maximum allowable time has elapsed or when all enemies in a given level have been destroyed.
 
 **/



extension TimeLimitScene{
    
    enum GameState: Int{
        case Running, Paused, Waiting, GameOver
    }
    
   
    //MARK: Game State Toggle Functions
    
    func enterGameOverState(){
        state = .GameOver
        timerIsStarted = false
    }
    
    func enterRunningState(){
        state = .Running
        timerIsStarted = true
    }
    
    func enterPausedState(){
        state = .Paused
        timerIsStarted = false
        
    }
    
    func enterResumedState(){
        state = .Running
        timerIsStarted = false
    }
    
}
