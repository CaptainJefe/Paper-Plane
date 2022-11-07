//
//  WorldSelect.swift
//  PlaneTest
//
//  Created by Cade Williams on 11/2/22.
//  Copyright © 2022 Cade Williams. All rights reserved.
//

import Foundation
import SpriteKit

class WorldSelect: SKScene {
    
    var previewBackground = SKSpriteNode(imageNamed: "castle_preview")
    var previewLabel = SKSpriteNode(imageNamed: "castle_label")
    
    let castlePreview = SKTexture(imageNamed: "castle_preview")
    let castleLabel = SKTexture(imageNamed: "castle_label")
    
    let chasmPreview = SKTexture(imageNamed: "chasm_preview")
    let chasmLabel = SKTexture(imageNamed: "chasm_label")
    
    let siloPreview = SKTexture(imageNamed: "")
    let siloLabel = SKTexture(imageNamed: "")
    
    var previewBackgroundTexture: SKTexture! { didSet { previewBackground.texture = previewBackgroundTexture } }
    var previewLabelTexture: SKTexture! { didSet { previewLabel.texture = previewLabelTexture } }
    
    var buttonLeft: SKSpriteNode!
    var buttonRight: SKSpriteNode!
    var homeButton: SKSpriteNode!
    var playButton: SKSpriteNode!
    
    var isButtonTouched: String!
    var firstLoad: Bool = true
    
    override func didMove(to view: SKView) {
        setPreview(currentPreview: "castle")
        worldPreview()
        createUI()
        
        firstLoad = false
    }
    
    func createUI() {
        homeButton = SKSpriteNode(imageNamed: "Home Button")
        homeButton.size = CGSize(width: 32, height: 32)
        homeButton.position = CGPoint(x: frame.maxX * 0.9, y: frame.maxY * 0.95)
        homeButton.zPosition = 200
        homeButton.name = "homeButton"
        addChild(homeButton)
        
        playButton = SKSpriteNode(imageNamed: "play_icon")
        playButton.size = CGSize(width: 64, height: 64)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY / 4)
        playButton.zPosition = 200
        playButton.name = "playButton"
        addChild(playButton)
        
        buttonLeft = SKSpriteNode(imageNamed: "arrow_left")
        buttonLeft.size = CGSize(width: 64, height: 64)
        buttonLeft.position = CGPoint(x: frame.maxX * 0.15, y: frame.midY / 4)
        buttonLeft.zPosition = 140
        buttonLeft.name = "buttonLeft"
        addChild(buttonLeft)
        
        buttonRight = SKSpriteNode(imageNamed: "arrow_right")
        buttonRight.size = CGSize(width: 64, height: 64)
        buttonRight.position = CGPoint(x: frame.maxX * 0.85, y: frame.midY / 4)
        buttonRight.zPosition = 140
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
    
    // Need to implement a disable of world change buttons while preview is being changed
    func setPreview(currentPreview: String) {
        switch currentPreview {
        case "castle":
            
            if firstLoad == true {
                previewBackgroundTexture = castlePreview
                previewLabelTexture = castleLabel
            } else {
                animateBackground(texture: castlePreview)
                animateLabel(texture: castleLabel)
            }
            
            theme = "castle"
        case "chasm":
            animateBackground(texture: chasmPreview)
            animateLabel(texture: chasmLabel)
            
            theme = "chasm"
        case "silo":
            previewBackgroundTexture = siloPreview
            previewLabelTexture = siloLabel
            
            theme = "silo"
        default:
            previewBackgroundTexture = castlePreview
            previewLabelTexture = castleLabel
            
            theme = "castle"
        }
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
                Animations.shared.shrink(node: playButton)
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
                Animations.shared.expand(node: playButton)
                startGame()
            } else if touchedNode.name != "playButton" && isButtonTouched == "playButton" {
                Animations.shared.expand(node: playButton)
            }
            
            if touchedNode.name == "buttonLeft" {
                Animations.shared.expand(node: buttonLeft)
                
                if previewBackgroundTexture == chasmPreview {
                    setPreview(currentPreview: "castle")
                } else {
                    setPreview(currentPreview: "chasm") // remove this when adding the third level
                }
            } else if touchedNode.name != "buttonLeft" && isButtonTouched == "buttonLeft" {
                Animations.shared.expand(node: buttonLeft)
            }
            
            if touchedNode.name == "buttonRight" {
                Animations.shared.expand(node: buttonRight)
                
                if previewBackgroundTexture == castlePreview {
                    setPreview(currentPreview: "chasm")
                } else {
                    setPreview(currentPreview: "castle") // remove this when adding the third level
                }
            } else if touchedNode.name != "buttonRight" && isButtonTouched == "buttonRight" {
                Animations.shared.expand(node: buttonRight)
            }
        }
    }
}
