//
//  RandomVector.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/11/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

struct RandomVectorConfiguration{
    var minVectorX: Double = 0.00
    var maxVectorX: Double = 0.00
    var minVectorY: Double = 0.00
    var maxVectorY: Double = 0.00
    
    init(){
        minVectorX = 0.00
        maxVectorX = 0.00
        
        minVectorY = 0.00
        maxVectorY = 0.00
        
    }
    
    init(minimumVectorYComponent: Double, maximumVectorYComponent: Double, minimumVectorXComponent: Double, maximumVectorXComponent: Double) {
        
        minVectorX = minimumVectorXComponent
        maxVectorX = maximumVectorXComponent
        
        minVectorY = minimumVectorYComponent
        maxVectorY = maximumVectorYComponent
    }
}


struct RandomVector{
    var xComponent: Double
    var yComponent: Double
    
    init(){
        xComponent = 0.00
        yComponent = 0.00
    }
    
    init(yComponentMin: Double, yComponentMax: Double,xComponentMin: Double, xComponentMax: Double) {
        
        xComponent = Double(arc4random_uniform(UInt32(xComponentMax-xComponentMax))) + xComponentMin
        
        yComponent = Double(arc4random_uniform(UInt32(yComponentMax-yComponentMin))) + yComponentMin
        
    }
    
    init(randomVectorConfiguration: RandomVectorConfiguration){
        self.init()
        
        let minX = randomVectorConfiguration.minVectorX
        let maxX = randomVectorConfiguration.maxVectorX
        
        let minY = randomVectorConfiguration.minVectorY
        let maxY = randomVectorConfiguration.maxVectorY
        
        xComponent = Double(arc4random_uniform(UInt32(maxX-minX))) + minX
        yComponent = Double(arc4random_uniform(UInt32(maxY-minY))) + minY
    }
    
    mutating func randomizeXComponentSign(){
        let coinFlip = Int(arc4random_uniform(UInt32(2.0)))
        
        xComponent = coinFlip == 1 ? xComponent: -xComponent
    }
    
    mutating func randomizeYComponentSign(){
        let coinFlip = Int(arc4random_uniform(UInt32(2.0)))
        
        yComponent = coinFlip == 1 ? yComponent: -yComponent
    }
    
    mutating func randomizeXComponent(withMinValueOf minValue: Double, andMaxValueOf maxValue: Double){
        
        xComponent = Double(arc4random_uniform(UInt32(maxValue-minValue))) + minValue
        
    }
    
    mutating func randomizeYComponent(withMinValueOf minValue: Double, andMaxValueOf maxValue: Double){
        
        yComponent = Double(arc4random_uniform(UInt32(maxValue-minValue))) + minValue
    }
    
    mutating func randomizeVector(withMinYValueOf minYValue: Double, andMaxYValueOf maxYValue: Double, andWithMinXValueOf minXValue: Double, andWithMaxXValueOf maxXValue: Double){
        
        randomizeXComponent(withMinValueOf: minXValue, andMaxValueOf: maxXValue)
        randomizeYComponent(withMinValueOf: minYValue, andMaxValueOf: maxYValue)
    }
    
    
    func getVector() -> CGVector{
        return CGVector(dx: xComponent, dy: yComponent)
    }
    
    func getXComponent() -> Double{
        return xComponent
    }
    
    func getYComponent() -> Double{
        return yComponent
    }
    
}

extension RandomVector{
    static func randomizeVectorSigns(forSomeRandomVector someRandomVector: inout RandomVector){
        someRandomVector.randomizeXComponentSign()
        someRandomVector.randomizeYComponentSign()
    }
    
    static func randomizeXComponent(forSomeRandomVector someRandomVector: inout RandomVector, withMinValueOf minValue: Double, andWithMaxValueOf maxValue: Double){
        someRandomVector.randomizeXComponent(withMinValueOf: minValue, andMaxValueOf: maxValue)
        
    }
    
    static func randomizeYComponent(forSomeRandomVector someRandomVector: inout RandomVector, withMinValueOf minValue: Double, andWithMaxValueOf maxValue: Double){
        someRandomVector.randomizeYComponent(withMinValueOf: minValue, andMaxValueOf: maxValue)
    }
}
