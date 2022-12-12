//
//  WorldSelect.swift
//  PlaneTest
//
//  Created by Cade Williams on 11/2/22.
//  Copyright © 2022 Cade Williams. All rights reserved.
//

func rad2deg(number: Double) -> Double {
    return number * 180 / .pi
}

import Foundation
import SpriteKit

class WorldSelect: SKScene {
    
    var previewBackground = SKSpriteNode(imageNamed: "castle_preview")
    var previewLabel = SKSpriteNode(imageNamed: "castle_label")
    
    let castlePreview = SKTexture(imageNamed: "castle_preview")
    let castleLabel = SKTexture(imageNamed: "castle_label")
    
    let chasmPreview = SKTexture(imageNamed: "chasm_preview")
    let chasmLabel = SKTexture(imageNamed: "chasm_label")
    
    let siloPreview = SKTexture(imageNamed: "silo_preview")
    let siloLabel = SKTexture(imageNamed: "silo_label")
    
    var previewBackgroundTexture: SKTexture! { didSet { previewBackground.texture = previewBackgroundTexture } }
    var previewLabelTexture: SKTexture! { didSet { previewLabel.texture = previewLabelTexture } }
    
    var buttonLeft: SKSpriteNode!
    var buttonRight: SKSpriteNode!
    var homeButton: SKSpriteNode!
    var playButton: SKSpriteNode!
    
    var isButtonTouched: String!
    var firstLoad: Bool = true
    
    var lockSprite: SKSpriteNode!
    var lockedText: SKLabelNode!
    
    var chasmUnlockReq: Int = 15
    
    var levelIndicator = SKSpriteNode(imageNamed: "level_indicator_1")
    
    override func didMove(to view: SKView) {
        

        let scores = SavedData.shared.getScore()
        
        for value in scores ?? [] {
            if isSiloLocked == true {
                if value >= 1500 {
                    isSiloLocked = false
                    UserDefaults.standard.set(isSiloLocked, forKey: "isSiloLocked")
                }
            }
        }
        
        if isChasmLocked == true {
            if gamesPlayed >= chasmUnlockReq {
                isChasmLocked = false
                UserDefaults.standard.set(isChasmLocked, forKey: "isChasmLocked")
            }
        }
        
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
        lockedText.position = CGPoint(x: frame.midX, y: frame.maxY * 0.6)
        lockedText.fontSize = 32
        lockedText.zPosition = 250
        lockedText.alpha = 0
        lockedText.preferredMaxLayoutWidth = frame.width / 2
        lockedText.numberOfLines = 2
        addChild(lockedText)
        
        createUI()
        setPreview(currentPreview: "castle")
        worldPreview()
        
        
        firstLoad = false
    }
    
    func createUI() {
        homeButton = SKSpriteNode(imageNamed: "home_button")
        homeButton.size = CGSize(width: 64, height: 64)
        homeButton.position = CGPoint(x: frame.maxX * 0.9, y: frame.maxY * 0.95)
        homeButton.zPosition = 200
        homeButton.name = "homeButton"
        addChild(homeButton)
        
        playButton = SKSpriteNode(imageNamed: "GO")
        playButton.size = CGSize(width: 128, height: 64)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY / 3)
        playButton.zPosition = 200
        playButton.name = "playButton"
        addChild(playButton)
        
        buttonLeft = SKSpriteNode(imageNamed: "arrow_left")
        buttonLeft.size = CGSize(width: 48, height: 48)
        buttonLeft.position = CGPoint(x: frame.maxX * 0.1, y: frame.midY)
        buttonLeft.zPosition = 180
        buttonLeft.name = "buttonLeft"
        addChild(buttonLeft)
        
        buttonRight = SKSpriteNode(imageNamed: "arrow_right")
        buttonRight.size = CGSize(width: 48, height: 48)
        buttonRight.position = CGPoint(x: frame.maxX * 0.9, y: frame.midY)
        buttonRight.zPosition = 180
        buttonRight.name = "buttonRight"
        addChild(buttonRight)
    }
    
    func animateBackground(texture: SKTexture) {
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        let fadeIn = SKAction.fadeIn(withDuration: 0.4)
        let setTexture = SKAction.run {
            self.previewBackgroundTexture = texture
        }
        let seq = SKAction.sequence([fadeOut, setTexture, fadeIn])
        
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
    
    func worldLocked() {
        // change to a switch case if there are more levels that are locked
        
        // Sets default values so changing from one locked level to the other doesn't stack previous colorBlendFactor values
        previewBackground.color = .clear
        previewBackground.colorBlendFactor = 0
        
        // note: swapping between two locked levels, the text get swapped and can be seen being changed before the new level preview appears
        
        if isSiloLocked == true {
            if theme == "silo" {
                
                lockedText.text = "Get a score of 150 or more to unlock!"
                Animations.shared.fadeAlphaIn(node: lockSprite, duration: 0.4, waitTime: 0.3)
                Animations.shared.colorize(node: previewBackground, color: .darkGray, colorBlendFactor: 0.85, duration: 0.3)
                Animations.shared.fadeAlphaIn(node: lockedText, duration: 0.8, waitTime: 0.3)
            } else {
                Animations.shared.fadeAlphaOut(node: lockSprite, duration: 0.4, waitTime: 0)
                Animations.shared.colorize(node: previewBackground, color: .clear, colorBlendFactor: 0, duration: 0.3)
                Animations.shared.fadeAlphaOut(node: lockedText, duration: 0.0, waitTime: 0)
            }
        }
            
        if isChasmLocked == true {
            if theme == "chasm" {
                    
                
                if chasmUnlockReq - gamesPlayed == 1 {
                    lockedText.text = "Play \(chasmUnlockReq - gamesPlayed) more round to unlock!"
                } else {
                    lockedText.text = "Play \(chasmUnlockReq - gamesPlayed) more rounds to unlock!"
                }
                
                Animations.shared.fadeAlphaIn(node: lockSprite, duration: 0.4, waitTime: 0.3)
                Animations.shared.colorize(node: previewBackground, color: .darkGray, colorBlendFactor: 0.85, duration: 0.3)
                Animations.shared.fadeAlphaIn(node: lockedText, duration: 0.8, waitTime: 0.3)
            } else {
                Animations.shared.fadeAlphaOut(node: lockSprite, duration: 0.4, waitTime: 0)
                Animations.shared.colorize(node: previewBackground, color: .clear, colorBlendFactor: 0, duration: 0.3)
                Animations.shared.fadeAlphaOut(node: lockedText, duration: 0.0, waitTime: 0)
            }
        }
    }
    
    // Need to implement a disable of world change buttons while preview is being changed
    func setPreview(currentPreview: String) {
        
        switch currentPreview {
        case "castle":
            
            if firstLoad == true {
                previewBackgroundTexture = castlePreview
                previewLabelTexture = castleLabel
            } else {
                levelIndicator.texture = SKTexture(imageNamed: "level_indicator_1")
                animateBackground(texture: castlePreview)
                animateLabel(texture: castleLabel)
            }
            
            theme = "castle"
            
            playButton.isHidden = false
            
        case "chasm":
            levelIndicator.texture = SKTexture(imageNamed: "level_indicator_2")
            animateBackground(texture: chasmPreview)
            animateLabel(texture: chasmLabel)
            
            theme = "chasm"
            
            if isChasmLocked == true {
                playButton.isHidden = true
            } else {
                playButton.isHidden = false
            }
            
        case "silo":
            levelIndicator.texture = SKTexture(imageNamed: "level_indicator_3")
            animateBackground(texture: siloPreview)
            animateLabel(texture: siloLabel)
            
            theme = "silo"
            
            if isSiloLocked == true {
                playButton.isHidden = true
            } else {
                playButton.isHidden = false
            }
            
        default:
            levelIndicator.texture = SKTexture(imageNamed: "level_indicator_1")
            previewBackgroundTexture = castlePreview
            previewLabelTexture = castleLabel
            
            theme = "castle"
            
            playButton.isHidden = false
        }
        
        worldLocked()
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
    
    func changeWorld() {
        
    }
    
    func startGame() {
        // Might be a bad way to ask if theme is not equal to any of the possible level designations, then default to a valid one.
//        if theme != "castle" || theme != "chasm" || theme != "silo" {
//            theme = "castle"
//        }
        
        if let skView = self.view {
            
            Assets.sharedInstance.preloadGameAssets()
            
            guard let scene = GameSceneNewNew(fileNamed: "GameSceneNewNew") else { return }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "homeButton" {
                Animations.shared.shrink(node: homeButton)
                isButtonTouched = "homeButton"
            }
            
            if touchedNode.name == "playButton" {
                
                if theme == "chasm" {
                    if isChasmLocked == true {
                        return
                    } else {
                        Animations.shared.shrink(node: playButton)
                    }
                } else if theme == "silo" {
                    if isSiloLocked == true {
                        return
                    } else {
                        Animations.shared.shrink(node: playButton)
                    }
                } else {
                    Animations.shared.shrink(node: playButton)
                }
                
                
                isButtonTouched = "playButton"
            }
            
            if touchedNode.name == "buttonLeft" {
                Animations.shared.shrink(node: buttonLeft)
                isButtonTouched = "buttonLeft"
            }
            
            if touchedNode.name == "buttonRight" {
                Animations.shared.shrink(node: buttonRight)
                isButtonTouched = "buttonRight"
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "homeButton" {
                Animations.shared.expand(node: homeButton)
                backToTitle(node: homeButton)
            } else if touchedNode.name != "" && isButtonTouched == "homeButton" {
                Animations.shared.expand(node: homeButton)
            }
            
            if touchedNode.name == "playButton" {
                if theme == "silo" {
                    if isSiloLocked == true {
                        Animations.shared.expand(node: playButton)
                        
                        // use animation unless deciding to hide playButton if level is locked
                        
                        let shakeLeft = SKAction.rotate(toAngle: (1 / 36) * .pi, duration: 0.06, shortestUnitArc: true)
                        let shakeRight = SKAction.rotate(toAngle: (71 / 36) * .pi, duration: 0.06, shortestUnitArc: true)
                        let center = SKAction.rotate(toAngle: 0, duration: 0.06, shortestUnitArc: true)
                        let seq = SKAction.sequence([shakeLeft, shakeRight, center])
                        lockedText.run(seq)
//                        lockSprite.run(seq)
                        
                    } else {
                        Animations.shared.expand(node: playButton)
                        startGame()
                    }
                } else {
                    Animations.shared.expand(node: playButton)
                    startGame()
                }
                
            } else if touchedNode.name != "playButton" && isButtonTouched == "playButton" {
                Animations.shared.expand(node: playButton)
            }
            
            if touchedNode.name == "buttonLeft" {
                Animations.shared.expand(node: buttonLeft)
                
                if theme == "castle" {
                    setPreview(currentPreview: "silo")
                } else if theme == "chasm" {
                    setPreview(currentPreview: "castle")
                } else if theme == "silo" {
                    setPreview(currentPreview: "chasm")
                }
                
//                if previewBackgroundTexture == chasmPreview {
//                    setPreview(currentPreview: "castle")
//                } else {
//                    setPreview(currentPreview: "chasm") // remove this when adding the third level
//                }
            } else if touchedNode.name != "buttonLeft" && isButtonTouched == "buttonLeft" {
                Animations.shared.expand(node: buttonLeft)
            }
            
            if touchedNode.name == "buttonRight" {
                Animations.shared.expand(node: buttonRight)
                
                if theme == "castle" {
                    setPreview(currentPreview: "chasm")
                } else if theme == "chasm" {
                    setPreview(currentPreview: "silo")
                } else if theme == "silo" {
                    setPreview(currentPreview: "castle")
                }
                
                
            } else if touchedNode.name != "buttonRight" && isButtonTouched == "buttonRight" {
                Animations.shared.expand(node: buttonRight)
            }
            
            isButtonTouched = ""
        }
    }
}
