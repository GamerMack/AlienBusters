//
//  Math.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/7/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

/** Code for demonstration purpose only

protocol Character{
    var abilityLevel: Int { get set }
}

    protocol Hero: Character{
        var abilityLevel: Int { get set }
    }

    protocol AlphaHero: Hero{
        var abilityLevel: Int { get set }
    }

    protocol BetaHero: Hero{
        var abilityLevel: Int { get set }
    }


    protocol OmegaHero: Hero{
        var abilityLevel: Int { get set }
    }

protocol Villain{
    var abilityLevel: Int { get set }
}

    protocol AlphaVillain{
        var abilityLevel: Int { get set }

    }

    protocol BetaVillain{
        var abilityLevel: Int { get set }

    }

    protocol OmegaVillain{
        var abilityLevel: Int { get set }
    }

class WereWolf: Villain{
    var abilityLevel: Int = 5
}

class Vampire: Villain{
    var abilityLevel: Int = 0
}


func createMatchTypeA<C1: Hero, C2: Villain>(forParentNode: SKNode, withHeroOf hero: C1, andWithVillainOf villain: C2) where C1: AlphaHero, C2: OmegaVillain{
    
}

func createMatchTypeA(forParentNode: SKNode, withHeroOf hero: AlphaHero, andWithVillainOf villain: OmegaVillain){
    
}

func createMatch<C1: Character, C2: Character>(forParentNode: SKNode, withPlayerCharacterOf player: C1, andWithVillainOf villain: C2) where C1: Hero, C2: Villain {
    
}

func createMatchA(forParentNode: SKNode, withPlayerCharacterOf plyaer: Hero, andWithVillainCharacterOf villain: Villain){
    
}

func spawnVillains<V: Villain>(forParentNode parent: SKNode, fromVillains villains: V...){
    
    for villain in villains{
        parent.addChild(villain as! SKNode)
    }
}


**/




typealias NumberUnit = CGFloat

func DegreesToRadians(angleInDegrees: NumberUnit) -> NumberUnit{
    return angleInDegrees*CGFloat(M_PI/180.0)
}

func RadiansToDegrees(angleInRadians: NumberUnit) -> NumberUnit{
    return angleInRadians*CGFloat(180.0/M_PI)
}

func Smooth(startPoint: NumberUnit, endPoint: NumberUnit, percentToMove: NumberUnit) -> NumberUnit{
    return (startPoint*(1-percentToMove) + endPoint*percentToMove)
}

func AngleBetweenPoints(targetPosition: CGPoint, currentPosition: CGPoint) -> NumberUnit{
    let deltaX = targetPosition.x - currentPosition.x
    let deltaY = targetPosition.y - currentPosition.y
    
    return (NumberUnit((atan2(deltaY, deltaX))) - NumberUnit(M_PI/2))
}

func DistanceBetweenPoints(firstPoint: CGPoint, secondPoint: CGPoint) -> NumberUnit{
    return NumberUnit(hypot(secondPoint.x - firstPoint.x, secondPoint.y - firstPoint.y))
}

func RandomIntegerBetween(min: Int, max: Int) -> Int{
    return Int(UInt32(min) + arc4random_uniform(UInt32(max-min+1)))
}

func RandomFloatRange(min: CGFloat, max: CGFloat) -> CGFloat{
    return CGFloat(Float(arc4random()/0xFFFFFFFF))*(max-min) + min
}

func RandomizeSign(coordinateValue: inout Int){
    
    let coinFlip = Int(arc4random_uniform(2))
    
    coordinateValue = coinFlip == 1 ? -coordinateValue: coordinateValue
}


