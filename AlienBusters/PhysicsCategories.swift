//
//  PhysicsCategories.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/13/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation

//Contact Bitmasks

class PhysicsCategory{
    static let NoCategory: UInt32 = 0       //0b0
    static let Player: UInt32 = 1           //0b1
    static let Enemy: UInt32 = 2            //0b1 << 1
    static let DamagedEnemy: UInt32 = 4     //0b1 << 2
    static let Ground: UInt32 = 8           //0b1 << 3
    static let Animal: UInt32 = 32          //0b1 << 4

}

