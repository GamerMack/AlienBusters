//
//  RandomPoint.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/11/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import GameKit

//Scenario: Multiple enemies spawned at multiple points at regular intervals; uses faster but less random algorithm
// Random Number Generator: GKRandomDistribution
// Random Number Algorithm: GKLinearCongruentialRandomSource

class RandomPoint{
    
    enum AlgorithmType{
        case Faster
        case Slower
        case Average
    }
    
    var randomSource: GKRandomSource
    
    init(algorithmType: AlgorithmType){
        switch(algorithmType){
        case .Faster:
            randomSource = GKLinearCongruentialRandomSource()
        case .Slower:
            randomSource = GKMersenneTwisterRandomSource()
        case .Average:
            randomSource = GKARC4RandomSource()
        }
    }
    
    func getRandomPointInRandomQuadrant() -> CGPoint{
        let distribution = GKRandomDistribution(lowestValue: 0, highestValue: 3)
        let randomScreenSide = distribution.nextInt()
        var randomQuadrantPoint: CGPoint
        
        switch(randomScreenSide){
            case 0:
                randomQuadrantPoint = getLowerLeftQuadrantPoint()
                break
            case 1:
                randomQuadrantPoint = getUpperLeftQuadrantPoint()
                break
            case 2:
                randomQuadrantPoint = getLowerRightQuadrantPoint()
                break
            case 3:
                randomQuadrantPoint = getUpperRightQuadrantPoint()
                break
            default:
                randomQuadrantPoint = getFullScreenPoint()
                break
        }
        
        return randomQuadrantPoint
    }
    
    func getLowerLeftQuadrantPoint() -> CGPoint{
        return getRandomPointWith(minimumXValueOf: -ScreenSizeIntConstants.HalfScreenWidth, andMaximumXValueOf: 0, andWithMinimumYValueOf: -ScreenSizeIntConstants.HalfScreenHeight, andWithMaximumYValueOf: 0)
    }
    
    
    func getLowerRightQuadrantPoint() -> CGPoint{
        return getRandomPointWith(minimumXValueOf: 0, andMaximumXValueOf: ScreenSizeIntConstants.HalfScreenWidth, andWithMinimumYValueOf: -ScreenSizeIntConstants.HalfScreenHeight, andWithMaximumYValueOf: 0)
    }
    
    func getUpperLeftQuadrantPoint() -> CGPoint{
        
        return getRandomPointWith(minimumXValueOf: -ScreenSizeIntConstants.HalfScreenWidth, andMaximumXValueOf: 0, andWithMinimumYValueOf: 0, andWithMaximumYValueOf: ScreenSizeIntConstants.HalfScreenHeight)
    }
    
    func getUpperRightQuadrantPoint() -> CGPoint{
      
        return getRandomPointWith(minimumXValueOf: 0, andMaximumXValueOf: ScreenSizeIntConstants.HalfScreenWidth, andWithMinimumYValueOf: 0, andWithMaximumYValueOf: ScreenSizeIntConstants.HalfScreenHeight)
    }
    
    func getFullScreenPoint() -> CGPoint{
        return getRandomPointWith(minimumXValueOf: -ScreenSizeIntConstants.HalfScreenWidth, andMaximumXValueOf: ScreenSizeIntConstants.HalfScreenWidth, andWithMinimumYValueOf: -ScreenSizeIntConstants.HalfScreenHeight, andWithMaximumYValueOf: ScreenSizeIntConstants.HalfScreenHeight)
    }
    
    
    func getLeftScreenPoint() -> CGPoint{
        return getRandomPointWith(minimumXValueOf: -ScreenSizeIntConstants.HalfScreenWidth, andMaximumXValueOf: 0, andWithMinimumYValueOf: -ScreenSizeIntConstants.HalfScreenHeight, andWithMaximumYValueOf: ScreenSizeIntConstants.HalfScreenHeight)
    }
    
    
    func getRightScreenPoint() -> CGPoint{
        return getRandomPointWith(minimumXValueOf: 0, andMaximumXValueOf: ScreenSizeIntConstants.HalfScreenWidth, andWithMinimumYValueOf: -ScreenSizeIntConstants.HalfScreenHeight, andWithMaximumYValueOf: ScreenSizeIntConstants.HalfScreenHeight)
    }
    
    func getUpperScreenPoint() -> CGPoint{
        return getRandomPointWith(minimumXValueOf: -ScreenSizeIntConstants.HalfScreenWidth, andMaximumXValueOf: ScreenSizeIntConstants.HalfScreenWidth, andWithMinimumYValueOf: 0, andWithMaximumYValueOf: ScreenSizeIntConstants.HalfScreenHeight)
    }
    
    func getLowerScreenPoint() -> CGPoint{
        return getRandomPointWith(minimumXValueOf: -ScreenSizeIntConstants.HalfScreenWidth, andMaximumXValueOf: ScreenSizeIntConstants.HalfScreenWidth, andWithMinimumYValueOf: -ScreenSizeIntConstants.HalfScreenHeight, andWithMaximumYValueOf: 0)
    }
    
    
    private func getRandomPointWith(minimumXValueOf minX: Int, andMaximumXValueOf maxX: Int, andWithMinimumYValueOf minY: Int, andWithMaximumYValueOf maxY: Int) -> CGPoint{
        
        let randomXNumbers = GKRandomDistribution(randomSource: self.randomSource, lowestValue: minX, highestValue: maxX)
        
        let randomYNumbers = GKRandomDistribution(randomSource: self.randomSource, lowestValue: minY, highestValue: maxY)
        
        let xPos = randomXNumbers.nextInt()
        let yPos = randomYNumbers.nextInt()
        
        return CGPoint(x: xPos, y: yPos)
        
    }
    
   
    
    
}

class RandomGaussianPoint: RandomPoint{
    
    
    
    override func getFullScreenPoint() -> CGPoint {
        return getRandomPointClusteredNear(xCoordinate: 0, yCoordinate: 0, withXSpreadOf: Float(ScreenSizeFloatConstants.HalfScreenWidth), andWithYSpreadOf: Float(ScreenSizeFloatConstants.HalfScreenHeight))
    }
    
    
  
   
    override func getLeftScreenPoint() -> CGPoint {
        return getRandomPointClusteredNear(xCoordinate: -Float(2*ScreenSizeFloatConstants.HalfScreenHeight/3), yCoordinate: 0, withXSpreadOf: Float(ScreenSizeFloatConstants.HalfScreenHeight)/Float(10.0) , andWithYSpreadOf: Float(ScreenSizeFloatConstants.HalfScreenWidth/5.0))
        
        
    }
    
    
    override func getRightScreenPoint() -> CGPoint {
        return getRandomPointClusteredNear(xCoordinate: Float(2*ScreenSizeFloatConstants.HalfScreenHeight/3), yCoordinate: 0, withXSpreadOf: Float(ScreenSizeFloatConstants.HalfScreenHeight)/Float(10.0) , andWithYSpreadOf: Float(ScreenSizeFloatConstants.HalfScreenWidth/5.0))
        
        
    }
    
    override func getUpperScreenPoint() -> CGPoint {
        return getRandomPointClusteredNear(xCoordinate: 0, yCoordinate: Float(ScreenSizeFloatConstants.HalfScreenHeight/2), withXSpreadOf: Float(ScreenSizeFloatConstants.HalfScreenWidth/5.0), andWithYSpreadOf: Float(ScreenSizeFloatConstants.HalfScreenHeight)/Float(10.0))
    }
    
    override func getLowerScreenPoint() -> CGPoint {
          return getRandomPointClusteredNear(xCoordinate: 0, yCoordinate: -Float(ScreenSizeFloatConstants.HalfScreenHeight/2), withXSpreadOf: Float(ScreenSizeFloatConstants.HalfScreenWidth/5.0), andWithYSpreadOf: Float(ScreenSizeFloatConstants.HalfScreenHeight)/Float(10.0))
    }
    
    override func getLowerRightQuadrantPoint() -> CGPoint {
         return getRandomPointClusteredNear(xCoordinate: Float(ScreenSizeFloatConstants.HalfScreenWidth/2.0), yCoordinate: -Float(ScreenSizeFloatConstants.HalfScreenHeight/2.0), withXSpreadOf: Float(ScreenSizeFloatConstants.HalfScreenWidth)/Float(10.0), andWithYSpreadOf: Float(ScreenSizeFloatConstants.HalfScreenHeight)/Float(10.0))
    }
    
    override func getUpperLeftQuadrantPoint() -> CGPoint {
         return getRandomPointClusteredNear(xCoordinate: -Float(ScreenSizeFloatConstants.HalfScreenWidth/2.0), yCoordinate: Float(ScreenSizeFloatConstants.HalfScreenHeight/2), withXSpreadOf: Float(ScreenSizeFloatConstants.HalfScreenWidth)/Float(10.0), andWithYSpreadOf: Float(ScreenSizeFloatConstants.HalfScreenHeight)/Float(10.0))
    }
    
    override func getLowerLeftQuadrantPoint() -> CGPoint {
        return getRandomPointClusteredNear(xCoordinate: -Float(ScreenSizeFloatConstants.HalfScreenWidth/2.0), yCoordinate: -Float(ScreenSizeFloatConstants.HalfScreenHeight/2), withXSpreadOf: Float(ScreenSizeFloatConstants.HalfScreenWidth)/Float(10.0), andWithYSpreadOf: Float(ScreenSizeFloatConstants.HalfScreenHeight)/Float(10.0))
    }
    
    override func getUpperRightQuadrantPoint() -> CGPoint {
        return getRandomPointClusteredNear(xCoordinate: Float(ScreenSizeFloatConstants.HalfScreenWidth/2.0), yCoordinate: Float(ScreenSizeFloatConstants.HalfScreenHeight/2), withXSpreadOf: Float(ScreenSizeFloatConstants.HalfScreenWidth)/Float(10.0), andWithYSpreadOf: Float(ScreenSizeFloatConstants.HalfScreenHeight)/Float(10.0))
    }
    
    private func getRandomPointClusteredNear(xCoordinate: Float, yCoordinate: Float, withXSpreadOf deviationX: Float, andWithYSpreadOf deviationY: Float) -> CGPoint{
        
        let gaussianDistributionX = GKGaussianDistribution(randomSource: self.randomSource, mean: xCoordinate, deviation: deviationX)
        
        let gaussianDistributionY = GKGaussianDistribution(randomSource: self.randomSource, mean: yCoordinate, deviation: deviationY)
        
        let xPos = gaussianDistributionX.nextInt()
        let yPos = gaussianDistributionY.nextInt()
        
        
        return CGPoint(x: xPos, y: yPos)
        
    }
}

//Scenario: Single enemy is spawned at regular intervals at random points; uses slower but more random algorithm
// Random Number Generator: GKRandomDistribution
//Random Number Algorithm: GKMersenneTwisterRandomSource

let randomSource2 = GKMersenneTwisterRandomSource()
