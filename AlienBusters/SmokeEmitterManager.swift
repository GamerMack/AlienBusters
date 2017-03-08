//
//  SmokeEmitterManager.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/8/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


import Foundation
import SpriteKit





class SmokeEmitterManager{
    
    static let sharedInstance = SmokeEmitterManager()
    
    //MARK: Enum for Different Engine States
    enum EngineState{
        case LowFuel
        case NormalRunning
        case Accelerated
    }
    
    
    
    //MARK: Private class variables
    private var regularEmitter = SKEmitterNode()
    private var lowFuelEmitter = SKEmitterNode()
    private var acceleratedEmitter = SKEmitterNode()
    
    init(){
        setupSmokeEmitters()
        
    }
    
    
    func createSmokeEmitterFor(engineState: EngineState) -> SKEmitterNode{
        switch(engineState){
        case .LowFuel:
            return lowFuelEmitter.copy() as! SKEmitterNode
        case .NormalRunning:
            return regularEmitter.copy() as! SKEmitterNode
        case .Accelerated:
            return acceleratedEmitter.copy() as! SKEmitterNode
        }
        
    }
    
    private func setupSmokeEmitters(){
        configureEmitter(emitterNode: regularEmitter, birthRate: 20, lifetime: 30, liftetimeRange: 0, particleScale: 0.5, particleScaleRange: 0.3, emissionAngle: 270, emissionAngleRange: 50, speed: 100, speedRange: 40)
        
        configureEmitter(emitterNode: lowFuelEmitter, birthRate: 50, lifetime: 30, liftetimeRange: 0, particleScale: 0.5, particleScaleRange: 0.3, emissionAngle: 270, emissionAngleRange: 50, speed: 200, speedRange: 40)
        
        configureEmitter(emitterNode: acceleratedEmitter, birthRate: 10, lifetime: 20, liftetimeRange: 0, particleScale: 0.5, particleScaleRange: 0.3, emissionAngle: 270, emissionAngleRange: 50, speed: 100, speedRange: 40)
    }
    
    
    
    private func configureEmitter(emitterNode: SKEmitterNode, birthRate: CGFloat, lifetime: CGFloat, liftetimeRange: CGFloat, particleScale: CGFloat, particleScaleRange: CGFloat, emissionAngle: CGFloat, emissionAngleRange: CGFloat, speed: CGFloat, speedRange: CGFloat){
        
        //Particle birthrate settings
        emitterNode.particleBirthRate = birthRate
        
        //Particle lifetime settings
        emitterNode.particleLifetimeRange = liftetimeRange
        emitterNode.particleLifetime = lifetime
        
        //Particle scale settings
        emitterNode.particleScale = particleScale
        emitterNode.particleScaleRange = particleScaleRange
        
        //Particle angle and angle range settings
        emitterNode.emissionAngle = emissionAngle
        emitterNode.emissionAngleRange = emissionAngleRange
        
        //Particle speed and speed range settings
        emitterNode.particleSpeed = speed
        emitterNode.particleSpeedRange = speedRange
        
    }
    
    
}
