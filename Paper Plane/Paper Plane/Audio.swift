//
//  Audio.swift
//  PlaneTest
//
//  Created by Cade Williams on 12/5/22.
//  Copyright © 2022 Cade Williams. All rights reserved.
//


//
// AUDIO WON'T PLAY FROM THIS CLASS, BUT WILL PLAY IF THE METHODS ARE PLACED IN THE TARGET CLASS
//

import AVFoundation
import SpriteKit

class Audio: SKScene {
    static let shared = Audio()
    var soundEffect: SKAudioNode!
    
//    var castleTheme: SKAudioNode!
    
//    var buttonSound: SKAudioNode!
    
    func musicPlayer() {
        guard isMusicMuted == false else { return }
        
        let castleTheme = SKAudioNode(fileNamed: "Paper Plane.mp3")
        
        switch theme {
        case "castle":
            addChild(castleTheme)
        case "chasm":
            addChild(castleTheme)
        case "silo":
            addChild(castleTheme)
        default:
            break
            
        }
    }
    
    func soundPlayer(node: SKNode) {
        guard isSoundMuted == false else { return }

        let buttonSound = "Button Click.mp3"
        let playSound = SKAction.playSoundFileNamed(buttonSound, waitForCompletion: false)
        node.run(playSound)
    }
}
