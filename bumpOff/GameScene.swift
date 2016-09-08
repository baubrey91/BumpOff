//
//  GameScene.swift
//  bumpOff
//
//  Created by Brandon Aubrey on 6/24/16.
//  Copyright (c) 2016 Brandon Aubrey. All rights reserved.
//

import SpriteKit
import UIKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    let manager = CMMotionManager()
    let blue = UIColor.blueColor()
    let red = UIColor.redColor()
    var player = SKSpriteNode()
    var gear = SKSpriteNode()
    var home = SKSpriteNode()
    var continuePlaying = SKSpriteNode()

    var disolveEnd = false
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
        
        gear = self.childNodeWithName("Gear") as! SKSpriteNode
        home = self.childNodeWithName("Home") as! SKSpriteNode
        continuePlaying = self.childNodeWithName("Continue") as! SKSpriteNode

        home.hidden = true
        continuePlaying.hidden = true
        
        self.backgroundColor = UIColor.greenColor()
        
        player = self.childNodeWithName("player") as! SKSpriteNode

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .Right
        scoreLabel.position = CGPoint(x: 250, y: 150)
        scoreLabel.color = UIColor.blackColor()
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
            self.backgroundColor = UIColor.purpleColor()
            let lr = ((contact.bodyA.node?.name == "LR") ? contact.bodyA.node : contact.bodyB.node) as! SKSpriteNode
            lr.removeFromParent()
            let delay = 5 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.difficulty = self.difficulty * -1
                self.backgroundColor = UIColor.greenColor()
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
                    home.hidden = false
                    continuePlaying.hidden = false
                    disolveEnd = true
                    self.scene!.paused = true
                    
                    
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        
        if (home.containsPoint(touch.locationInNode(self)) && home.hidden == false) {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("StartScreen") as! StartScreen
            let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            appDelegate.window?.rootViewController = vc
        }
        if continuePlaying.containsPoint(touch.locationInNode(self)) {
            home.hidden = true
            continuePlaying.hidden = true
            self.scene!.paused = false
        }
        if (continuePlaying.containsPoint(touch.locationInNode(self)) && disolveEnd){
            home.hidden = true
            continuePlaying.hidden = true
            score = 0
            player.xScale = player.xScale * 3
            player.yScale = player.yScale * 3
            player.position.x = 300
            player.position.y = 300
            self.scene!.paused = false

            
        }
        else if gear.containsPoint(touch.locationInNode(self)) {
            home.hidden = false
            continuePlaying.hidden = false
            
            self.scene!.paused = true
            //self.scene!.view!.paused = true

        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
