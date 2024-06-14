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
    
    var areButtonsEnabled = true
    
    var isButtonTouched: String!
    var firstLoad: Bool = true
    
    var lockSprite: SKSpriteNode!
    var lockedText: SKLabelNode!
    var lockedText2: SKLabelNode!
    var lockedText3: SKLabelNode!
    var lockedTextNodes: [SKLabelNode]!
    
    var chasmUnlockReq: Int = 15
    
    var levelIndicator = SKSpriteNode(imageNamed: "level_indicator_1")
    
    override func didMove(to view: SKView) {
        
        let scores = SavedData.shared.getScore()
        
        for value in scores ?? [] {
            if isSiloLocked == true {
                if value >= 50 {
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
        setPreview(currentPreview: "castle")
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
        buttonLeft.size = CGSize(width: 48, height: 48)
        buttonLeft.position = CGPoint(x: frame.maxX * 0.08, y: frame.midY)
        buttonLeft.zPosition = 180
        buttonLeft.name = "buttonLeft"
        addChild(buttonLeft)
        
        buttonRight = SKSpriteNode(imageNamed: "arrow_right")
        buttonRight.size = CGSize(width: 48, height: 48)
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
    
    func worldLocked() {
        // change to a switch case if there are more levels that are locked
        
        // Sets default values so changing from one locked level to the other doesn't stack previous colorBlendFactor values
        previewBackground.color = .clear
        previewBackground.colorBlendFactor = 0
        
        // note: swapping between two locked levels, the text get swapped and can be seen being changed before the new level preview appears
        
        if isSiloLocked == true {
            if theme == "silo" {
                
                lockedText.text = "Get a score"
                lockedText2.text = "of 50 or more"
                lockedText3.text = "to unlock!"
                
                Animations.shared.fadeAlphaIn(node: lockSprite, duration: 0.4, waitTime: 0.3)
                Animations.shared.colorize(node: previewBackground, color: .darkGray, colorBlendFactor: 0.85, duration: 0.3)
                Animations.shared.fadeAlphaIn(node: lockedText, duration: 0.4, waitTime: 0.3)
                Animations.shared.fadeAlphaIn(node: lockedText2, duration: 0.4, waitTime: 0.3)
                Animations.shared.fadeAlphaIn(node: lockedText3, duration: 0.4, waitTime: 0.3)
            } else {
                Animations.shared.fadeAlphaOut(node: lockSprite, duration: 0.4, waitTime: 0)
                Animations.shared.colorize(node: previewBackground, color: .clear, colorBlendFactor: 0, duration: 0.3)
                Animations.shared.fadeAlphaOut(node: lockedText, duration: 0.0, waitTime: 0)
                Animations.shared.fadeAlphaOut(node: lockedText2, duration: 0.0, waitTime: 0)
                Animations.shared.fadeAlphaOut(node: lockedText3, duration: 0.0, waitTime: 0)
            }
        }
            
        if isChasmLocked == true {
            if theme == "chasm" {
                    
                
                if chasmUnlockReq - gamesPlayed == 1 {
                    lockedText.text = "Play \(chasmUnlockReq - gamesPlayed)"
                    lockedText2.text = "more round"
                    lockedText3.text = "to unlock!"
                } else {
                    lockedText.text = "Play \(chasmUnlockReq - gamesPlayed)"
                    lockedText2.text = "more rounds"
                    lockedText3.text = "to unlock!"
                }
                
                Animations.shared.fadeAlphaIn(node: lockSprite, duration: 0.4, waitTime: 0.3)
                Animations.shared.colorize(node: previewBackground, color: .darkGray, colorBlendFactor: 0.85, duration: 0.3)
                Animations.shared.fadeAlphaIn(node: lockedText, duration: 0.4, waitTime: 0.3)
                Animations.shared.fadeAlphaIn(node: lockedText2, duration: 0.4, waitTime: 0.3)
                Animations.shared.fadeAlphaIn(node: lockedText3, duration: 0.4, waitTime: 0.3)
            } else {
                Animations.shared.fadeAlphaOut(node: lockSprite, duration: 0.4, waitTime: 0)
                Animations.shared.colorize(node: previewBackground, color: .clear, colorBlendFactor: 0, duration: 0.3)
                Animations.shared.fadeAlphaOut(node: lockedText, duration: 0.0, waitTime: 0)
                Animations.shared.fadeAlphaOut(node: lockedText2, duration: 0.0, waitTime: 0)
                Animations.shared.fadeAlphaOut(node: lockedText3, duration: 0.0, waitTime: 0)
            }
        }
    }
    
    // Need to implement a disable of world change buttons while preview is being changed
    func setPreview(currentPreview: String) {
        
        switch currentPreview {
        case "castle":
            theme = "castle"
            
            if firstLoad == true {
                previewBackgroundTexture = castlePreview
                previewLabelTexture = castleLabel
            } else {
                levelIndicator.texture = SKTexture(imageNamed: "level_indicator_1")
                animateBackground(texture: castlePreview)
                animateLabel(texture: castleLabel)
            }
            
            
//            playButton.isHidden = false
            
        case "chasm":
            theme = "chasm"
            
            levelIndicator.texture = SKTexture(imageNamed: "level_indicator_2")
            animateBackground(texture: chasmPreview)
            animateLabel(texture: chasmLabel)
            
            
            if isChasmLocked == true {
//                playButton.isHidden = true
            } else {
//                playButton.isHidden = false
            }
            
        case "silo":
            theme = "silo"
            
            levelIndicator.texture = SKTexture(imageNamed: "level_indicator_3")
            animateBackground(texture: siloPreview)
            animateLabel(texture: siloLabel)
            
            
            if isSiloLocked == true {
//                playButton.isHidden = true
            } else {
//                playButton.isHidden = false
            }
            
        default:
            levelIndicator.texture = SKTexture(imageNamed: "level_indicator_1")
            previewBackgroundTexture = castlePreview
            previewLabelTexture = castleLabel
            
            theme = "castle"
            
//            playButton.isHidden = false
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "homeButton" {
                Animations.shared.shrink(node: homeButton)
                isButtonTouched = "homeButton"
            }
            
            if touchedNode.name == "previewBackground" {
                if theme == "chasm" {
                    if isChasmLocked == true {
                        return
                    } else {
                        Animations.shared.fadeAlphaTo(node: previewBackground, alpha: 0.5, duration: 0.1, waitTime: 0)
                    }
                } else if theme == "silo" {
                    if isSiloLocked == true {
                        return
                    } else {
                        Animations.shared.fadeAlphaTo(node: previewBackground, alpha: 0.5, duration: 0.1, waitTime: 0)
                    }
                } else {
                    Animations.shared.fadeAlphaTo(node: previewBackground, alpha: 0.5, duration: 0.1, waitTime: 0)
                }
                    
                isButtonTouched = "previewBackground"
            }
            
            if touchedNode.name == "buttonLeft" && areButtonsEnabled == true {
                Animations.shared.shrink(node: buttonLeft)
                isButtonTouched = "buttonLeft"
            }
            
            if touchedNode.name == "buttonRight" && areButtonsEnabled == true {
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
            
            // alpha fade in
            
            let fadeIn = SKAction.run {
                Animations.shared.fadeAlphaIn(node: self.previewBackground, duration: 0.25, waitTime: 0)
            }
            let wait = SKAction.wait(forDuration: 0.45)
            let sequence = SKAction.sequence([fadeIn, wait])
            
            // shakes text (and lock sprite) if level is locked
            
            let shakeLeft = SKAction.rotate(toAngle: (1 / 36) * .pi, duration: 0.06, shortestUnitArc: true)
            let shakeRight = SKAction.rotate(toAngle: (71 / 36) * .pi, duration: 0.06, shortestUnitArc: true)
            let center = SKAction.rotate(toAngle: 0, duration: 0.06, shortestUnitArc: true)
            let seq = SKAction.sequence([shakeLeft, shakeRight, center])
            
            if touchedNode.name == "previewBackground" {
                if theme == "chasm" {
                    if isChasmLocked == true {
                        lockedText.run(seq)
                        lockedText2.run(seq)
                        lockedText3.run(seq)
                        lockSprite.run(seq)
                    } else {
                        previewBackground.isUserInteractionEnabled = true
                        Audio.shared.playSFX(sound: "sound_effect")
                        run(sequence, completion: { self.startGame() } )
                    }
                } else if theme == "silo" {
                    if isSiloLocked == true {
                        lockedText.run(seq)
                        lockedText2.run(seq)
                        lockedText3.run(seq)
                        lockSprite.run(seq)
                    } else {
                        previewBackground.isUserInteractionEnabled = true
                        Audio.shared.playSFX(sound: "sound_effect")
                        run(sequence, completion: { self.startGame() } )
                    }
                } else {
                    previewBackground.isUserInteractionEnabled = true
                    Audio.shared.playSFX(sound: "sound_effect")
                    run(sequence, completion: { self.startGame() } )
                }
            } else if touchedNode.name != "previewBackground" && isButtonTouched == "previewBackground" {
                run(fadeIn)
            }
            
            

            if touchedNode.name == "buttonLeft" && areButtonsEnabled == true {
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
            
            if touchedNode.name == "buttonRight" && areButtonsEnabled == true {
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
