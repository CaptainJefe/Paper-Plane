//
//  ObjectProperties.swift
//  PlaneTest
//
//  Created by Cade Williams on 2/9/21.
//  Copyright © 2021 Cade Williams. All rights reserved.
//

import SpriteKit

class Platforms {
    var level: String = "Classic"
    
    var firstPlatform: SKTexture!
    var secondPlatform: SKTexture!
    var transitionPlatform: SKTexture!
    
    func setLevel() {
//        GameScene.init(firstPlatform: firstPlatform, secondPlatform: secondPlatform, transitionPlatform: transitionPlatform)
    }
    
    func setTextures() {
        switch level {
        case "Classic":
            firstPlatform = SKTexture(imageNamed: "platform")
            secondPlatform = SKTexture(imageNamed: "platform2")
            transitionPlatform = SKTexture(imageNamed: "Transition Platform")
            
        default:
            break
        }
    }
    
    
    
}
