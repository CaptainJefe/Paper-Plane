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
    
    func musicPlayer(node: SKNode) {
        guard isMusicMuted == false else { return }
        
        let castleTheme = SKAudioNode(fileNamed: "Paper Plane.mp3")
        let chasmTheme = SKAudioNode(fileNamed: "Chasm_Theme.mp3")
        var themeMusic = SKAudioNode()
        
        switch theme {
        case "castle":
            node.addChild(castleTheme)
        case "chasm":
            node.addChild(chasmTheme)
        case "silo":
            node.addChild(castleTheme)
        default:
            break
            
        }
    }
    
    // first time soundPlayer is used caused a lag spike, every other instance of it being used seems to be fine. Possible simulator problem only
    
    func soundPlayer(node: SKNode) {
        guard isSoundMuted == false else { return }

        let buttonSound = "Button Click.mp3"
        let playSound = SKAction.playSoundFileNamed(buttonSound, waitForCompletion: false)
        node.run(playSound)
    }
}
