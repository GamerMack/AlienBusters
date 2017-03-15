//
//  Constants.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

//Debug Mode Flag
let kDebug = true


//UserOptions and Configuration Constants

/* NON-NAMESPACED GLOBAL CONSTANTS
 
    let kEasy = "Easy"
    let kMedium = "Medium"
    let kHard = "Hard"
 */

class UserSettings{
    
    static let ValidDifficultyLevels = [
        DifficultyLevel.Easy,
        DifficultyLevel.Medium,
        DifficultyLevel.Hard
    ]
    
    static let ValidGamePlayModes = [
        GamePlayMode.NoTimeLimit,
        GamePlayMode.TimeLimit
    ]
    
    class GamePlayMode{
        static let NoTimeLimit = "NoTimeLimit"
        static let TimeLimit = "TimeLimit"
    }
    
    class DifficultyLevel{
        static let Easy = "Easy"
        static let Medium = "Medium"
        static let Hard = "Hard"
    }
}


//Player Stats

/** GLOBAL CONSTANTS MAY BE USED INSTEAD OF STATIC CONSTANTS ON PLAYER STATS CLASS
    let kTotalKillCount = "TotalKillCount"
    let kTotalBulletsFired = "TotalBulletsFired"
    let kTotalTimeElapsed = "TotalTimeElapsed"
    let kTotalLevelsCompleted = "TotalLevelsCompleted"

    let kAverageLevelCompletionTime = "AverageLevelCompletionTime"
    let kShootingAccuracy = "ShootingAccuracy"
**/

class PlayerStats{
    static let TotalKillCount = "TotalKillCount"
    static let TotalBulletsFired = "TotalBulletsFired"
    static let TotalTimeElapsed = "TotalTimeElapsed"
    static let TotalLevelsCompleted = "TotalLevelsCompleted"
    static let AverageLevelCompletionTime = "AverageLevelCompletionTime"
    static let OverallShootingAccuracy = "OverallShootingAccuracy"
}



//Node Names

class NodeNames{
    static let StartButton = "StartButton"
    static let PauseButton = "PauseButton"
    static let ResumeButton = "ResumeButton"
    static let RestartGameButton = "RestartGame"
    static let ReturnToMenuButton = "ReturnToMenu"
    static let GameOverButton = "GameOver"
    static let CrossHairLight = "CrossHairLight"
    static let UFOFieldNode = "UFOFieldNode"
    
}

//ZPosition Constants

class ZPositionOrder{
    static let background = CGFloat(-12.0)
    static let hud = CGFloat(10.0)
}
