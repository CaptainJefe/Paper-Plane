//
//  GameViewController.swift
//  PlaneTest
//
//  Created by Cade Williams on 8/21/20.
//  Copyright © 2020 Cade Williams. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Assets.sharedInstance.preloadUIAssets()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = TitleScreen(fileNamed: "TitleScreen") {
                scene.size = view.frame.size
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
