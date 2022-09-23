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
    var background: SKSpriteNode!
    
    var playButton = SKSpriteNode(imageNamed: "Play Button")
    var optionsButton = SKSpriteNode(imageNamed: "Options Button")
    var highScoresButton = SKSpriteNode(imageNamed: "High Scores Button")
    
    var worldSelectButton1 = SKSpriteNode(imageNamed: "Castle Icon")
    var worldSelectButton2 = SKSpriteNode(imageNamed: "Cave Icon")
    
    var musicButton = SKSpriteNode(imageNamed: "Music Button")
    var closeButton = SKSpriteNode(imageNamed: "Close Button")
    
    var worldSelectWindow = SKSpriteNode(imageNamed: "High Scores Window")
    var highScoresWindow = SKSpriteNode(imageNamed: "High Scores Window")
    var optionsWindow = SKSpriteNode(imageNamed: "Options Window")
    
    var lastMenuOpened: String!
    
    var buttonIsPressed = false
    
    var bigButtonSize = CGSize(width: 256, height: 128)
    var smallButtonSize = CGSize(width: 160, height: 160)
    
    var isButtonTouched: String!
    
    var buttonContainer = [SKSpriteNode]()
    
    var hasBeenOpened: Bool = false
    
    var hsLabel: SKLabelNode!
    var labelContainer = [SKLabelNode]()
    
    
    override func didMove(to view: SKView) {
        createButtons()
//        scoreList()
        
        background = SKSpriteNode(imageNamed: "Title Screen BG")
        background.size = CGSize(width: frame.size.width, height: frame.size.width * 2.5)
        background.position = CGPoint(x: frame.size.width, y: frame.size.height)
        background.anchorPoint = CGPoint(x: 1, y: 1)
        background.zPosition = -10
        addChild(background)
        
        logo.size = CGSize(width: logo.size.width * 2.5, height: logo.size.height * 2.5)
        logo.position = CGPoint(x: frame.midX, y: frame.maxY / 1.4)
        addChild(logo)
    }
    
    
    func addBlur(node: SKSpriteNode) {
        let blurNode = SKEffectNode()
        let blur = CIFilter(name: "CIGaussianBlur")
        let blurAmount = 4.0
        blur?.setValue(blurAmount, forKey: kCIInputRadiusKey)
        blurNode.filter = blur
        blurNode.shouldEnableEffects = true
        self.addChild(blurNode)
        node.removeFromParent()
        blurNode.addChild(node)
        blurNode.name = "blur"
        
        blurNode.run(SKAction.customAction(withDuration: 0.10, actionBlock: { (node: SKNode, elapsedTime: CGFloat) in
            blurNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": elapsedTime * 30])
        }))
    }
    
    
    func createButtons() {
        playButton.size = CGSize(width: frame.size.width / 2, height: frame.size.width / 4)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY / 1.1)
        playButton.colorBlendFactor = 0
        playButton.zPosition = 10
        playButton.name = "Play"
        addChild(playButton)
        buttonContainer.append(playButton)
        
        highScoresButton.size = CGSize(width: frame.size.width / 2, height: frame.size.width / 4)
        highScoresButton.position = CGPoint(x: playButton.position.x, y: playButton.position.y - 130)
        highScoresButton.colorBlendFactor = 0
        highScoresButton.zPosition = 10
        highScoresButton.name = "High Scores"
        addChild(highScoresButton)
        buttonContainer.append(highScoresButton)
        
        optionsButton.size = CGSize(width: frame.size.width / 4, height: frame.size.width / 4)
        optionsButton.position = CGPoint(x: frame.maxX - (frame.size.width * 0.10), y: frame.minY + (frame.size.height * 0.05))
        optionsButton.colorBlendFactor = 0
        optionsButton.zPosition = 10
        optionsButton.name = "Options"
        addChild(optionsButton)
        buttonContainer.append(optionsButton)
    }
    
    
    func startGame() {
        if let skView = self.view {
            
            guard let scene = GameSceneNew(fileNamed: "GameSceneNew") else { return }
            scene.size = skView.frame.size
            
            let transition = SKTransition.fade(withDuration: 1.5)
            
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene, transition: transition)
        }
    }

    
    func worldSelect() {
        // worldSelectButton 2 original position: CGPoint(x: frame.midX, y: worldSelectButton1.position.y - worldSelectButton1.position.y / 2)
        
        worldSelectButton1.size = CGSize(width: worldSelectButton1.texture!.size().width * 2.5, height: worldSelectButton1.texture!.size().height * 2.5)
        worldSelectButton1.alpha = 1
        worldSelectButton1.position = CGPoint(x: frame.midX, y: -frame.maxY * 0.65)
        worldSelectButton1.zPosition = 55
        worldSelectButton1.name = "World 1"
        
        worldSelectButton2.size = CGSize(width: worldSelectButton2.texture!.size().width * 2.5, height: worldSelectButton2.texture!.size().height * 2.5)
        worldSelectButton2.alpha = 1
        worldSelectButton2.position = CGPoint(x: frame.midX, y: worldSelectButton1.position.y + worldSelectButton1.size.height * 1.2)
        worldSelectButton2.zPosition = 55
        worldSelectButton2.name = "World 2"
        
        closeButton.size = CGSize(width: 64, height: 64)
        closeButton.alpha = 1
        closeButton.position = CGPoint(x: frame.midX, y: frame.maxY * 0.9)
        closeButton.zPosition = 55
        closeButton.name = "Close Button"

        addChild(closeButton)
        addChild(worldSelectButton1)
        addChild(worldSelectButton2)
        
        Animations.shared.moveUIY(node: worldSelectButton1, duration: 0.25)
        Animations.shared.moveUIY(node: worldSelectButton2, duration: 0.25)
        
        Animations.shared.moveUIX(node: logo, duration: 0.25)
        Animations.shared.moveUIX(node: playButton, duration: 0.25)
        Animations.shared.moveUIX(node: highScoresButton, duration: 0.25)
        Animations.shared.moveUIX(node: optionsButton, duration: 0.25)
        
        addBlur(node: background)
        
        lastMenuOpened = "WorldSelect"
    }
    

    func highScoresMenu() {
        
        highScoresWindow.size = CGSize(width: highScoresWindow.size.width, height: highScoresWindow.size.height)
        highScoresWindow.setScale(1.7)
        highScoresWindow.alpha = 1
        highScoresWindow.color = .green
        highScoresWindow.position = CGPoint(x: frame.midX, y: frame.midY)
        highScoresWindow.zPosition = 50
        
        closeButton.size = CGSize(width: 48, height: 48)
        closeButton.alpha = 1
        closeButton.position = CGPoint(x: highScoresWindow.frame.maxX - 10, y: highScoresWindow.frame.maxY - 10)
        closeButton.zPosition = 55
        closeButton.name = "Close Button"
        
        let scalePrelim = SKAction.scale(to: CGSize(width: 1, height: 1), duration: 0)
        let scaleMenuUp = SKAction.scale(to: CGSize(width: highScoresWindow.size.width, height: highScoresWindow.size.height), duration: 0.065)
        let menuSequence = SKAction.sequence([scalePrelim, scaleMenuUp])
        
        var scores = GameplayStats.shared.getScore()?.sorted(by: >)
        
//        addChild(highScoresWindow)
        addChild(closeButton)
        
        logo.isHidden = true
        playButton.isHidden = true
        highScoresButton.isHidden = true
        optionsButton.isHidden = true
        
        highScoresWindow.run(menuSequence)
        scoreList()
        
        lastMenuOpened = "HighScores"
    }
    
    
    func optionsMenu() {
        optionsWindow.size = CGSize(width: frame.size.width * 0.8, height: frame.size.width * 0.8)
        optionsWindow.alpha = 1
        optionsWindow.color = .green
        optionsWindow.position = CGPoint(x: frame.midX, y: frame.midY)
        optionsWindow.zPosition = 50
        
        musicButton.size = CGSize(width: 96, height: 96)
        musicButton.alpha = 1
        musicButton.position = CGPoint(x: optionsWindow.frame.midX, y: optionsWindow.frame.midY)
        musicButton.zPosition = 55
        musicButton.name = "Music Button"
        
        if isMusicMuted == false {
            musicButton.texture = SKTexture(imageNamed: "Music Button")
        } else if isMusicMuted == true {
            musicButton.texture = SKTexture(imageNamed: "Music Button Muted")
        }
        
        closeButton.size = CGSize(width: 48, height: 48)
        closeButton.alpha = 1
        closeButton.position = CGPoint(x: optionsWindow.frame.maxX * 0.98, y: optionsWindow.frame.maxY)
        closeButton.zPosition = 55
        closeButton.name = "Close Button"
        
        let scalePrelim = SKAction.scale(to: CGSize(width: 1, height: 1), duration: 0)
        let scaleMenuUp = SKAction.scale(to: CGSize(width: frame.size.width * 0.8, height: frame.size.width * 0.8), duration: 0.065)
        let scaleButtonsUp = SKAction.scale(to: CGSize(width: 96, height: 96), duration: 0.065)
        
        let scaleSeq = SKAction.sequence([scalePrelim, scaleButtonsUp])
        let menuSequence = SKAction.sequence([scalePrelim, scaleMenuUp])
        
        addChild(optionsWindow)
        addChild(closeButton)
        addChild(musicButton)
        
        optionsWindow.run(menuSequence)
        musicButton.run(scaleSeq)
        lastMenuOpened = "Options"
        
        logo.run(SKAction.fadeAlpha(to: 0.35, duration: 0.15))
        playButton.run(SKAction.fadeAlpha(to: 0.35, duration: 0.15))
        highScoresButton.run(SKAction.fadeAlpha(to: 0.35, duration: 0.15))
        optionsButton.run(SKAction.fadeAlpha(to: 0.35, duration: 0.15))
        
//        logo.alpha = 0.35
//        playButton.alpha = 0.35
//        highScoresButton.alpha = 0.35
//        optionsButton.alpha = 0.35
    }
    
    
    func closeMenu() {
        
        switch lastMenuOpened {
        case "WorldSelect":
            worldSelectButton1.removeFromParent()
            worldSelectButton2.removeFromParent()
            closeButton.removeFromParent()
            background.removeFromParent()
            childNode(withName: "blur")?.removeFromParent() // blurNode from addBlur() was never being removed, only its child node: background
            addChild(background)
            
            Animations.shared.moveUIY(node: worldSelectButton1, duration: 0.25)
            Animations.shared.moveUIY(node: worldSelectButton2, duration: 0.25)
            
            Animations.shared.moveUIX(node: logo, duration: 0.25)
            Animations.shared.moveUIX(node: playButton, duration: 0.25)
            Animations.shared.moveUIX(node: highScoresButton, duration: 0.25)
            Animations.shared.moveUIX(node: optionsButton, duration: 0.25)
            
        case "HighScores":
//            highScoresWindow.removeFromParent()
            closeButton.removeFromParent()
            
            logo.isHidden = false
            playButton.isHidden = false
            highScoresButton.isHidden = false
            optionsButton.isHidden = false
            
            for label in labelContainer {
                label.removeFromParent()
            }
            
        case "Options":
            optionsWindow.removeFromParent()
            musicButton.removeFromParent()
            closeButton.removeFromParent()
            
            logo.run(SKAction.fadeAlpha(to: 1, duration: 0.15))
            playButton.run(SKAction.fadeAlpha(to: 1, duration: 0.15))
            highScoresButton.run(SKAction.fadeAlpha(to: 1, duration: 0.15))
            optionsButton.run(SKAction.fadeAlpha(to: 1, duration: 0.15))
            
            Animations.shared.rotateCCW(node: optionsButton)
        default:
            break
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
                Animations.shared.shrink(node: playButton)
                isButtonTouched = "Play"
            }
            
            if touchedNode.name == "World 1" {
                Animations.shared.shrink(node: worldSelectButton1)
                isButtonTouched = "World 1"
            }
            
            if touchedNode.name == "World 2" {
                Animations.shared.shrink(node: worldSelectButton2)
                isButtonTouched = "World 2"
            }
            
            if touchedNode.name == "High Scores" {
                Animations.shared.shrink(node: highScoresButton)
                isButtonTouched = "High Scores"
            }
            
            if touchedNode.name == "Options" {
                Animations.shared.rotateCW(node: optionsButton)
                isButtonTouched = "Options"
            }
            
            if touchedNode.name == "Music Button" {
                Animations.shared.shrink(node: musicButton)
                isButtonTouched = "Music Button"
            }
            
            if touchedNode.name == "Close Button" {
                Animations.shared.shrink(node: closeButton)
                isButtonTouched = "Close Button"
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "Play" && isButtonTouched == "Play" {
                worldSelect()
                Animations.shared.expand(node: playButton)
            } else if touchedNode.name != "Play" && isButtonTouched == "Play" {
                Animations.shared.expand(node: playButton)
            }
            
            
            if touchedNode.name == "World 1" && isButtonTouched == "World 1" {
                world = "classic"
                theme = "castle"
                
                startGame()
                Animations.shared.expand(node: worldSelectButton1)
    
            } else if touchedNode.name != "World 1" && isButtonTouched == "World 1" {
                Animations.shared.expand(node: worldSelectButton1)
            }
            
            
            if touchedNode.name == "World 2" && isButtonTouched == "World 2" {
                world = "classic"
                theme = "cave"
                
                startGame()
                Animations.shared.expand(node: worldSelectButton2)
    
            } else if touchedNode.name != "World 2" && isButtonTouched == "World 2" {
                Animations.shared.expand(node: worldSelectButton2)
            }
            
            
            if touchedNode.name == "High Scores" && isButtonTouched == "High Scores" {
                highScoresMenu()
                Animations.shared.expand(node: highScoresButton)
                for node in buttonContainer { node.isUserInteractionEnabled = true }
                
            } else if touchedNode.name != "High Scores" && isButtonTouched == "High Scores" {
                Animations.shared.expand(node: highScoresButton)
            }
            
            
            if touchedNode.name == "Options" && isButtonTouched == "Options" {
                optionsMenu()
                lastMenuOpened = "Options"
                for node in buttonContainer { node.isUserInteractionEnabled = true }
                
            } else if touchedNode.name != "Options" && isButtonTouched == "Options" {
                Animations.shared.rotateCCW(node: optionsButton)
            }
            
            
            if touchedNode.name == "Music Button" && isButtonTouched == "Music Button" {
                isMusicMuted.toggle()
                Animations.shared.expand(node: musicButton)
                
                if isMusicMuted == false {
                    musicButton.texture = SKTexture(imageNamed: "Music Button")
                } else if isMusicMuted == true {
                    musicButton.texture = SKTexture(imageNamed: "Music Button Muted")
                }
                
            } else if touchedNode.name != "Music Button" && isButtonTouched == "Music Button" {
                Animations.shared.expand(node: musicButton)
            }
            
            
            if touchedNode.name == "Close Button" && isButtonTouched == "Close Button" {
                closeMenu()
                Animations.shared.expand(node: closeButton)
                
                lastMenuOpened = ""
                
                for node in buttonContainer { node.isUserInteractionEnabled = false }
            } else if touchedNode.name != "Close Button" && isButtonTouched == "Close Button" {
                Animations.shared.expand(node: closeButton)
            }
            
            isButtonTouched = ""
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
    
    func scoreList() {
        let scores = GameplayStats.shared.getScore()!.sorted(by: >)
        print("Scores: \([scores])")
        var pos = 0
        
        let scoreArray = [1, 2, 3, 4, 5]
        let scoresAsString = scoreArray.map(String.init)

        // This works, but it doesn't space out the strings in an added position yet
        
        for highscore in scoresAsString {
            hsLabel = SKLabelNode(fontNamed: "Times New Roman")
            hsLabel.text = highscore as String
            hsLabel.fontSize = 50
            hsLabel.fontColor = SKColor.white
            hsLabel.position = CGPoint(x: self.frame.midX, y: (frame.maxY - 50) / 1.1)
            hsLabel.zPosition = 1000
            hsLabel.name = "hsLabel"
            self.addChild(hsLabel)
            labelContainer.append(hsLabel)
        }
    }
}
