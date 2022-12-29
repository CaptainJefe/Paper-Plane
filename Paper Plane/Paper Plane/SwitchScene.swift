//
//  SwitchScene.swift
//  PlaneTest
//
//  Created by Cade Williams on 11/9/22.
//  Copyright © 2022 Cade Williams. All rights reserved.
//

import Foundation
import SpriteKit

class SwitchScene: SKScene {
    
//    private init() {}
    static let shared = SwitchScene()
    
    
    func titleScreen() {
        if let skView = self.view {

            guard let scene = TitleScreen(fileNamed: "TitleScreen") else { return }
            let transition = SKTransition.fade(withDuration: 1.5)
            scene.size = skView.frame.size

            scene.scaleMode = .aspectFill

            skView.presentScene(scene, transition: transition)
        }
    }
    
    
    func worldSelectMenu() {
        if let skView = self.view {
            
            Assets.sharedInstance.preloadGameAssets()
            
            guard let scene = WorldSelect(fileNamed: "WorldSelect") else { return }
            scene.size = skView.frame.size
            
            let transition = SKTransition.fade(withDuration: 1.5)
            
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene, transition: transition)
        }
    }
    
    
}
