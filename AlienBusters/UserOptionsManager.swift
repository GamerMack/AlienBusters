//
//  UserOptionsManager.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


import Foundation
import SpriteKit

class UserOptionsManager{
    
    static let sharedInstance = UserOptionsManager()
    
    
    enum GamePlaySettings{
        case DifficultyLevel
        case GamePlayMode
    }
    
    
    private var userChoiceDict = [GamePlaySettings:String]()
    
    
    func getDifficultyLevel() -> String{
        return userChoiceDict[GamePlaySettings.DifficultyLevel]!
    }
    
    func setDifficultyLevel(userSelection: String){
        userChoiceDict[GamePlaySettings.DifficultyLevel] = userSelection
    }
    
    
    private init(){
    }
    
    
    
}
