//
//  GameplayStats.swift
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

var highScores: [Int] = []

class GameplayStats {
    
    private init() {}
    static let shared = GameplayStats()
    
    func setScore(_ value: Int) {
    
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
}
