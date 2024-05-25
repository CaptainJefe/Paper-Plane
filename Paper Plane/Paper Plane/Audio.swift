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

//class Audio {
//    static let shared = Audio()
//    var soundEffect: SKAudioNode!
//    
//    private let soundEngine = AVAudioEngine()
//    private let audioPlayerNode = AVAudioPlayerNode()
//    private var audioFiles: [String: AVAudioFile] = [:]
//    
//    
//    func initEngine() {
//        
//        let soundNames = ["Button Click", "level_wind", "plane_turn"] // Add your sound file names here
//        for soundName in soundNames {
//            if let audioFileURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
//                do {
//                    let audioFile = try AVAudioFile(forReading: audioFileURL)
//                    audioFiles[soundName] = audioFile
//                } catch {
//                    print("An error occurred: \(error.localizedDescription)")
//                }
//            }
//        }
//        
//        soundEngine.attach(audioPlayerNode)
//        soundEngine.connect(audioPlayerNode, to: soundEngine.mainMixerNode, format: nil)
//    }
//    
//    
//    
//    func audioSession() {
//        let session = AVAudioSession.sharedInstance()
//        
//        try? session.setActive(false, options: .notifyOthersOnDeactivation)
//        try? session.setCategory(.playback, mode: .default, options: .mixWithOthers)
//        //        try? session.setCategory(.ambient, options: .mixWithOthers)
//    }
//    
//    // first time soundPlayer is used caused a lag spike, every other instance of it being used seems to be fine. Possible simulator problem only
//    
//    func soundPlayer(soundName: String, shouldLoop: Bool = false) {
//        guard isSoundMuted == false else { return }
//        
//        guard let audioFile = audioFiles[soundName] else { return }
//        
//        if shouldLoop {
//            let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length))
//            do {
//                try audioFile.read(into: audioBuffer!)
//            } catch {
//                print("An error occurred: \(error.localizedDescription)")
//            }
//            audioPlayerNode.scheduleBuffer(audioBuffer!, at: nil, options: .loops, completionHandler: nil)
//        } else {
//            audioPlayerNode.scheduleFile(audioFile, at: nil)
//        }
//        
//        do {
//            try soundEngine.start()
//            
//            audioPlayerNode.play()
//        } catch {
//            print("An error occurred \(error.localizedDescription)")
//        }
//    }
//    
//    func stopSound() {
//        audioPlayerNode.stop()
//        audioPlayerNode.reset()
//        soundEngine.stop()
//        
//        initEngine()
//    }
//    
//    
//    //    var castleTheme: SKAudioNode!
//    
//    //    var buttonSound: SKAudioNode!
//    
//    func musicPlayer(node: SKNode) {
//        guard isMusicMuted == false else { return }
//        
//        let castleTheme = SKAudioNode(fileNamed: "Paper Plane.mp3")
//        let chasmTheme = SKAudioNode(fileNamed: "Chasm_Theme.mp3")
//        var themeMusic = SKAudioNode()
//        
//        switch theme {
//        case "castle":
//            node.addChild(castleTheme)
//        case "chasm":
//            node.addChild(chasmTheme)
//        case "silo":
//            node.addChild(castleTheme)
//        default:
//            break
//            
//        }
//    }
//}





class Audio {
    static let shared = Audio()
    var soundEffect: SKAudioNode!
    
    private let soundEngine = AVAudioEngine()
    private var audioPlayerNodes = [AVAudioPlayerNode]()
    private var audioFiles: [String: AVAudioFile] = [:]
    
    
    func initEngine() {
        
        if soundEngine.isRunning {
            soundEngine.stop()
            soundEngine.reset()
        }
        
        let soundNames = ["Button Click" : "mp3", "level_wind" : "mp3", "plane_turn" : "wav"] // Add your sound file names here
        for (soundName, fileExtension) in soundNames {
            if let audioFileURL = Bundle.main.url(forResource: soundName, withExtension: fileExtension) {
                do {
                    let audioFile = try AVAudioFile(forReading: audioFileURL)
                    audioFiles[soundName] = audioFile
                } catch {
                    print("An error occurred: \(error.localizedDescription)")
                }
            }
        }
        
//        soundEngine.attach(audioPlayerNode)
//        soundEngine.connect(audioPlayerNode, to: soundEngine.mainMixerNode, format: nil)
    }
    
    
    
    func audioSession() {
        let session = AVAudioSession.sharedInstance()
        
        try? session.setActive(false, options: .notifyOthersOnDeactivation)
        try? session.setCategory(.playback, mode: .default, options: .mixWithOthers)
        //        try? session.setCategory(.ambient, options: .mixWithOthers)
    }
    
    // first time soundPlayer is used caused a lag spike, every other instance of it being used seems to be fine. Possible simulator problem only
    
    func soundPlayer(soundName: String, shouldLoop: Bool = false) {
        guard isSoundMuted == false else { return }
        
        guard let audioFile = audioFiles[soundName] else { return }
        
        // Create a new audio player node for this sound
        let audioPlayerNode = AVAudioPlayerNode()
        audioPlayerNodes.append(audioPlayerNode)
        
        soundEngine.attach(audioPlayerNode)
        soundEngine.connect(audioPlayerNode, to: soundEngine.mainMixerNode, format: nil)
        
        if shouldLoop {
            do {
                let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length))
                try audioFile.read(into: audioBuffer!)
                audioPlayerNode.scheduleBuffer(audioBuffer!, at: nil, options: .loops, completionHandler: nil)
            } catch {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
        } else {
            audioPlayerNode.scheduleFile(audioFile, at: nil)
        }
        
        do {
            try soundEngine.start()
            audioPlayerNode.play()
        } catch {
            print("An error occurred \(error.localizedDescription)")
        }
    }





    
    func stopSound() {
        for audioPlayerNode in audioPlayerNodes {
            audioPlayerNode.stop()
            audioPlayerNode.reset()
            soundEngine.detach(audioPlayerNode)
        }
        audioPlayerNodes.removeAll()
        
        
        
        initEngine()
    }
    
    
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
}




//import AVFoundation
//import SpriteKit
//
//class Audio {
//    static let shared = Audio()
//    var soundEffect: SKAudioNode!
//    
//    private let soundEngine = AVAudioEngine()
//    private let audioPlayerNode = AVAudioPlayerNode()
//    private var audioFile: AVAudioFile?
//    
//    
//    func initEngine() {
//        if let audioFileURL = Bundle.main.url(forResource: "Button Click", withExtension: "mp3") {
//            do {
//                audioFile = try AVAudioFile(forReading: audioFileURL)
//                
//                soundEngine.attach(audioPlayerNode)
//                
////                soundEngine.connect(audioPlayerNode, to: soundEngine.outputNode, format: audioFile?.processingFormat)
//                soundEngine.connect(audioPlayerNode, to: soundEngine.mainMixerNode, format: nil)
//            } catch {
//                print("An error occurred: \(error.localizedDescription)")
//            }
//        }
//    }
//    
////    var castleTheme: SKAudioNode!
//    
////    var buttonSound: SKAudioNode!
//    
//    func musicPlayer(node: SKNode) {
//        guard isMusicMuted == false else { return }
//        
//        let castleTheme = SKAudioNode(fileNamed: "Paper Plane.mp3")
//        let chasmTheme = SKAudioNode(fileNamed: "Chasm_Theme.mp3")
//        var themeMusic = SKAudioNode()
//        
//        switch theme {
//        case "castle":
//            node.addChild(castleTheme)
//        case "chasm":
//            node.addChild(chasmTheme)
//        case "silo":
//            node.addChild(castleTheme)
//        default:
//            break
//            
//        }
//    }
//    
//    func audioSession() {
//        let session = AVAudioSession.sharedInstance()
//        
//        try? session.setActive(false, options: .notifyOthersOnDeactivation)
//        try? session.setCategory(.playback, mode: .default, options: .mixWithOthers)
////        try? session.setCategory(.ambient, options: .mixWithOthers)
//    }
//    
//    // first time soundPlayer is used caused a lag spike, every other instance of it being used seems to be fine. Possible simulator problem only
//    
//    func soundPlayer() {
//        
//        guard isSoundMuted == false else { return }
//        
//        guard let audioFile = audioFile else { return }
//        
//        audioPlayerNode.scheduleFile(audioFile, at: nil)
//
//        do {
//            try soundEngine.start()
//            
//            audioPlayerNode.play()
//        } catch {
//            print("An error occurred \(error.localizedDescription)")
//        }
//       
//
////        let buttonSound = "Button Click.mp3"
////        let playSound = SKAction.playSoundFileNamed(buttonSound, waitForCompletion: false)
////        node.run(playSound)
//    }
//}
