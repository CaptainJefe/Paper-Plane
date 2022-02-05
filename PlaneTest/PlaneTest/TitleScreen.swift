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
    
    var worldSelectButton1 = SKSpriteNode(imageNamed: "Restart Button")
    var worldSelectButton2 = SKSpriteNode(imageNamed: "Restart Button")
    
    var musicButton = SKSpriteNode(imageNamed: "Music Button")
    var closeButton = SKSpriteNode(imageNamed: "Close Button")
    
    var worldSelectWindow = SKSpriteNode(imageNamed: "High Scores Window")
    var highScoresWindow = SKSpriteNode(imageNamed: "High Scores Window")
    var optionsWindow = SKSpriteNode(imageNamed: "Options Window")
    
    var buttonIsPressed = false
    
    var bigButtonSize = CGSize(width: 256, height: 128)
    var smallButtonSize = CGSize(width: 160, height: 160)
    
    var isButtonTouched: String!
    
    var buttonContainer = [SKSpriteNode]()
    
    override func didMove(to view: SKView) {
        createButtons()
        
        let background = SKSpriteNode(imageNamed: "Title Screen BG")
        background.size = CGSize(width: frame.size.width, height: frame.size.height)
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.zPosition = -10
//        addChild(background)
        
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
    
    func rotateCW(node: SKSpriteNode) {
        let rotateCW = SKAction.rotate(byAngle: -.pi, duration: 0.4)
        
        node.run(rotateCW)
    }
    
    func rotateCCW(node: SKSpriteNode) {
        let rotateCCW = SKAction.rotate(byAngle: .pi, duration: 0.4)
        
        node.run(rotateCCW)
    }
    
    
    func createButtons() {
        playButton.size = bigButtonSize
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        playButton.colorBlendFactor = 0
        playButton.zPosition = 10
        playButton.name = "Play"
        addChild(playButton)
        buttonContainer.append(playButton)
        
        highScoresButton.size = bigButtonSize
        highScoresButton.position = CGPoint(x: playButton.position.x, y: playButton.position.y - 175)
        highScoresButton.colorBlendFactor = 0
        highScoresButton.zPosition = 10
        highScoresButton.name = "High Scores"
        addChild(highScoresButton)
        buttonContainer.append(highScoresButton)
        
        optionsButton.size = smallButtonSize
        optionsButton.position = CGPoint(x: frame.maxX - 150, y: frame.minY + 100)
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
    
    // World Select Window as well as World Select Buttons
    
    func worldSelect(isOpen: Bool) {
        worldSelectWindow.size = CGSize(width: 512, height: 1024)
        worldSelectWindow.alpha = 1
        worldSelectWindow.color = .red
        worldSelectWindow.position = CGPoint(x: frame.midX, y: frame.midY)
        worldSelectWindow.zPosition = 50
        
        worldSelectButton1.size = CGSize(width: 128, height: 128)
        worldSelectButton1.alpha = 1
        worldSelectButton1.position = CGPoint(x: worldSelectWindow.frame.width / 2, y: worldSelectWindow.frame.height)
        worldSelectButton1.zPosition = 55
        worldSelectButton1.name = "World 1"
        
        worldSelectButton2.size = CGSize(width: 128, height: 128)
        worldSelectButton2.alpha = 1
        worldSelectButton2.position = CGPoint(x: worldSelectWindow.frame.width, y: worldSelectWindow.frame.height)
        worldSelectButton2.zPosition = 55
        worldSelectButton2.name = "World 2"
        
        closeButton.size = CGSize(width: 64, height: 64)
        closeButton.alpha = 1
        closeButton.position = CGPoint(x: worldSelectWindow.frame.maxX - 10, y: worldSelectWindow.frame.maxY - 10)
        closeButton.zPosition = 55
        closeButton.name = "Close Button"
        
        let scalePrelim = SKAction.scale(to: CGSize(width: 1, height: 1), duration: 0)
        let scaleMenuUp = SKAction.scale(to: CGSize(width: 512, height: 1024), duration: 0.065)
        
        let menuSequence = SKAction.sequence([scalePrelim, scaleMenuUp])
        
        if isOpen == true {
            addChild(worldSelectWindow)
            addChild(closeButton)
            addChild(worldSelectButton1)
            addChild(worldSelectButton2)
            
            highScoresWindow.run(menuSequence)
//            closeButton.run(scaleSeq)
        } else if isOpen == false {
            worldSelectWindow.removeFromParent()
            closeButton.removeFromParent()
            worldSelectButton1.removeFromParent()
            worldSelectButton2.removeFromParent()
        }
    }
    
    
    func highScoresMenu(isOpen: Bool) {
        highScoresWindow.size = CGSize(width: 512, height: 1024)
        highScoresWindow.alpha = 1
        highScoresWindow.color = .green
        highScoresWindow.position = CGPoint(x: frame.midX, y: frame.midY)
        highScoresWindow.zPosition = 50
        
        closeButton.size = CGSize(width: 64, height: 64)
        closeButton.alpha = 1
        closeButton.position = CGPoint(x: highScoresWindow.frame.maxX - 10, y: highScoresWindow.frame.maxY - 10)
        closeButton.zPosition = 55
        closeButton.name = "Close Button"
        
        let scalePrelim = SKAction.scale(to: CGSize(width: 1, height: 1), duration: 0)
        let scaleMenuUp = SKAction.scale(to: CGSize(width: 512, height: 1024), duration: 0.065)
        
        let menuSequence = SKAction.sequence([scalePrelim, scaleMenuUp])
        
        if isOpen == true {
            addChild(highScoresWindow)
            addChild(closeButton)
            
            highScoresWindow.run(menuSequence)
//            closeButton.run(scaleSeq)
        } else if isOpen == false {
            highScoresWindow.removeFromParent()
            closeButton.removeFromParent()
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
        closeButton.position = CGPoint(x: optionsWindow.frame.maxX - 60, y: optionsWindow.frame.maxY - 60)
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
            
            rotateCCW(node: optionsButton)
            // causes it to rotate when the exit button is clicked on other menus beside options
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
            
            if touchedNode.name == "World 1" {
                shrink(node: worldSelectButton1)
                isButtonTouched = "World 1"
            }
            
            if touchedNode.name == "World 2" {
                shrink(node: worldSelectButton2)
                isButtonTouched = "World 2"
            }
            
            if touchedNode.name == "High Scores" {
                shrink(node: highScoresButton)
                isButtonTouched = "High Scores"
            }
            
            if touchedNode.name == "Options" {
                rotateCW(node: optionsButton)
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
                worldSelect(isOpen: true)
                expand(node: playButton)
            } else if touchedNode.name != "Play" && isButtonTouched == "Play" {
                expand(node: playButton)
            }
            
            
            if touchedNode.name == "World 1" && isButtonTouched == "World 1" {
                world = "classic"
                theme = "castle"
                
                startGame()
                expand(node: worldSelectButton1)
    
            } else if touchedNode.name != "World 1" && isButtonTouched == "World 1" {
                expand(node: worldSelectButton1)
            }
            
            
            if touchedNode.name == "World 2" && isButtonTouched == "World 2" {
                world = "classic"
                theme = "desert"
                
                startGame()
                expand(node: worldSelectButton2)
    
            } else if touchedNode.name != "World 2" && isButtonTouched == "World 2" {
                expand(node: worldSelectButton2)
            }
            
            
            if touchedNode.name == "High Scores" && isButtonTouched == "High Scores" {
                highScoresMenu(isOpen: true)
                expand(node: highScoresButton)
                for node in buttonContainer { node.isUserInteractionEnabled = true }
                
            } else if touchedNode.name != "High Scores" && isButtonTouched == "High Scores" {
                expand(node: highScoresButton)
            }
            
            
            if touchedNode.name == "Options" && isButtonTouched == "Options" {
                optionsMenu(isOpen: true)
                for node in buttonContainer { node.isUserInteractionEnabled = true }
                
            } else if touchedNode.name != "Options" && isButtonTouched == "Options" {
                rotateCCW(node: optionsButton)
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
                highScoresMenu(isOpen: false) // may be buggy\
                worldSelect(isOpen: false)
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
//        print(optionsButton.isUserInteractionEnabled)
    }
    
    
    deinit {
        print("All Good")
    }
}
