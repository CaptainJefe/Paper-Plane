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
import SwiftySound

class Audio {
    static let shared = Audio()
    var soundEffect: SKAudioNode!
    
    private let soundEngine = AVAudioEngine()
    private var audioPlayerNodes = [AVAudioPlayerNode]()
    private var audioFiles: [String: AVAudioFile] = [:]
    
    var windSound = Sound(url: Bundle.main.url(forResource: "level_wind", withExtension: "mp3")!) // instanced version
    
    var instancedSFX: Sound!
    
    func soundSetup() {
        Sound.category = .ambient
    }
    
    
    func playSFX(sound: String) {
        guard isSoundMuted == false else { return }
        
        switch sound {
        case "plane_turn_1":
            instancedSFX = Sound(url: Bundle.main.url(forResource: "plane_turn_1", withExtension: "wav")!)
            
            DispatchQueue.global().async {
                self.instancedSFX.play(numberOfLoops: 0)
            }
            
        case "plane_turn_2":
            instancedSFX = Sound(url: Bundle.main.url(forResource: "plane_turn_2", withExtension: "wav")!)
            
            DispatchQueue.global().async {
                self.instancedSFX.play(numberOfLoops: 0)
            }
            
        case "plane_turn_3":
            instancedSFX = Sound(url: Bundle.main.url(forResource: "plane_turn_3", withExtension: "wav")!)
            
            DispatchQueue.global().async {
                self.instancedSFX.play(numberOfLoops: 0)
            }
            
        case "plane_turn_4":
            instancedSFX = Sound(url: Bundle.main.url(forResource: "plane_turn_4", withExtension: "wav")!)
            
            DispatchQueue.global().async {
                self.instancedSFX.play(numberOfLoops: 0)
            }
            
        case "plane_turn_5":
            instancedSFX = Sound(url: Bundle.main.url(forResource: "plane_turn_5", withExtension: "wav")!)
            
            DispatchQueue.global().async {
                self.instancedSFX.play(numberOfLoops: 0)
            }
            
        case "sound_effect":
            instancedSFX = Sound(url: Bundle.main.url(forResource: "sound_effect", withExtension: "wav")!)
            instancedSFX.volume = 0.8
            
            DispatchQueue.global().async {
                self.instancedSFX.play(numberOfLoops: 0)
            }
            
        case "button_click":
            instancedSFX = Sound(url: Bundle.main.url(forResource: "button_click", withExtension: "wav")!)
            instancedSFX.volume = 0.6
            
            DispatchQueue.global().async {
                self.instancedSFX.play(numberOfLoops: 0)
            }
            
        case "plane_crash":
            instancedSFX = Sound(url: Bundle.main.url(forResource: "plane_crash", withExtension: "wav")!)
            instancedSFX.volume = 0.8
            
            DispatchQueue.global().async {
                self.instancedSFX.play(numberOfLoops: 0)
            }
            
        default:
            break
            
        }
        
//        print("SFX played!")
    }
    
    
    func playWindSound() {
        guard isSoundMuted == false else { return }
        
        self.windSound?.volume = 0.65
        
        DispatchQueue.global().async {
            self.windSound?.play(numberOfLoops: -1)
        }
    }
    
    
    func stopAllSounds() {
        guard isSoundMuted == false else { return }
        
        Sound.stopAll()
    }
    
    
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
}
