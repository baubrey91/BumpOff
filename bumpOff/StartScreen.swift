//
//  StartScreen.swift
//  bumpOff
//
//  Created by Brandon Aubrey on 7/12/16.
//  Copyright © 2016 Brandon Aubrey. All rights reserved.
//

import Foundation
import UIKit

class StartScreen: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var levelSegment: UISegmentedControl!
    @IBOutlet weak var dissolveSwitch: UISwitch!
    @IBOutlet weak var marathonSwitch: UISwitch!
    @IBOutlet weak var layersSwitch: UISwitch!
    
    var gameSettings = gameStart()
    
    override func viewDidLoad(){
        
    }
    
    @IBAction func marathonSwitch(_ sender: AnyObject) {
        levelSegment.isEnabled = marathonSwitch.isOn ? true : false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startSegue"{
            gameSettings.dissolve = dissolveSwitch.isOn
            gameSettings.marathon = marathonSwitch.isOn
            gameSettings.layers = layersSwitch.isOn
            gameSettings.level = levelSegment.selectedSegmentIndex
            
            let gameVC = segue.destination as! GameViewController
            gameVC.gameSettings = self.gameSettings
        }
        
        if segue.identifier == "howTo" {
            let popoverViewController = segue.destination 
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
        
        if segue.identifier == "disolve" {
            let popoverViewController = segue.destination
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func howToPlay(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "howTo", sender: self)
    }
    
    @IBAction func disolveButton(_ sender: AnyObject) {
                self.performSegue(withIdentifier: "disolve", sender: self)
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}

class gameStart{
    var dissolve: Bool = true
    var marathon: Bool = true
    var layers: Bool = true
    var level: Int?
}
