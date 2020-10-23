//
//  TitleScreen.swift
//  PlaneTest
//
//  Created by Cade Williams on 10/14/20.
//  Copyright © 2020 Cade Williams. All rights reserved.
//

import SpriteKit
import UIKit

class TitleScreen: SKScene {
    var playButton = UIButton(type: .custom)
    
    override func didMove(to view: SKView) {
//        let background = SKSpriteNode(color: .red, size: CGSize(width: frame.size.width, height: frame.size.height))
//        background.position = CGPoint(x: 0, y: 0)
//        background.zPosition = 5
//        addChild(background)
        
        playButton.frame = CGRect(x: 130, y: 460, width: 150, height: 75)
        playButton.setTitle("Play", for: .normal)
        playButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
//        playButton.titleLabel?.backgroundColor = .black
        playButton.alpha = 0.25
        playButton.backgroundColor = .black
        playButton.tag = 1
        playButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        view.addSubview(playButton)
    }
    
    @objc func startGame(_ sender: UIButton!) {
        if sender.tag == 1 {
            if let skView = self.view {
            
                guard let scene = GameScene(fileNamed: "GameScene") else { return }
                let transition = SKTransition.fade(withDuration: 1.5)
                
                scene.scaleMode = .aspectFill
                
                skView.presentScene(scene, transition: transition)
                playButton.removeFromSuperview()
            }
        }
    }
    
    deinit {
        print("All Good")
    }
}
