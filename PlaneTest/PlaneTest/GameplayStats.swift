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

class GameplayStats {
    
    private init() {}
    static let shared = GameplayStats()
    
    func setScore(_ value: Int) {
        
        if value > getHighscore() {
            setHighScore(value)
        }
        
        UserDefaults.standard.set(value, forKey: gameScore)
        UserDefaults.standard.synchronize()
    }
    
    func getScore() -> Int {
        return UserDefaults.standard.integer(forKey: gameScore)
    }
    
    func setHighScore(_ value: Int) {
        UserDefaults.standard.set(value, forKey: gameHighScore)
        UserDefaults.standard.synchronize()
    }
    
    func getHighscore() -> Int {
        return UserDefaults.standard.integer(forKey: gameHighScore)
    }
}
