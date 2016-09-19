//
//  GameViewController.swift
//  bumpOff
//
//  Created by Brandon Aubrey on 6/24/16.
//  Copyright (c) 2016 Brandon Aubrey. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var gameSettings = gameStart()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var levelNumber:Int
        var level:String

        levelNumber = (gameSettings.level != nil) ? gameSettings.level! : 0
        
        switch(levelNumber){
        case 1:
            level = "Level2"
        case 2:
            level = "Level3"
        default:
            level = "Level1"
        }
        
        if let scene = GameScene(fileNamed:level) {
            // Configure the view.
            let skView = self.view as! SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFit
            scene.gameSettings =  self.gameSettings
            
            skView.presentScene(scene)
        }
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    /*override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}
