//
//  TitleScreen.swift
//  PlaneTest
//
//  Created by Cade Williams on 10/14/20.
//  Copyright © 2020 Cade Williams. All rights reserved.
//

import SpriteKit
import UIKit

var isMusicMuted = true

class TitleScreen: SKScene {
    var logo = SKSpriteNode(imageNamed: "Paper Plane Logo")
    
    var playButton = SKSpriteNode(imageNamed: "Play Button")
    var optionsButton = SKSpriteNode(imageNamed: "Options Button")
    var highScoresButton = SKSpriteNode(imageNamed: "High Scores Button")
    
    var musicButton = SKSpriteNode(imageNamed: "Music Button")
    var closeButton = SKSpriteNode(imageNamed: "Close Button")
    
    var optionsWindow = SKSpriteNode(imageNamed: "Options Window")
    
    var buttonIsPressed = false
    
    var defaultSize = CGSize(width: 256, height: 128)
    
    var isButtonTouched: String!
    
    var buttonContainer = [SKSpriteNode]()
    
    override func didMove(to view: SKView) {
        createButtons()
        
        logo.size = CGSize(width: 512, height: 512)
        logo.position = CGPoint(x: frame.midX, y: frame.midY + 300)
        addChild(logo)
    }
    
    func shrink(node: SKSpriteNode) {
        let shrink = SKAction.scale(to: 0.75, duration: 0.1)
        let fade = SKAction.run {
            node.colorBlendFactor = 0.35
        }
        let sequence = SKAction.sequence([shrink, fade])
        
        node.run(sequence)
    }
    
    func expand(node: SKSpriteNode) {
        
        let wait = SKAction.wait(forDuration: 0.11)
        let expand = SKAction.scale(to: 1.1, duration: 0.075)
        let normal = SKAction.scale(to: 1.0, duration: 0.1)
        let defaultColor = SKAction.run {
            node.alpha = 1
            node.colorBlendFactor = 0
        }
        let sequence = SKAction.sequence([expand, defaultColor, normal])
        
        node.run(sequence)
    }
    
    func createButtons() {
        playButton.size = defaultSize
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        playButton.colorBlendFactor = 0
        playButton.zPosition = 10
        playButton.name = "Play"
        addChild(playButton)
        buttonContainer.append(playButton)
        
        highScoresButton.size = defaultSize
        highScoresButton.position = CGPoint(x: playButton.position.x, y: playButton.position.y - 150)
        highScoresButton.colorBlendFactor = 0
        highScoresButton.zPosition = 10
        highScoresButton.name = "High Scores"
        addChild(highScoresButton)
        buttonContainer.append(highScoresButton)
        
        optionsButton.size = defaultSize
        optionsButton.position = CGPoint(x: highScoresButton.position.x, y: highScoresButton.position.y - 150)
        optionsButton.colorBlendFactor = 0
        optionsButton.zPosition = 10
        optionsButton.name = "Options"
        addChild(optionsButton)
        buttonContainer.append(optionsButton)
    }
    
    func startGame() {
        if let skView = self.view {
            
            guard let scene = GameScene(fileNamed: "GameScene") else { return }
            let transition = SKTransition.fade(withDuration: 1.5)
            
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene, transition: transition)
        }
    }
    
    func optionsMenu(isOpen: Bool) {
        optionsWindow.size = CGSize(width: 512, height: 512)
        optionsWindow.alpha = 1
        optionsWindow.color = .green
        optionsWindow.position = CGPoint(x: frame.midX, y: frame.midY)
        optionsWindow.zPosition = 50
        
        musicButton.size = CGSize(width: 128, height: 128)
        musicButton.alpha = 1
        musicButton.position = CGPoint(x: optionsWindow.frame.midX, y: optionsWindow.frame.midY)
        musicButton.zPosition = 55
        musicButton.name = "Music Button"
        
        if isMusicMuted == false {
            musicButton.texture = SKTexture(imageNamed: "Music Button")
        } else if isMusicMuted == true {
            musicButton.texture = SKTexture(imageNamed: "Music Button Muted")
        }
        
        closeButton.size = CGSize(width: 64, height: 64)
        closeButton.alpha = 1
        closeButton.position = CGPoint(x: optionsWindow.frame.maxX - 10, y: optionsWindow.frame.maxY - 10)
        closeButton.zPosition = 55
        closeButton.name = "Close Button"
        
        let scalePrelim = SKAction.scale(to: CGSize(width: 1, height: 1), duration: 0)
        let scaleMenuUp = SKAction.scale(to: CGSize(width: 512, height: 512), duration: 0.065)
        let scaleButtonsUp = SKAction.scale(to: CGSize(width: 128, height: 128), duration: 0.065)
        
        let scaleSeq = SKAction.sequence([scalePrelim, scaleButtonsUp])
        let menuSequence = SKAction.sequence([scalePrelim, scaleMenuUp])
        
        if isOpen == true {
            addChild(optionsWindow)
            addChild(closeButton)
            addChild(musicButton)
            
            optionsWindow.run(menuSequence)
            musicButton.run(scaleSeq)
//            closeButton.run(scaleSeq)
        } else if isOpen == false {
            optionsWindow.removeFromParent()
            musicButton.removeFromParent()
            closeButton.removeFromParent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
//            guard isButtonTouched == false else { return }
            
//            for node in buttonContainer {
//                if node.name == "Play" || node.name == "Options" {
//                    shrink(node: node)
//                }
//            }
            
            if touchedNode.name == "Play" {
                shrink(node: playButton)
                isButtonTouched = "Play"
            }
            
            if touchedNode.name == "High Scores" {
                shrink(node: highScoresButton)
                isButtonTouched = "High Scores"
            }
            
            if touchedNode.name == "Options" {
                shrink(node: optionsButton)
                isButtonTouched = "Options"
            }
            
            if touchedNode.name == "Music Button" {
                shrink(node: musicButton)
                isButtonTouched = "Music Button"
            }
            
            if touchedNode.name == "Close Button" {
                shrink(node: closeButton)
                isButtonTouched = "Close Button"
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            
            if touchedNode.name == "Play" && isButtonTouched == "Play" {
                startGame()
                expand(node: playButton)
            } else if touchedNode.name != "Play" && isButtonTouched == "Play" {
                expand(node: playButton)
            }
            
            if touchedNode.name == "High Scores" && isButtonTouched == "High Scores" {
                expand(node: highScoresButton)
            } else if touchedNode.name != "High Scores" && isButtonTouched == "High Scores" {
                expand(node: highScoresButton)
            }
            
            if touchedNode.name == "Options" && isButtonTouched == "Options" {
                optionsMenu(isOpen: true)
                expand(node: optionsButton)
                for node in buttonContainer { node.isUserInteractionEnabled = true }
                
            } else if touchedNode.name != "Options" && isButtonTouched == "Options" {
                expand(node: optionsButton)
            }
            
            if touchedNode.name == "Music Button" && isButtonTouched == "Music Button" {
                isMusicMuted.toggle()
                expand(node: musicButton)
                
                if isMusicMuted == false {
                    musicButton.texture = SKTexture(imageNamed: "Music Button")
                } else if isMusicMuted == true {
                    musicButton.texture = SKTexture(imageNamed: "Music Button Muted")
                }
                
            } else if touchedNode.name != "Music Button" && isButtonTouched == "Music Button" {
                expand(node: musicButton)
            }
            
            if touchedNode.name == "Close Button" && isButtonTouched == "Close Button" {
                optionsMenu(isOpen: false)
                expand(node: closeButton)
                
                for node in buttonContainer { node.isUserInteractionEnabled = false }
            } else if touchedNode.name != "Close Button" && isButtonTouched == "Close Button" {
                expand(node: closeButton)
            }
            
            isButtonTouched = ""
//            expand(node: playButton)
//            expand(node: optionsButton)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
//        print(buttonIsPressed)
        print(optionsButton.isUserInteractionEnabled)
    }
    
    deinit {
        print("All Good")
    }
}
