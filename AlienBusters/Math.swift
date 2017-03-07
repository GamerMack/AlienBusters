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


typealias NumberUnit = Double

func DegreesToRadians(angleInDegrees: NumberUnit) -> NumberUnit{
    return angleInDegrees*(M_PI/180.0)
}

func RadiansToDegrees(angleInRadians: NumberUnit) -> NumberUnit{
    return angleInRadians*(180.0/M_PI)
}

func Smooth(startPoint: NumberUnit, endPoint: NumberUnit, percentToMove: NumberUnit) -> NumberUnit{
    return (startPoint*(1-percentToMove) + endPoint*percentToMove)
}

func AngleBetweenPoints(targetPosition: CGPoint, currentPosition: CGPoint) -> NumberUnit{
    let deltaX = targetPosition.x - currentPosition.x
    let deltaY = targetPosition.y - currentPosition.y
    
    return NumberUnit((atan2(deltaY, deltaX))) - DegreesToRadians(angleInDegrees: 90)
}

func DistanceBetweenPoints(firstPoint: CGPoint, secondPoint: CGPoint) -> NumberUnit{
    return NumberUnit(hypot(secondPoint.x - firstPoint.x, secondPoint.y - firstPoint.y))
}

