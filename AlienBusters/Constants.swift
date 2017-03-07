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

//Screen Size
let kViewSize = UIScreen.main.bounds
let kViewWidth = kViewSize.width
let kViewHeight = kViewSize.height

//Fonts
let kFuturaCondensedExtraBold = "Futura-CondensedExtraBold"
let kFuturaCondensedMedium = "Futura-CondensedMedium"
let kFuturaMedium = "Futura-Medium"
let kFuturaMediumItalic = "Futura-MediumItalic"

//Background Audio Track Titles
let kGermanVirtue = "German Virtue.mp3"
let kInfiniteDescent = "Infinite Descent.mp3"
let kItalianMom = "Italian Mom.mp3"
let kMishiefStroll = "Mishief Stroll.mp3"
let kMissionPlausible = "Mission Plausible.mp3"
let kCheerfulAnnoyance = "Cheerful Annoyance.mp3"
let kDrummingSticks = "Drumming Sticks.mp3"
let kFarmFrolics = "Farm Frolics.mp3"
let kFlowingRocks = "Flowing Rocks.mp3"
let kGameOver = "Game Over.mp3"


class BackgroundMusic{
    static let GermanVirtue = kGermanVirtue
    static let InfiniteDescent = kInfiniteDescent
    static let ItalianMom = kItalianMom
    static let MishiefStroll = kMishiefStroll
    static let MissionPlausible = kMissionPlausible
    static let CheerfulAnnoyance = kCheerfulAnnoyance
    static let DrummingSticks = kDrummingSticks
    static let FarmFrolics = kFarmFrolics
    static let FlowingRocks = kFlowingRocks
    static let GameOver = kGameOver
}



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

//ErrorTypes and Validators


