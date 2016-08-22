//
//  GameScene.swift
//  bumpOff
//
//  Created by Brandon Aubrey on 6/24/16.
//  Copyright (c) 2016 Brandon Aubrey. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    let manager = CMMotionManager()
    let blue = UIColor.blueColor()
    let red = UIColor.redColor()
    var player = SKSpriteNode()
    var scoreLabel: SKLabelNode!
    var difficulty:CGFloat = 15
    var timer = NSTimer()
    var gameSettings = gameStart()
    var level = ""
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        player = self.childNodeWithName("player") as! SKSpriteNode

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .Right
        scoreLabel.position = CGPoint(x: 250, y: 150)
        addChild(scoreLabel)
        
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        manager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()){
            (data, error) in
            
            self.physicsWorld.gravity = CGVectorMake(CGFloat((data?.acceleration.y)!) * self.difficulty, CGFloat((data?.acceleration.x)!) * -self.difficulty)
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var wall: SKSpriteNode
        //var player : SKSpriteNode
        if (contact.bodyA.node?.name == "LR" || contact.bodyB.node?.name == "LR"){
            self.difficulty =  self.difficulty * -1
            let lr = ((contact.bodyA.node?.name == "LR") ? contact.bodyA.node : contact.bodyB.node) as! SKSpriteNode
            lr.removeFromParent()
            let delay = 5 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.difficulty = self.difficulty * -1
            }
            
        }
        else {
            if (contact.bodyA.node?.name == "Wall"){
                wall = contact.bodyA.node as! SKSpriteNode
                player = contact.bodyB.node as! SKSpriteNode
            }
            else {
                wall = contact.bodyB.node as! SKSpriteNode
                player = contact.bodyA.node as! SKSpriteNode


            }
        /*if contact.bodyA.node?.name == "Wall"{
            let wall = contact.bodyA.node as! SKSpriteNode
        }
        else {
            let wall = contact.bodyB.node as! SKSpriteNode
        }*/
            var levelComplete = true
            if gameSettings.dissolve == true{

                if (player.size.height > 50){
                    player.xScale = player.xScale * 0.95
                    player.yScale = player.yScale * 0.95
                }
                else {
                    self.physicsBody?.affectedByGravity = false
                    self.difficulty = 0
                    print("game over")
                    // go to main screen
                }
            }
            wall.color = (wall.color != blue) ? blue : red
            
       
        enumerateChildNodesWithName("Wall") {
            node, stop in
            let wall = node as! SKSpriteNode
            if (wall.color != self.blue){
                levelComplete = false
            }
        }
        if (levelComplete){
            
            score = score + 1

            if difficulty > 250 { difficulty = 15 }
            difficulty = difficulty * 1.5
            //difficulty = difficulty * -1
            let delay = 0.5 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {

                self.enumerateChildNodesWithName("Wall") {
                    node, stop in
                    let wall = node as! SKSpriteNode
                    wall.color = self.red
                    }
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
