//
//  RandomVectorUniform.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/13/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class RandomVectorUniform{
    
    enum AlgorithmType{
        case Faster
        case Average
        case Slower
    }
    
    let randomSource: GKRandomSource
    
    init(algorithmType: AlgorithmType){
        switch(algorithmType){
            case .Faster:
                randomSource = GKLinearCongruentialRandomSource()
                break
            case .Average:
                randomSource = GKRandomSource()
                break
            case .Slower:
                randomSource = GKMersenneTwisterRandomSource()
                break
        }
    }
    
    func getRandomVectorBetween(xMinOf xMin: Int, andXMaxOf xMax: Int, andBetweenYMinOf yMin: Int, yMaxOf yMax: Int) -> CGVector{
        
        let randomDistributionXComponent = GKRandomDistribution(randomSource: self.randomSource, lowestValue: xMin, highestValue: xMax)
        
        let randomDistributionYComponent = GKRandomDistribution(randomSource: self.randomSource, lowestValue: yMin, highestValue: yMax)
        
        let xComponent = randomDistributionXComponent.nextInt()
        let yComponent = randomDistributionYComponent.nextInt()
        
        return CGVector(dx: xComponent, dy: yComponent)
    }
    
    
}
