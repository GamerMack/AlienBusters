//
//  TestScene3.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

class TestScene3: TimeLimitScene{
    
    var circleNodes = [SKShapeNode]()
    var ellipseNodes = [SKShapeNode]()
    var boxNodes = [SKShapeNode]()
    var rectangleNodes = [SKShapeNode]()
    
    let randomPointGenerator = RandomPoint(algorithmType: .Slower)
    let randomGaussianPointGenerator = RandomGaussianPoint(algorithmType: .Slower)
    
    override func didMove(to view: SKView) {
        //Set the current scene anchor point to (0.5,0.5)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //Configure background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: BackgroundMusic.MissionPlausible, forParentNode: self)
        
        loadBoxNodes(numberOfBoxNodes: 20)
        loadCircleNodes(numberOfCircleNodes: 20)
        loadEllipseNodes(numberOfEllipseNodes: 20)
        loadRectangeleNodes(numberOfRectangles: 5)
        
        
        //TESTS USING GK RANDOM GAUSSIAN DISTRIBUTION
        
        //Full Screen
        
        /**
        for circle in circleNodes{
            let point = randomGaussianPointGenerator.getFullScreenPoint()
            circle.position = point
            self.addChild(circle)
        }
        
        
        for box in boxNodes{
            let point = randomGaussianPointGenerator.getFullScreenPoint()
            box.position = point
            self.addChild(box)
        }
        
        **/
        
        /** Left and Right Sides of Screen 
         
        //Left Screen
        
        for circle in circleNodes{
            let point = randomGaussianPointGenerator.getLeftScreenPoint()
            circle.position = point
            self.addChild(circle)
        }
        
        //Right Screen
        
        for box in boxNodes{
            let point = randomGaussianPointGenerator.getRightScreenPoint()
            box.position = point
            self.addChild(box)
        }
        
        **/
        
        /**
        
        //Upper Screen
        
        for circle in circleNodes{
            let point = randomGaussianPointGenerator.getUpperScreenPoint()
            circle.position = point
            self.addChild(circle)
        }
        
        //Lower Screen
        
        for box in boxNodes{
            let point = randomGaussianPointGenerator.getLowerScreenPoint()
            box.position = point
            self.addChild(box)
        }
        
        
        **/
        
        
        /**
        //Lower left quadrant
        
        for circle in circleNodes{
            let point = randomGaussianPointGenerator.getLowerLeftQuadrantPoint()
            circle.position = point
            self.addChild(circle)
        }
        
        
        //Lower right quadrant
        
        for box in boxNodes{
            let point = randomGaussianPointGenerator.getLowerRightQuadrantPoint()
            box.position = point
            self.addChild(box)
        }
        
        //Upper right quadrant 
        
        for ellipse in ellipseNodes{
            let point = randomGaussianPointGenerator.getUpperRightQuadrantPoint()
            ellipse.position = point
            self.addChild(ellipse)
        }
        
        //Upper left quadrant
        
        for rectangle in rectangleNodes{
            let point = randomGaussianPointGenerator.getUpperLeftQuadrantPoint()
            rectangle.position = point
            self.addChild(rectangle)
        }
        **/
        
        
        //TESTS USING GKRANDOM DISTRIBUTION
        
        /** Tests for the Quadrant Methods
 
        //CircleNodes are adde to the lower left quadrant
        for circleNode in circleNodes{
            let randomPoint = randomPointGenerator.getLowerLeftQuadrantPoint()
            
            circleNode.position = randomPoint
            self.addChild(circleNode)
            
        }
        
        //EllipseNodes are added to the lower right quadrant
        for ellipseNode in ellipseNodes{
            
            let randomPoint = randomPointGenerator.getLowerRightQuadrantPoint()
            
            ellipseNode.position = randomPoint
            self.addChild(ellipseNode)
        }
        
        
        //BoxNodes are added to the upper left quadrant
        for boxNode in boxNodes{
            
            let randomPoint = randomPointGenerator.getUpperLeftQuadrantPoint()
            boxNode.position = randomPoint
            self.addChild(boxNode)
        }
        
        //RectangleNodes are added to the upper right quadrant
        for rectangleNode in rectangleNodes{
            let randomPoint = randomPointGenerator.getUpperRightQuadrantPoint()
            rectangleNode.position = randomPoint
            self.addChild(rectangleNode)
        }
 
        **/
        
        /** Tests for Left and Right Side Point Generation Methods
 
        for circle in circleNodes{
            let randomPoint = randomPointGenerator.getLeftScreenPoint()
            circle.position = randomPoint
            self.addChild(circle)
        }
        
        for box in boxNodes{
            let randomPoint = randomPointGenerator.getRightScreenPoint()
            box.position = randomPoint
            self.addChild(box)
        }
 
        **/
        
        /** Tests for Upper and Lower Point Generation
 
        for circle in circleNodes{
            let randomPoint = randomPointGenerator.getUpperScreenPoint()
            circle.position = randomPoint
        
            self.addChild(circle)
        }
        
        for box in boxNodes{
            let randomPoint = randomPointGenerator.getLowerScreenPoint()
            box.position = randomPoint
            self.addChild(box)
        }
 
         **/
        
        
        /** Random Points in FullScreen Range
        
        for circle in circleNodes{
            let randomPoint = randomPointGenerator.getFullScreenPoint()
            circle.position = randomPoint
            circle.alpha = 0.8
            circle.blendMode = .add
            self.addChild(circle)
        }
        
        for box in boxNodes{
            let randomPoint = randomPointGenerator.getFullScreenPoint()
            box.position = randomPoint
            box.alpha = 0.8
            box.blendMode = .add
            self.addChild(box)
        }
        
        for ellipse in ellipseNodes{
            let randomPoint = randomPointGenerator.getFullScreenPoint()
            ellipse.position = randomPoint
            ellipse.blendMode = .add
            ellipse.alpha = 0.8
            self.addChild(ellipse)
        }
         **/
        
    }
    
    //MARK: Game Loop Functions
    
    override func update(_ currentTime: TimeInterval) {
        
        
    }
    
    
    override func didSimulatePhysics() {
        
    }
    
    
    //MARK: Handlers for User Input
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    private func loadCircleNodes(numberOfCircleNodes: Int){
    
        for _ in 0..<numberOfCircleNodes {
            
            let randomRadius = Int(arc4random_uniform(UInt32(21))) + 20
            
            let circleNode = SKShapeNode(circleOfRadius: CGFloat(randomRadius))
            
            circleNode.fillColor = SKColor.purple
            circleNode.strokeColor = SKColor.yellow
            
            
            circleNodes.append(circleNode)
        }
    }
    
    private func loadBoxNodes(numberOfBoxNodes: Int){

        for _ in 0..<numberOfBoxNodes{
            let randomBoxLength = Int(arc4random_uniform(UInt32(11))) + 20
            let cgSize = CGSize(width: randomBoxLength, height: randomBoxLength)
            let boxNode = SKShapeNode(rectOf: cgSize)
            boxNode.fillColor = SKColor.green
            boxNode.strokeColor = SKColor.orange
            
            boxNodes.append(boxNode)
        }
    }
    
    
    private func loadEllipseNodes(numberOfEllipseNodes: Int){
        for _ in 0..<numberOfEllipseNodes{
            
            let randomEllipseLength = Int(arc4random_uniform(UInt32(20))) + 30
            let randomEllipseHeight = Int(arc4random_uniform(UInt32(20))) + 10
            
            let ellipseSize = CGSize(width: randomEllipseLength, height: randomEllipseHeight)
            let ellipseNode = SKShapeNode(ellipseOf: ellipseSize)
            
            ellipseNode.fillColor = SKColor.cyan
            ellipseNode.strokeColor = SKColor.red
            
            ellipseNodes.append(ellipseNode)
        }
    }
    
    private func loadRectangeleNodes(numberOfRectangles: Int){
        
        for _ in 0..<numberOfRectangles{
            let randomLength = Int(arc4random_uniform(UInt32(20))) + 20
            let randomHeight = Int(arc4random_uniform(UInt32(20))) + 1
            
            let rectangleSize = CGSize(width: randomLength, height: randomHeight)
            
            let rectangleNode = SKShapeNode(rectOf: rectangleSize)
            rectangleNode.fillColor = SKColor.gray
            rectangleNode.strokeColor = SKColor.black
            
            rectangleNodes.append(rectangleNode)
        }
    }
    
}
