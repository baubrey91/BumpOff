//
//  StartScreen.swift
//  bumpOff
//
//  Created by Brandon Aubrey on 7/12/16.
//  Copyright © 2016 Brandon Aubrey. All rights reserved.
//

import Foundation
import UIKit

class StartScreen: UIViewController {
    
    @IBOutlet weak var levelSegment: UISegmentedControl!
    @IBOutlet weak var dissolveSwitch: UISwitch!
    @IBOutlet weak var marathonSwitch: UISwitch!
    @IBOutlet weak var layersSwitch: UISwitch!
    
    var gameSettings = gameStart()
    
    override func viewDidLoad(){
        
    }
    
    @IBAction func marathonSwitch(sender: AnyObject) {
        levelSegment.enabled = marathonSwitch.on ? true : false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startSegue"{
            gameSettings.dissolve = dissolveSwitch.on
            gameSettings.marathon = marathonSwitch.on
            gameSettings.layers = layersSwitch.on
            gameSettings.level = levelSegment.selectedSegmentIndex
            
            let gameVC = segue.destinationViewController as! GameViewController
            gameVC.gameSettings = self.gameSettings
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
}

class gameStart{
    var dissolve: Bool = true
    var marathon: Bool = true
    var layers: Bool = true
    var level: Int?
}