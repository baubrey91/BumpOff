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
    let blue = UIColor.blue
    let red = UIColor.red
    let lrBit : UInt32 = 50
    
    var player = SKSpriteNode()
    var gear = SKSpriteNode()
    var home = SKSpriteNode()
    var continuePlaying = SKSpriteNode()
    var lr = SKSpriteNode()
    
    var disolveEnd = false
    var scoreLabel: SKLabelNode!
    var difficulty:CGFloat = 15
    var timer = Timer()
    var gameSettings = gameStart()
    var level = ""
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        UIApplication.shared.isIdleTimerDisabled = true

        gear = self.childNode(withName: "Gear") as! SKSpriteNode
        home = self.childNode(withName: "Home") as! SKSpriteNode
        continuePlaying = self.childNode(withName: "Continue") as! SKSpriteNode

        home.isHidden = true
        continuePlaying.isHidden = true
        
        createLR()
        
        self.backgroundColor = UIColor.green
        
        player = self.childNode(withName: "player") as! SKSpriteNode

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 250, y: 150)
        scoreLabel.fontColor = UIColor.black
        addChild(scoreLabel)
        
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        manager.startAccelerometerUpdates(to: OperationQueue.main){
            (data, error) in
            
            self.physicsWorld.gravity = CGVector(dx: CGFloat((data?.acceleration.y)!) * self.difficulty, dy: CGFloat((data?.acceleration.x)!) * -self.difficulty)
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var wall: SKSpriteNode
        if (contact.bodyA.collisionBitMask == lrBit || contact.bodyB.collisionBitMask == lrBit){
            self.difficulty =  self.difficulty * -1
            self.backgroundColor = UIColor.purple
            let lr = ((contact.bodyA.collisionBitMask == lrBit) ? contact.bodyA.node : contact.bodyB.node) as! SKSpriteNode
            lr.removeFromParent()
            let delayRun = 5 * Double(NSEC_PER_SEC)
            let timeRun = DispatchTime.now() + Double(Int64(delayRun)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: timeRun) {
                self.difficulty = self.difficulty * -1
                self.backgroundColor = UIColor.green
            }

            self.createLR()
            
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

            var levelComplete = true
            if gameSettings.dissolve == true{
                
                if (player.size.height > 50){
                    player.xScale = player.xScale * 0.95
                    player.yScale = player.yScale * 0.95
                }
                else {
                    home.isHidden = false
                    continuePlaying.isHidden = false
                    disolveEnd = true
                    self.scene!.isPaused = true
                }
            }
            wall.color = (wall.color != blue) ? blue : red
            
       
        enumerateChildNodes(withName: "Wall") {
            node, stop in
            let wall = node as! SKSpriteNode
            if (wall.color != self.blue){
                levelComplete = false
            }
        }
        if (levelComplete){
            
            score = score + 1

            if difficulty > 200 { difficulty = 15 }
            difficulty = difficulty * 1.5
            //difficulty = difficulty * -1
            let delay = 0.5 * Double(NSEC_PER_SEC)
            let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time) {

                self.enumerateChildNodes(withName: "Wall") {
                    node, stop in
                    let wall = node as! SKSpriteNode
                    wall.color = self.red
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if (home.contains(touch.location(in: self)) && home.isHidden == false) {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "StartScreen") as! StartScreen
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            appDelegate.window?.rootViewController = vc
        }
        if continuePlaying.contains(touch.location(in: self)) {
            home.isHidden = true
            continuePlaying.isHidden = true
            self.scene!.isPaused = false
        }
        if (continuePlaying.contains(touch.location(in: self)) && disolveEnd){
            home.isHidden = true
            continuePlaying.isHidden = true
            score = 0
            player.xScale = player.xScale * 3
            player.yScale = player.yScale * 3
            player.position.x = 300
            player.position.y = 300
            self.scene!.isPaused = false

            
        }
        else if gear.contains(touch.location(in: self)) {
            
            home.isHidden = false
            continuePlaying.isHidden = false
            
            self.scene!.isPaused = true

        }
    }
    
    func createLR(){
        let delayReappear = 20 * Double(NSEC_PER_SEC)
        let timeReappear = DispatchTime.now() + Double(Int64(delayReappear)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: timeReappear) {
            
            let xRan = CGFloat(arc4random_uniform(100))
            let yRan = CGFloat(arc4random_uniform(100))
            
            let lr = SKSpriteNode(imageNamed: "LeftRight")
            
            lr.size.height = 200
            lr.size.width = 200
            lr.physicsBody = SKPhysicsBody(rectangleOf: lr.frame.size)
            lr.physicsBody!.isDynamic = false
            lr.physicsBody?.collisionBitMask = self.lrBit
            
            var xPos = ((self.scene?.size.width)!/2 - 50)
            let xPosInt = Int(xPos)
            xPos = CGFloat(xPosInt)
            let yPos = ((self.scene?.size.height)!/2 - 50)
            
            lr.position = CGPoint(x: xPos + xRan, y: yPos + yRan)
            
            self.addChild(lr)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
