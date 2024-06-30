//
//  SavedData.swift
//  PlaneTest
//
//  Created by Cade Williams on 2/5/22.
//  Copyright © 2022 Cade Williams. All rights reserved.
//

import Foundation

let gameSetScore = "setScore"
let gameGetScore = "getScore"
let gameScore = "gameScore"
let gameHighScore = "highScore"

//var highScores = [Int?](repeating: 0, count: 10)
var highScores = UserDefaults.standard.array(forKey: "gameScore") ?? []

var isChasmLocked: Bool = true
var isSiloLocked: Bool = true

// high scores was getting reset because when the app loads back up, it remembers the last values stored in UserDefaults in that last session, but since highscores is initialized as a default array when launched, when a new score is made and appended, setScore takes the current array of (var) highScores and sets UserDefaults value as that. Since on launch it starts with default values, it overwrites the UserDefaults saved values, because once again, UserDefaults value is set by taking the the values of the current highScores (and not just adds values to the existing saved data). Solution was to set highScores as the previously saved data of its UserDefaults on app start, before any new values are allowed to be appended on highScores and overwrite UserDefaults.

var gamesPlayed = UserDefaults.standard.integer(forKey: "gamesPlayed")

var adsRemoved: Bool!

class SavedData {
    
    private init() {}
    static let shared = SavedData()

    
    func setScore(_ value: Int) {
    
        // Settings and getting scores
        
        if value > getHighscore() {
            setHighScore(value)
            highScores.append(value)
        } else {
            highScores.append(value) // if value is not higher than getHighscore(), it won't append a score to the array and the array will remain empty
        }
        
        UserDefaults.standard.set(highScores, forKey: gameScore)
        UserDefaults.standard.synchronize()
    }
    
    func getScore() -> [Int]? {
        return UserDefaults.standard.object(forKey: gameScore) as? [Int]
    }
    
    func setHighScore(_ value: Int) {
        UserDefaults.standard.set(value, forKey: gameHighScore)
        UserDefaults.standard.synchronize()
    }
    
    func getHighscore() -> Int {
        return UserDefaults.standard.integer(forKey: gameHighScore)
    }
    
    // Other stats
    
    func setGamesPlayed() {
        gamesPlayed += 1
        print("Games Played: \(gamesPlayed)")
        UserDefaults.standard.set(gamesPlayed, forKey: "gamesPlayed")
    }
    
    func getGamesPlayed() -> Int {
        return UserDefaults.standard.integer(forKey: "gamesPlayed")
    }
    
}

// Consider removing isMusicMuted and isSoundMuted for only UserDefaults if it makes sense
// or consider not initializing as false and have them be a generic bool

var isMusicMuted = false
var isSoundMuted = false

var areControlsHidden = false

var firstTimePlaying = UserDefaults.standard.bool(forKey: "firstTimePlaying")

class SavedSettings {
    
    private init() {}
    static let shared = SavedSettings()
    
    func setMusicSettings() {
        UserDefaults.standard.set(isMusicMuted, forKey: "isMusicMuted")
    }
    
    func getMusicSettings() -> Bool {
        return UserDefaults.standard.bool(forKey: "isMusicMuted")
    }
    
    
    func setSoundSettings() {
        UserDefaults.standard.set(isSoundMuted, forKey: "isSoundMuted")
    }
    
    func getSoundSettings() -> Bool {
        return UserDefaults.standard.bool(forKey: "isSoundMuted")
    }
    
    
    func setControlsSettings() {
        UserDefaults.standard.set(areControlsHidden, forKey: "areControlsHidden")
    }
    
    func getControlsSettings() -> Bool {
        return UserDefaults.standard.bool(forKey: "areControlsHidden")
    }
    
    func setTutorialData() {
        UserDefaults.standard.set(firstTimePlaying, forKey: "firstTimePlaying")
    }
    
    func getTutorialData() -> Bool {
        return UserDefaults.standard.bool(forKey: "firstTimePlaying") ?? true
    }
    
    func setAdsSettings() {
        UserDefaults.standard.setValue(adsRemoved, forKey: "adsRemoved")
    }
    
    func getAdsSettings() -> Bool {
        return UserDefaults.standard.bool(forKey: "adsRemoved")
    }
}
