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

let totalScore = "totalScore"
var totalScoreAsInt = UserDefaults.standard.integer(forKey: totalScore)

//var highScores = [Int?](repeating: 0, count: 10)
var highScores = UserDefaults.standard.array(forKey: "gameScore") ?? []

var isLevel2Locked: Bool = true
var isLevel3Locked: Bool = true

// high scores was getting reset because when the app loads back up, it remembers the last values stored in UserDefaults in that last session, but since highscores is initialized as a default array when launched, when a new score is made and appended, setScore takes the current array of (var) highScores and sets UserDefaults value as that. Since on launch it starts with default values, it overwrites the UserDefaults saved values, because once again, UserDefaults value is set by taking the the values of the current highScores (and not just adds values to the existing saved data). Solution was to set highScores as the previously saved data of its UserDefaults on app start, before any new values are allowed to be appended on highScores and overwrite UserDefaults.

var gamesPlayed = UserDefaults.standard.integer(forKey: "gamesPlayed")

var adsRemoved: Bool!

class SavedData {
	
	static let shared = SavedData()
	private init() {}
	
	
	private let keyLeaderboard = "leaderboardScores" // Stores top 10 highest scores
	private let keyRecentScores = "recentScores" // Stores the last 20 scores
	private let keyTotalScore = "totalscore" // Total scored over every game played - used to track the stat "Platforms Passed"
	private let keyGamesPlayed = "gamesPlayed" // Total games played
	private let keyGamesPlayedLevel1 = "gamesPlayedLevel1"
	private let keyGamesPlayedLevel2 = "gamesPlayedLevel2"
	private let keyGamesPlayedLevel3 = "gamesPlayedLevel3"
	
	
	func saveGameResults(score: Int) {
		
		let currentTotal = getTotalScore()
		UserDefaults.standard.set(currentTotal + score, forKey: keyTotalScore)
		
		let currentGames = getGamesPlayed()
		UserDefaults.standard.set(currentGames + 1, forKey: keyGamesPlayed)
		
		let currentGamesLevel1 = getGamesPlayedLevel1()
		let currentGamesLevel2 = getGamesPlayedLevel2()
		let currentGamesLevel3 = getGamesPlayedLevel3()
		
		switch theme {
		case "level_1":
			UserDefaults.standard.set(currentGamesLevel1 + 1, forKey: keyGamesPlayedLevel1)
			
		case "level_2":
			UserDefaults.standard.set(currentGamesLevel2 + 1, forKey: keyGamesPlayedLevel2)
			
		case "level_3":
			UserDefaults.standard.set(currentGamesLevel3 + 1, forKey: keyGamesPlayedLevel3)
			
		default:
			break
		}
		
		
		// If the score is 0, don't save the score
		guard score > 0 else { return }
		
		var topScores = getLeaderboard()
		
		if !topScores.contains(score) {
			
			topScores.append(score)
			topScores.sort(by: >)
			
			topScores = Array(topScores.prefix(20))
			
			UserDefaults.standard.set(topScores, forKey: keyLeaderboard)
		}
		
		
		var recentScores = getRecentsScores()
		recentScores.append(score)
		
		if recentScores.count > 20 {
			recentScores.removeFirst()
		}
		
		UserDefaults.standard.set(recentScores, forKey: keyRecentScores)
	}
	
	
	func getLeaderboard() -> [Int] {
		return UserDefaults.standard.array(forKey: keyLeaderboard) as? [Int] ?? []
	}
	
	func getHighscore() -> Int {
		return getLeaderboard().first ?? 0
	}
	
	func getRecentsScores() -> [Int] {
		return UserDefaults.standard.array(forKey: keyRecentScores) as? [Int] ?? []
	}
	
	func getTotalScore() -> Int {
		return UserDefaults.standard.integer(forKey: keyTotalScore)
	}
	
	func getGamesPlayed() -> Int {
		return UserDefaults.standard.integer(forKey: keyGamesPlayed)
	}
	
	func getGamesPlayedLevel1() -> Int {
		return UserDefaults.standard.integer(forKey: keyGamesPlayedLevel1)
	}
	
	func getGamesPlayedLevel2() -> Int {
		return UserDefaults.standard.integer(forKey: keyGamesPlayedLevel2)
	}
	
	func getGamesPlayedLevel3() -> Int {
		return UserDefaults.standard.integer(forKey: keyGamesPlayedLevel3)
	}
	
	
	func getAverageLast20() -> Int {
		let recents = getRecentsScores()
		if recents.isEmpty { return 0 }
		let total = recents.reduce(0, +)
		return total / recents.count
	}
	
	// Out of date. Either delete this or add in the init to purge/merge old data
	func getScore() -> [Int]? {
		return UserDefaults.standard.object(forKey: gameScore) as? [Int]
	}
}

// Consider removing isMusicMuted and isSoundMuted for only UserDefaults if it makes sense
// or consider not initializing as false and have them be a generic bool

var isMusicMuted = false
var isSoundMuted = false

var areControlsHidden = false

var firstTimePlaying = UserDefaults.standard.bool(forKey: "firstTimePlaying")

class SavedSettings {
	
	private init() {
		// --- MIGRATION START ---
		if UserDefaults.standard.bool(forKey: "remove_ads") == true {
			if UserDefaults.standard.object(forKey: keyAdsRemoved) == nil {
				UserDefaults.standard.set(true, forKey: keyAdsRemoved)
				UserDefaults.standard.removeObject(forKey: "remove_ads")
				print("Migrated legacy ad purchase to new system.")
			}
		}
	}
	
	static let shared = SavedSettings()
	
	private let keyAdsRemoved = "adsRemoved"
	private let keyIsMusicMuted = "isMusicMuted"
	private let keyIsSoundMuted = "isSoundMuted"
	private let keyAreControlsHidden = "areControlsHidden"
	private let keyFirstTimePlaying = "firstTimePlaying"
	
	
	var areAdsRemoved: Bool {
		get { return UserDefaults.standard.bool(forKey: keyAdsRemoved) }
		set { UserDefaults.standard.set(newValue, forKey: keyAdsRemoved) }
	}
	
	
	var isMusicMuted: Bool {
		get {
			// If it doesn't exist, make it default to true
			if UserDefaults.standard.object(forKey: keyIsMusicMuted) == nil {
				return false
			}
			return UserDefaults.standard.bool(forKey: keyIsMusicMuted)
		}
		set { UserDefaults.standard.set(newValue, forKey: keyIsMusicMuted) }
	}
	
	
	var isSoundMuted: Bool {
		get {
			// If it doesn't exist, make it default to true
			if UserDefaults.standard.object(forKey: keyIsSoundMuted) == nil {
				return false
			}
			return UserDefaults.standard.bool(forKey: keyIsSoundMuted)
		}
		set { UserDefaults.standard.set(newValue, forKey: keyIsSoundMuted) }
	}
	
	
	var areControlsHidden: Bool {
		get { return UserDefaults.standard.bool(forKey: keyAreControlsHidden) }
		set { UserDefaults.standard.set(newValue, forKey: keyAreControlsHidden) }
	}
	
	
	var firstTimePlaying: Bool {
		get {
			// Check if key exists, otherwise return true
			if UserDefaults.standard.object(forKey: keyFirstTimePlaying) == nil {
				return true
			}
			return UserDefaults.standard.bool(forKey: keyFirstTimePlaying)
		}
		set { UserDefaults.standard.set(newValue, forKey: keyFirstTimePlaying) }
		
	}
	
	
	func setAdsSettings() {
		UserDefaults.standard.setValue(adsRemoved, forKey: "adsRemoved")
	}
	
	func getAdsSettings() -> Bool {
		return UserDefaults.standard.bool(forKey: "adsRemoved")
	}
}
