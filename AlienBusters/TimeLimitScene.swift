//
//  TimeLimitScene.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


class TimeLimitScene: SKScene{
    
    //MARK: GameState
    var state: GameState = .Waiting
    
    //MARK: Timing-related Variables
    var timeLimit: TimeInterval = 0
    var timerIsStarted: Bool = false
    var lastUpdateTime: TimeInterval = 0.00
    var totalRunningTime: TimeInterval = 0.00
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    
    }
    
    func setTimeLimit(newTimeLimit: TimeInterval){
        timeLimit = newTimeLimit
    }
    
    func toggleTimerState(){
        timerIsStarted = !timerIsStarted
    }
    
    func resetTotalRunningTime(){
        totalRunningTime = 0
    }
}
