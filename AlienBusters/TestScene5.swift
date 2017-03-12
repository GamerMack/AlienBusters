//
//  TestScene5.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


class TestScene5: TimeLimitScene{
    
    var player = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        //Configure background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: BackgroundMusic.CheerfulAnnoyance, forParentNode: self)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let playerRadius = CGFloat(20.0)
        
        let shapeNode = SKShapeNode(circleOfRadius: playerRadius)
        shapeNode.fillColor = SKColor.yellow
        shapeNode.strokeColor = SKColor.purple
        
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.position = CGPoint.zero
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: playerRadius)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.velocity = CGVector.zero
        
        player.addChild(shapeNode)
        
        
        self.addChild(player)
        
        
        
    }
    
    //MARK: Game Loop Functions  
    
    override func didSimulatePhysics() {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    //MARK: User input handlers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        setRandomPlayerVelocityX()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    private func setRandomPlayerVelocity(){
        var randomVector = RandomVector()
        randomVector.randomizeVector(withMinYValueOf: -30, andMaxYValueOf: 30, andWithMinXValueOf: -30, andWithMaxXValueOf: 30)
        
        let playerRandomVector = randomVector.getVector()
        player.physicsBody?.velocity = playerRandomVector
        
        print("The X Component of the Player's Velocity Vector is: \(playerRandomVector.dx)")
        print("The Y Compoenent of the Player's Velocity Vector is: \(playerRandomVector.dy)")
    }
    
    private func setRandomPlayerVelocityY(){
        var randomVector = RandomVector(yComponentMin: 20, yComponentMax: 50, xComponentMin: 0, xComponentMax: 0)
        
        randomVector.randomizeYComponentSign()
        
        player.physicsBody?.velocity = randomVector.getVector()
        
        print("The X Component of the player's velocity is: \(randomVector.getXComponent())")
        print("The Y Component of the player's velocity is: \(randomVector.getYComponent())")
        
    }
    
    private func setRandomPlayerVelocityX(){
        var randomVector = RandomVector(yComponentMin: 0, yComponentMax: 0, xComponentMin: 40, xComponentMax: 60)
        
        randomVector.randomizeXComponentSign()
        
        player.physicsBody?.velocity = randomVector.getVector()
        
        print("The X Component of the player's velocity is: \(randomVector.getXComponent())")
        print("The Y Component of the player's velocity is: \(randomVector.getYComponent())")
        
    }
    
    
    
    
}
