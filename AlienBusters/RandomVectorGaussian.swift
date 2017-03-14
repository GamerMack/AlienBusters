//
//  RandomVectorGaussian.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/13/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit




class RandomVectorGaussian: RandomVectorUniform{
    
    override func getRandomVectorBetween(xMinOf xMin: Int, andXMaxOf xMax: Int, andBetweenYMinOf yMin: Int, yMaxOf yMax: Int) -> CGVector {
        
        let randomDistributionX = GKGaussianDistribution(randomSource: self.randomSource, lowestValue: xMin, highestValue: xMax)
        
        let randomDistributionY = GKGaussianDistribution(randomSource: self.randomSource, lowestValue: yMin, highestValue: yMax)
        
        let xComponent = randomDistributionX.nextInt()
        let yComponent = randomDistributionY.nextInt()
        
        return CGVector(dx: xComponent, dy: yComponent)
    }
    
    func getRandomVectorWith(xMeanOf meanXValue: Float, andXVarianceOf xVariance: Float, andWithYMeanValueOf meanYValue: Float, yVariance: Float) -> CGVector{
        
        let randomDistributionX = GKGaussianDistribution(randomSource: self.randomSource, mean: meanXValue, deviation: xVariance)
        
        let randomDistributionY = GKGaussianDistribution(randomSource: self.randomSource, mean: meanYValue, deviation: yVariance)
        
        let xComponent = randomDistributionX.nextInt()
        let yComponent = randomDistributionY.nextInt()
        
        return CGVector(dx: xComponent, dy: yComponent)
    }
    
}
