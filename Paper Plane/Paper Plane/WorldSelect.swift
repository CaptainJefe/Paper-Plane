//
//  WorldSelect.swift
//  PlaneTest
//
//  Created by Cade Williams on 11/2/22.
//  Copyright © 2022 Cade Williams. All rights reserved.
//

import Foundation
import SpriteKit

enum LockCondition {
    case none // Level 1 is always unlocked
    case gamesPlayed(count: Int)
    case highScore(score: Int)
}

struct LevelConfig {
    let id: String // e.g. "level_2"
    let condition: LockCondition
    
    // Helper to check if this specific level is unlocked
    var isUnlocked: Bool {
        let key = "unlocked_\(id)"
        
        // 1. FAST CHECK: Did we already unlock and save this?
        if UserDefaults.standard.bool(forKey: key) {
            return true
        }
        
        // 2. LOGIC CHECK: Do we meet the requirements right now?
        var passed = false
        switch condition {
        case .none:
            passed = true
        case .gamesPlayed(let count):
            passed = SavedData.shared.getGamesPlayed() >= count
        case .highScore(let score):
            passed = SavedData.shared.getHighscore() >= score
        }
        
        // 3. AUTO-SAVE: If we pass, save it forever so step 1 works next time.
        if passed {
            UserDefaults.standard.set(true, forKey: key)
            print("Achievement Unlocked: \(id)") // Optional debug log
        }
        
        return passed
    }
    
    // Helper to get the text for the UI
    func getLockText() -> (line1: String, line2: String, line3: String) {
        
        switch condition {
        case .none:
            return ("", "", "")
        case .gamesPlayed(let count):
            let remaining = count - SavedData.shared.getGamesPlayed()
            let s = remaining == 1 ? "" : "s" // Handle plural
            return ("Play \(remaining)", "more round\(s)", "to unlock!")
        case .highScore(let score):
            return ("Get a score", "of \(score) or more", "to unlock!")
        }
    }
}


class WorldSelect: SKScene {
    
    var previewBackground = SKSpriteNode(imageNamed: "castle_preview")
    var previewLabel = SKSpriteNode(imageNamed: "castle_label")
    
    let level1Preview = SKTexture(imageNamed: "castle_preview")
    let level1Label = SKTexture(imageNamed: "castle_label")
    
    let level2Preview = SKTexture(imageNamed: "chasm_preview")
    let level2Label = SKTexture(imageNamed: "chasm_label")
    
    let level3Preview = SKTexture(imageNamed: "silo_preview")
    let level3Label = SKTexture(imageNamed: "silo_label")
    
    var previewBackgroundTexture: SKTexture! { didSet { previewBackground.texture = previewBackgroundTexture } }
    var previewLabelTexture: SKTexture! { didSet { previewLabel.texture = previewLabelTexture } }
    
    var buttonLeft: SKSpriteNode!
    var buttonRight: SKSpriteNode!
    var homeButton: SKSpriteNode!
    var playButton: SKSpriteNode!
    
    var areButtonsEnabled = true
    
    var isButtonTouched: String!
    var firstLoad: Bool = true
    
    var lockSprite: SKSpriteNode!
    var lockedText: SKLabelNode!
    var lockedText2: SKLabelNode!
    var lockedText3: SKLabelNode!
    var lockedTextNodes: [SKLabelNode]!
    
    var level2UnlockReq: Int = 15
    
    var levelIndicator = SKSpriteNode(imageNamed: "level_indicator_1")
    
    // Define your level order and rules here
    let allLevels: [LevelConfig] = [
        LevelConfig(id: "level_1", condition: .none),
        LevelConfig(id: "level_2", condition: .gamesPlayed(count: 15)),
        LevelConfig(id: "level_3", condition: .highScore(score: 60))
    ]
    
    
    override func didMove(to view: SKView) {
        
        let wait = SKAction.wait(forDuration: 0.35)
        let showBanner = SKAction.run {
            GameViewController.shared.showBannerAds()
        }
        
        let seq = SKAction.sequence([wait, showBanner])
        run(seq)
        
        
        levelIndicator.position = CGPoint(x: frame.midX, y: frame.maxY * 0.05)
        levelIndicator.size = CGSize(width: levelIndicator.size.width * 1.5, height: levelIndicator.size.height * 1.5)
        levelIndicator.zPosition = 200
        addChild(levelIndicator)
        
        lockSprite = SKSpriteNode(imageNamed: "lock_sprite")
        lockSprite.size = CGSize(width: 128, height: 128)
        lockSprite.position = CGPoint(x: frame.midX, y: frame.maxY * 0.8)
        lockSprite.zPosition = 250
        lockSprite.alpha = 0
        addChild(lockSprite)
        
        // need to remake this if there are other locked levels
        lockedText = SKLabelNode(fontNamed: "Paper Plane Font")
        lockedText.position = CGPoint(x: frame.midX, y: frame.maxY * 0.7)
        lockedText.fontSize = 32
        lockedText.zPosition = 250
        lockedText.alpha = 0
        lockedText.preferredMaxLayoutWidth = frame.width / 2
        //        lockedTextNodes.append(lockedText)
        addChild(lockedText)
        
        lockedText2 = SKLabelNode(fontNamed: "Paper Plane Font")
        lockedText2.position = CGPoint(x: lockedText.position.x, y: frame.maxY * 0.665)
        lockedText2.fontSize = 32
        lockedText2.zPosition = 250
        lockedText2.alpha = 0
        lockedText2.preferredMaxLayoutWidth = frame.width / 2
        //        lockedTextNodes.append(lockedText2)
        addChild(lockedText2)
        
        lockedText3 = SKLabelNode(fontNamed: "Paper Plane Font")
        lockedText3.position = CGPoint(x: lockedText.position.x, y: frame.maxY * 0.63)
        lockedText3.fontSize = 32
        lockedText3.zPosition = 250
        lockedText3.alpha = 0
        lockedText3.preferredMaxLayoutWidth = frame.width / 2
        //        lockedTextNodes.append(lockedText3)
        addChild(lockedText3)
        
        createUI()
        setPreview(currentPreview: "level_1")
        worldPreview()
        
        firstLoad = false
    }
    
    
    func createUI() {
        
        homeButton = SKSpriteNode(imageNamed: "home_button")
        homeButton.size = CGSize(width: 48, height: 48)
        homeButton.position = CGPoint(x: frame.maxX * 0.9, y: frame.maxY * 0.95)
        homeButton.zPosition = 200
        homeButton.name = "homeButton"
        addChild(homeButton)
        
        //        playButton = SKSpriteNode(imageNamed: "ws_play_button")
        //        playButton.size = CGSize(width: 80, height: 80)
        //        playButton.position = CGPoint(x: frame.midX, y: frame.midY / 2.5)
        //        playButton.zPosition = 200
        //        playButton.name = "playButton"
        //        addChild(playButton)
        
        buttonLeft = SKSpriteNode(imageNamed: "arrow_left")
        buttonLeft.size = CGSize(width: 54, height: 54)
        buttonLeft.position = CGPoint(x: frame.maxX * 0.08, y: frame.midY)
        buttonLeft.zPosition = 180
        buttonLeft.name = "buttonLeft"
        addChild(buttonLeft)
        
        buttonRight = SKSpriteNode(imageNamed: "arrow_right")
        buttonRight.size = CGSize(width: 54, height: 54)
        buttonRight.position = CGPoint(x: frame.maxX * 0.92, y: frame.midY)
        buttonRight.zPosition = 180
        buttonRight.name = "buttonRight"
        addChild(buttonRight)
    }
    
    
    func animateBackground(texture: SKTexture) {
        
        let disableButtons = SKAction.run {
            self.areButtonsEnabled = false
        }
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        let fadeIn = SKAction.fadeIn(withDuration: 0.4)
        let setTexture = SKAction.run {
            self.previewBackgroundTexture = texture
        }
        
        let enableButtons = SKAction.run {
            self.areButtonsEnabled = true
        }
        
        let seq = SKAction.sequence([disableButtons, fadeOut, setTexture, fadeIn, enableButtons])
        
        run(seq)
    }
    
    func animateLabel(texture: SKTexture) {
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        let fadeIn = SKAction.fadeIn(withDuration: 0.4)
        let setTexture = SKAction.run {
            self.previewLabelTexture = texture
        }
        let seq = SKAction.sequence([fadeOut, setTexture, fadeIn])
        
        run(seq)
    }
    
    func updateLevelLockUI() {
        
        // 1. Find the configuration for the current level theme
        guard let currentLevel = allLevels.first(where: { $0.id == theme }) else { return }
        
        // 2. Stop any running actions to prevent the "text swap glitch"
        // If the user taps fast, we want to cancel the previous fade-in immediately.
        lockedText.removeAllActions()
        lockedText2.removeAllActions()
        lockedText3.removeAllActions()
        lockSprite.removeAllActions()
        previewBackground.removeAllActions()
        
        // 3. Check Status
        if currentLevel.isUnlocked {
            // --- UNLOCKED STATE ---
            
            // Fade out everything
            let fadeOut = SKAction.fadeOut(withDuration: 0.2)
            
            lockSprite.run(fadeOut)
            lockedText.run(fadeOut)
            lockedText2.run(fadeOut)
            lockedText3.run(fadeOut)
            
            // Reset background
            previewBackground.run(SKAction.colorize(with: .clear, colorBlendFactor: 0.0, duration: 0.3))
            
        } else {
            // --- LOCKED STATE ---
            
            // A. Get the specific text for this level from our Struct
            let texts = currentLevel.getLockText()
            
            // B. Update text IMMEDIATELY (no wait action).
            // This fixes the glitch where you see old text transforming into new text.
            lockedText.text = texts.line1
            lockedText2.text = texts.line2
            lockedText3.text = texts.line3
            
            // C. Animate In
            // We use alpha instead of run(block) to ensure they are visible
            let wait = SKAction.wait(forDuration: 0.4)
            let fadeIn = SKAction.fadeIn(withDuration: 0.2)
            
            lockSprite.alpha = 0
            lockedText.alpha = 0
            lockedText2.alpha = 0
            lockedText3.alpha = 0
            
            lockSprite.run(.sequence([wait, fadeIn]))
            lockedText.run(.sequence([wait, fadeIn]))
            lockedText2.run(.sequence([wait, fadeIn]))
            lockedText3.run(.sequence([wait, fadeIn]))
            
            // Darken Background
            previewBackground.run(SKAction.colorize(with: .darkGray, colorBlendFactor: 0.85, duration: 0.3))
        }
    }
    
    
    func setPreview(currentPreview: String) {
        
        // Set the theme first, as updateLevelLockUI relies on it
        theme = currentPreview
        
        switch currentPreview {
        case "level_1":
            if firstLoad {
                previewBackgroundTexture = level1Preview
                previewLabelTexture = level1Label
            } else {
                animateBackground(texture: level1Preview)
                animateLabel(texture: level1Label)
                levelIndicator.run(.sequence([
                    .wait(forDuration: 0.4),
                    .run { self.levelIndicator.texture = SKTexture(imageNamed: "level_indicator_1") }
                ]))
            }
            
        case "level_2":
            animateBackground(texture: level2Preview)
            animateLabel(texture: level2Label)
            
            levelIndicator.run(.sequence([
                .wait(forDuration: 0.4),
                .run { self.levelIndicator.texture = SKTexture(imageNamed: "level_indicator_2") }
            ]))
            
        case "level_3":
            animateBackground(texture: level3Preview)
            animateLabel(texture: level3Label)
            
            levelIndicator.run(.sequence([
                .wait(forDuration: 0.4),
                .run { self.levelIndicator.texture = SKTexture(imageNamed: "level_indicator_3") }
            ]))
            
        default:
            theme = "level_1"
            levelIndicator.texture = SKTexture(imageNamed: "level_indicator_1")
            previewBackgroundTexture = level1Preview
            previewLabelTexture = level1Label
        }
        
        updateLevelLockUI()
    }
    
    
    func worldPreview() {
        
        previewBackground = SKSpriteNode()
        previewBackground.texture = previewBackgroundTexture
        previewBackground.size = CGSize(width: frame.size.width, height: frame.size.width * 2.5)
        previewBackground.position = CGPoint(x: view!.center.x, y: view!.center.y)
        previewBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        previewBackground.zPosition = 100
        previewBackground.name = "previewBackground"
        addChild(previewBackground)
        
        previewLabel = SKSpriteNode()
        previewLabel.texture = previewLabelTexture
        previewLabel.size = CGSize(width: frame.size.width, height: frame.size.width / 4)
        previewLabel.position = CGPoint(x: view!.center.x, y: view!.center.y)
        previewLabel.zPosition = 150
        previewLabel.name = "previewLabel"
        addChild(previewLabel)
    }
    
    
    func startGame() {
        
        if let skView = self.view {
            
            Assets.sharedInstance.preloadGameAssets()
            
            guard let scene = GameScene(fileNamed: "GameScene") else { return }
            scene.size = skView.frame.size
            
            let transition = SKTransition.fade(withDuration: 1.5)
            scene.scaleMode = .aspectFill
            skView.presentScene(scene, transition: transition)
        }
    }
    
    func backToTitle(node: SKSpriteNode) {
        
        if let skView = self.view {
            
            guard let scene = TitleScreen(fileNamed: "TitleScreen") else { return }
            let transition = SKTransition.fade(withDuration: 1.5)
            scene.size = skView.frame.size
            
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene, transition: transition)
        }
    }
    
    
    func cycleLevel(direction: Int) {
        
        // Current mapping (You can make this dynamic later if you want)
        if theme == "level_1" {
            setPreview(currentPreview: direction == 1 ? "level_2" : "level_3")
        } else if theme == "level_2" {
            setPreview(currentPreview: direction == 1 ? "level_3" : "level_1")
        } else if theme == "level_3" {
            setPreview(currentPreview: direction == 1 ? "level_1" : "level_2")
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            // --- 1. Home Button ---
            if touchedNode.name == "homeButton" {
                Animations.shared.shrink(node: homeButton)
                isButtonTouched = "homeButton"
            }
            
            // --- 2. Level Preview (Refactored) ---
            if touchedNode.name == "previewBackground" || touchedNode.name == "previewLabel" {
                
                // Find current level config
                if let currentLevel = allLevels.first(where: { $0.id == theme }) {
                    
                    // Only show the "Pressed" visual effect (dimming) if UNLOCKED
                    if currentLevel.isUnlocked {
                        Animations.shared.fadeAlphaTo(node: previewBackground, alpha: 0.5, duration: 0.1, waitTime: 0)
                        Animations.shared.fadeAlphaTo(node: previewLabel, alpha: 0.5, duration: 0.1, waitTime: 0)
                        
                        // Mark this as touched so touchesEnded knows to launch the game
                        isButtonTouched = "previewBackground"
                    } else {
                        // If locked, we do nothing (no dimming effect).
                        // We clear the tracker so touchesEnded doesn't accidentally trigger anything.
                        isButtonTouched = ""
                    }
                }
            }
            
            // --- 3. Left Arrow ---
            if touchedNode.name == "buttonLeft" && areButtonsEnabled {
                Animations.shared.shrink(node: buttonLeft)
                isButtonTouched = "buttonLeft"
            }
            
            // --- 4. Right Arrow ---
            if touchedNode.name == "buttonRight" && areButtonsEnabled {
                Animations.shared.shrink(node: buttonRight)
                isButtonTouched = "buttonRight"
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            // --- 1. Handle Home Button ---
            if touchedNode.name == "homeButton" {
                let expand = SKAction.run { Animations.shared.expand(node: self.homeButton) }
                let wait = SKAction.wait(forDuration: 0.175)
                let sequence = SKAction.sequence([expand, wait])
                run(sequence, completion: { self.backToTitle(node: self.homeButton) } )
                return // Exit early
            }
            
            // --- 2. Handle Level Selection / Start Game ---
            if touchedNode.name == "previewBackground" || touchedNode.name == "previewLabel" {
                
                // A. Find the config for the current level
                guard let currentLevel = allLevels.first(where: { $0.id == theme }) else { return }
                
                // B. Check if Locked or Unlocked
                if !currentLevel.isUnlocked {
                    // --- LOCKED: Shake the text ---
                    let shakeLeft = SKAction.rotate(toAngle: (1 / 36) * .pi, duration: 0.06, shortestUnitArc: true)
                    let shakeRight = SKAction.rotate(toAngle: (71 / 36) * .pi, duration: 0.06, shortestUnitArc: true)
                    let center = SKAction.rotate(toAngle: 0, duration: 0.06, shortestUnitArc: true)
                    let shakeSeq = SKAction.sequence([shakeLeft, shakeRight, center])
                    
                    lockedText.run(shakeSeq)
                    lockedText2.run(shakeSeq)
                    lockedText3.run(shakeSeq)
                    lockSprite.run(shakeSeq)
                } else {
                    // --- UNLOCKED: Start Game ---
                    previewBackground.isUserInteractionEnabled = true // Prevent double taps
                    Audio.shared.playSFX(sound: "sound_effect")
                    
                    // Animation sequence
                    let expand = SKAction.run {
                        Animations.shared.expand(node: self.previewBackground)
                        Animations.shared.fadeAlphaTo(node: self.previewLabel, alpha: 1, duration: 0.1, waitTime: 0)// Optional: Add expand effect to bg?
                    }
                    let wait = SKAction.wait(forDuration: 0.45)
                    let sequence = SKAction.sequence([expand, wait])
                    
                    run(sequence, completion: { self.startGame() } )
                }
            }
            
            // --- 3. Handle Navigation Arrows ---
            if touchedNode.name == "buttonLeft" && areButtonsEnabled {
                Animations.shared.expand(node: buttonLeft)
                cycleLevel(direction: -1)
            }
            
            if touchedNode.name == "buttonRight" && areButtonsEnabled {
                Animations.shared.expand(node: buttonRight)
                cycleLevel(direction: 1)
            }
            
            isButtonTouched = ""
        }
    }
}
