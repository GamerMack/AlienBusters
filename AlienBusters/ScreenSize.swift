//
//  ScreenSize.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/13/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

//Constants related to Screen Size Dimensions

let kViewSize = UIScreen.main.bounds
let kViewWidth = kViewSize.width
let kViewHeight = kViewSize.height

class ScreenSizeIntConstants{
    static let ScreenSize = UIScreen.main.bounds
    static let ScreenWidth = Int(UIScreen.main.bounds.width)
    static let ScrrenHeight = Int(UIScreen.main.bounds.height)
    static let HalfScreenHeight = Int(UIScreen.main.bounds.height/2)
    static let HalfScreenWidth = Int(UIScreen.main.bounds.width/2)
}

class ScreenSizeFloatConstants{
    static let ScreenSize = UIScreen.main.bounds
    static let ScreenWidth = UIScreen.main.bounds.width
    static let ScrrenHeight = UIScreen.main.bounds.height
    static let HalfScreenHeight = UIScreen.main.bounds.height/2
    static let HalfScreenWidth = UIScreen.main.bounds.width/2
}
