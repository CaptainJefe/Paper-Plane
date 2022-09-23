//
//  TitleScreen.swift
//  PlaneTest
//
//  Created by Cade Williams on 10/14/20.
//  Copyright © 2020 Cade Williams. All rights reserved.
//

//import SpriteKit
//import UIKit
//
//var isMusicMuted = true
//
//class TitleScreen: SKScene {
//    var logo = SKSpriteNode(imageNamed: "Paper Plane Logo")
//    var background: SKSpriteNode!
//    
//    var playButton = SKSpriteNode(imageNamed: "Play Button")
//    var optionsButton = SKSpriteNode(imageNamed: "Options Button")
//    var highScoresButton = SKSpriteNode(imageNamed: "High Scores Button")
//    
//    var worldSelectButton1 = SKSpriteNode(imageNamed: "Castle Icon")
//    var worldSelectButton2 = SKSpriteNode(imageNamed: "Cave Icon")
//    
//    var musicButton = SKSpriteNode(imageNamed: "Music Button")
//    var closeButton = SKSpriteNode(imageNamed: "Close Button")
//    
//    var worldSelectWindow = SKSpriteNode(imageNamed: "High Scores Window")
//    var highScoresWindow = SKSpriteNode(imageNamed: "High Scores Window")
//    var optionsWindow = SKSpriteNode(imageNamed: "Options Window")
//    
//    var lastMenuOpened: String!
//    
//    var buttonIsPressed = false
//    
//    var bigButtonSize = CGSize(width: 256, height: 128)
//    var smallButtonSize = CGSize(width: 160, height: 160)
//    
//    var isButtonTouched: String!
//    
//    var buttonContainer = [SKSpriteNode]()
//    
//    var hasBeenOpened: Bool = false
//    
//    var hsLabel: SKLabelNode!
//    var labelContainer = [SKLabelNode]()
//    
//    override func didMove(to view: SKView) {
//        createButtons()
////        scoreList()
//        
//        background = SKSpriteNode(imageNamed: "Title Screen BG")
//        background.size = CGSize(width: frame.size.width, height: frame.size.width * 2.5)
//        background.position = CGPoint(x: frame.size.width, y: frame.size.height)
//        background.anchorPoint = CGPoint(x: 1, y: 1)
//        background.zPosition = -10
//        addChild(background)
//        
//        logo.size = CGSize(width: logo.size.width * 2.5, height: logo.size.height * 2.5)
//        logo.position = CGPoint(x: frame.midX, y: frame.maxY / 1.4)
//        addChild(logo)
//    }
//    
//    func addBlur(node: SKSpriteNode) {
//        let blurNode = SKEffectNode()
//        let blur = CIFilter(name: "CIGaussianBlur")
//        let blurAmount = 4.0
//        blur?.setValue(blurAmount, forKey: kCIInputRadiusKey)
//        blurNode.filter = blur
//        blurNode.shouldEnableEffects = true
//        self.addChild(blurNode)
//        node.removeFromParent()
//        blurNode.addChild(node)
//        
//        blurNode.run(SKAction.customAction(withDuration: 0.10, actionBlock: { (node: SKNode, elapsedTime: CGFloat) in
//            blurNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": elapsedTime * 30])
//        }))
//    }
//    
//    
//    func shrink(node: SKSpriteNode) {
//        let shrink = SKAction.scale(to: 0.75, duration: 0.1)
//        let fade = SKAction.run {
//            node.colorBlendFactor = 0.35
//        }
//        let sequence = SKAction.sequence([shrink, fade])
//        
//        node.run(sequence)
//    }
//    
//    
//    func expand(node: SKSpriteNode) {
//        
//        let wait = SKAction.wait(forDuration: 0.11)
//        let expand = SKAction.scale(to: 1.1, duration: 0.075)
//        let normal = SKAction.scale(to: 1.0, duration: 0.1)
//        let defaultColor = SKAction.run {
//            node.alpha = 1
//            node.colorBlendFactor = 0
//        }
//        let sequence = SKAction.sequence([expand, defaultColor, normal])
//        
//        node.run(sequence)
//    }
//    
//    func rotateCW(node: SKSpriteNode) {
//        let rotateCW = SKAction.rotate(byAngle: -.pi, duration: 0.4)
//        
//        node.run(rotateCW)
//    }
//    
//    func rotateCCW(node: SKSpriteNode) {
//        let rotateCCW = SKAction.rotate(byAngle: .pi, duration: 0.4)
//        
//        node.run(rotateCCW)
//    }
//    
//    
//    func moveUIX(node: SKSpriteNode, duration: TimeInterval) {
//        let nodePositionX = node.position.x
//        
//        let moveNode = SKAction.move(to: CGPoint(x: -nodePositionX, y: node.position.y), duration: duration)
//        node.run(moveNode)
//    }
//    
//    func moveUIY(node: SKSpriteNode, duration: TimeInterval) {
//        let nodePositionY = node.position.y
//        
//        let moveNode = SKAction.move(to: CGPoint(x: node.position.x, y: -nodePositionY), duration: duration)
//        node.run(moveNode)
//    }
//    
//    
//    func createButtons() {
//        playButton.size = CGSize(width: frame.size.width / 2, height: frame.size.width / 4)
//        playButton.position = CGPoint(x: frame.midX, y: frame.midY / 1.1)
//        playButton.colorBlendFactor = 0
//        playButton.zPosition = 10
//        playButton.name = "Play"
//        addChild(playButton)
//        buttonContainer.append(playButton)
//        
//        highScoresButton.size = CGSize(width: frame.size.width / 2, height: frame.size.width / 4)
//        highScoresButton.position = CGPoint(x: playButton.position.x, y: playButton.position.y - 130)
//        highScoresButton.colorBlendFactor = 0
//        highScoresButton.zPosition = 10
//        highScoresButton.name = "High Scores"
//        addChild(highScoresButton)
//        buttonContainer.append(highScoresButton)
//        
//        optionsButton.size = CGSize(width: frame.size.width / 4, height: frame.size.width / 4)
//        optionsButton.position = CGPoint(x: frame.maxX - (frame.size.width * 0.10), y: frame.minY + (frame.size.height * 0.05))
//        optionsButton.colorBlendFactor = 0
//        optionsButton.zPosition = 10
//        optionsButton.name = "Options"
//        addChild(optionsButton)
//        buttonContainer.append(optionsButton)
//    }
//    
//    
//    func startGame() {
//        if let skView = self.view {
//            
//            guard let scene = GameSceneNew(fileNamed: "GameSceneNew") else { return }
//            scene.size = skView.frame.size
//            
//            let transition = SKTransition.fade(withDuration: 1.5)
//            
//            scene.scaleMode = .aspectFill
//            
//            skView.presentScene(scene, transition: transition)
//        }
//    }
//    
//    // World Select Window as well as World Select Buttons
//    
//    func worldSelect(isOpen: Bool) {
//        // worldSelectButton 2 original position: CGPoint(x: frame.midX, y: worldSelectButton1.position.y - worldSelectButton1.position.y / 2)
//        
////        guard isOpen == true else { return }
//        print(hasBeenOpened)
//        
//        
//        worldSelectButton1.size = CGSize(width: worldSelectButton1.texture!.size().width * 2.5, height: worldSelectButton1.texture!.size().height * 2.5)
//        worldSelectButton1.alpha = 1
//        worldSelectButton1.position = CGPoint(x: frame.midX, y: -frame.maxY * 0.65)
//        worldSelectButton1.zPosition = 55
//        worldSelectButton1.name = "World 1"
//        
//        worldSelectButton2.size = CGSize(width: worldSelectButton2.texture!.size().width * 2.5, height: worldSelectButton2.texture!.size().height * 2.5)
//        worldSelectButton2.alpha = 1
//        worldSelectButton2.position = CGPoint(x: frame.midX, y: worldSelectButton1.position.y + worldSelectButton1.size.height * 1.2)
//        worldSelectButton2.zPosition = 55
//        worldSelectButton2.name = "World 2"
//        
//        closeButton.size = CGSize(width: 64, height: 64)
//        closeButton.alpha = 1
//        closeButton.position = CGPoint(x: frame.midX, y: frame.maxY * 0.9)
//        closeButton.zPosition = 55
//        closeButton.name = "Close Button"
//        
//        hasBeenOpened = false // terrible solution to node sizes being multiplied from each time the method is called
//        
////        let moveButton1 = SKAction.move(to: CGPoint(x: frame.midX, y: frame.maxY / 1.5), duration: 0.25)
////        let moveButton2 = SKAction.move(to: CGPoint(x: frame.midX, y: (frame.maxY / 1.5) - (frame.maxY / 1.5) / 2), duration: 0.25)
////
////        let scalePrelim = SKAction.scale(to: CGSize(width: 1, height: 1), duration: 0)
////        let scaleMenuUp = SKAction.scale(to: CGSize(width: 512, height: 1024), duration: 0.1)
////
////        let menuSequence = SKAction.sequence([scalePrelim, scaleMenuUp])
//
//        if isOpen == true {
//            addChild(closeButton)
//            addChild(worldSelectButton1)
//            addChild(worldSelectButton2)
//            
//            
////            worldSelectButton1.run(moveButton1)
////            worldSelectButton2.run(moveButton2)
//            
//            moveUIY(node: worldSelectButton1, duration: 0.25)
//            moveUIY(node: worldSelectButton2, duration: 0.25)
//            
//            moveUIX(node: logo, duration: 0.25)
//            moveUIX(node: playButton, duration: 0.25)
//            moveUIX(node: highScoresButton, duration: 0.25)
//            moveUIX(node: optionsButton, duration: 0.25)
//            
//            
////            logo.isHidden = true
////            playButton.isHidden = true
////            highScoresButton.isHidden = true
////            optionsButton.isHidden = true
//            addBlur(node: background)
//            lastMenuOpened = "WorldSelect"
//            
////            highScoresWindow.run(menuSequence)
////            closeButton.run(scaleSeq)
//        } else if isOpen == false {
//            guard lastMenuOpened == "WorldSelect" else { return }
//            
//            worldSelectButton1.removeFromParent()
//            worldSelectButton2.removeFromParent()
//            closeButton.removeFromParent()
//            background.removeFromParent()
//            addChild(background)
//            
//            logo.isHidden = false
//            playButton.isHidden = false
//            highScoresButton.isHidden = false
//            optionsButton.isHidden = false
//            
//            moveUIY(node: worldSelectButton1, duration: 0.25)
//            moveUIY(node: worldSelectButton2, duration: 0.25)
//            
//            moveUIX(node: logo, duration: 0.25)
//            moveUIX(node: playButton, duration: 0.25)
//            moveUIX(node: highScoresButton, duration: 0.25)
//            moveUIX(node: optionsButton, duration: 0.25)
//        }
//    }
//    
//
//    func highScoresMenu(isOpen: Bool) {
//        
//        highScoresWindow.size = CGSize(width: highScoresWindow.size.width, height: highScoresWindow.size.height)
//        highScoresWindow.setScale(1.7)
//        highScoresWindow.alpha = 1
//        highScoresWindow.color = .green
//        highScoresWindow.position = CGPoint(x: frame.midX, y: frame.midY)
//        highScoresWindow.zPosition = 50
//        
//        closeButton.size = CGSize(width: 48, height: 48)
//        closeButton.alpha = 1
//        closeButton.position = CGPoint(x: highScoresWindow.frame.maxX - 10, y: highScoresWindow.frame.maxY - 10)
//        closeButton.zPosition = 55
//        closeButton.name = "Close Button"
//        
//        let scalePrelim = SKAction.scale(to: CGSize(width: 1, height: 1), duration: 0)
//        let scaleMenuUp = SKAction.scale(to: CGSize(width: highScoresWindow.size.width, height: highScoresWindow.size.height), duration: 0.065)
//        let fadeIn = SKAction.fadeAlpha(to: 0.55, duration: 0.065)
//        
//        let menuSequence = SKAction.sequence([scalePrelim, scaleMenuUp])
//        
//        var scores = GameplayStats.shared.getScore()?.sorted(by: >)
//        
//        
//        if isOpen == true {
//            addChild(highScoresWindow)
//            addChild(closeButton)
//            
//            logo.isHidden = true
//            playButton.isHidden = true
//            highScoresButton.isHidden = true
//            optionsButton.isHidden = true
//            
//            highScoresWindow.run(menuSequence)
//            scoreList()
//            
//            lastMenuOpened = "HighScores"
//            
//            
//            
//
////            closeButton.run(scaleSeq)
//        } else if isOpen == false {
//            guard lastMenuOpened == "HighScores" else { return }
//            highScoresWindow.removeFromParent()
//            closeButton.removeFromParent()
//            
//            
//            logo.isHidden = false
//            playButton.isHidden = false
//            highScoresButton.isHidden = false
//            optionsButton.isHidden = false
//            
//            for label in labelContainer {
//                label.removeFromParent()
//            }
//        }
//    }
//    
//    
//    func optionsMenu(isOpen: Bool) {
//        optionsWindow.size = CGSize(width: frame.size.width * 0.8, height: frame.size.width * 0.8)
//        optionsWindow.alpha = 1
//        optionsWindow.color = .green
//        optionsWindow.position = CGPoint(x: frame.midX, y: frame.midY)
//        optionsWindow.zPosition = 50
//        
//        musicButton.size = CGSize(width: 96, height: 96)
//        musicButton.alpha = 1
//        musicButton.position = CGPoint(x: optionsWindow.frame.midX, y: optionsWindow.frame.midY)
//        musicButton.zPosition = 55
//        musicButton.name = "Music Button"
//        
//        if isMusicMuted == false {
//            musicButton.texture = SKTexture(imageNamed: "Music Button")
//        } else if isMusicMuted == true {
//            musicButton.texture = SKTexture(imageNamed: "Music Button Muted")
//        }
//        
//        closeButton.size = CGSize(width: 48, height: 48)
//        closeButton.alpha = 1
//        closeButton.position = CGPoint(x: optionsWindow.frame.maxX * 0.98, y: optionsWindow.frame.maxY)
//        closeButton.zPosition = 55
//        closeButton.name = "Close Button"
//        
//        let scalePrelim = SKAction.scale(to: CGSize(width: 1, height: 1), duration: 0)
//        let scaleMenuUp = SKAction.scale(to: CGSize(width: frame.size.width * 0.8, height: frame.size.width * 0.8), duration: 0.065)
//        let scaleButtonsUp = SKAction.scale(to: CGSize(width: 96, height: 96), duration: 0.065)
//        
//        let scaleSeq = SKAction.sequence([scalePrelim, scaleButtonsUp])
//        let menuSequence = SKAction.sequence([scalePrelim, scaleMenuUp])
//        
//        if isOpen == true {
//            addChild(optionsWindow)
//            addChild(closeButton)
//            addChild(musicButton)
//            
//            optionsWindow.run(menuSequence)
//            musicButton.run(scaleSeq)
////            closeButton.run(scaleSeq)
//            lastMenuOpened = "Options"
//            
//        } else if isOpen == false {
//            guard lastMenuOpened == "Options" else { return }
//            
//            optionsWindow.removeFromParent()
//            musicButton.removeFromParent()
//            closeButton.removeFromParent()
//            
//            rotateCCW(node: optionsButton)
//        }
//    }
//    
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let location = touch.location(in: self)
//            let touchedNode = atPoint(location)
//            
////            guard isButtonTouched == false else { return }
//            
////            for node in buttonContainer {
////                if node.name == "Play" || node.name == "Options" {
////                    shrink(node: node)
////                }
////            }
//            
//            if touchedNode.name == "Play" {
//                shrink(node: playButton)
//                isButtonTouched = "Play"
//            }
//            
//            if touchedNode.name == "World 1" {
//                shrink(node: worldSelectButton1)
//                isButtonTouched = "World 1"
//            }
//            
//            if touchedNode.name == "World 2" {
//                shrink(node: worldSelectButton2)
//                isButtonTouched = "World 2"
//            }
//            
//            if touchedNode.name == "High Scores" {
//                shrink(node: highScoresButton)
//                isButtonTouched = "High Scores"
//            }
//            
//            if touchedNode.name == "Options" {
//                rotateCW(node: optionsButton)
//                isButtonTouched = "Options"
//            }
//            
//            if touchedNode.name == "Music Button" {
//                shrink(node: musicButton)
//                isButtonTouched = "Music Button"
//            }
//            
//            if touchedNode.name == "Close Button" {
//                shrink(node: closeButton)
//                isButtonTouched = "Close Button"
//            }
//        }
//    }
//    
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let location = touch.location(in: self)
//            let touchedNode = atPoint(location)
//            
//            if touchedNode.name == "Play" && isButtonTouched == "Play" {
//                worldSelect(isOpen: true)
//                expand(node: playButton)
//            } else if touchedNode.name != "Play" && isButtonTouched == "Play" {
//                expand(node: playButton)
//            }
//            
//            
//            if touchedNode.name == "World 1" && isButtonTouched == "World 1" {
//                world = "classic"
//                theme = "castle"
//                
//                startGame()
//                expand(node: worldSelectButton1)
//    
//            } else if touchedNode.name != "World 1" && isButtonTouched == "World 1" {
//                expand(node: worldSelectButton1)
//            }
//            
//            
//            if touchedNode.name == "World 2" && isButtonTouched == "World 2" {
//                world = "classic"
//                theme = "cave"
//                
//                startGame()
//                expand(node: worldSelectButton2)
//    
//            } else if touchedNode.name != "World 2" && isButtonTouched == "World 2" {
//                expand(node: worldSelectButton2)
//            }
//            
//            
//            if touchedNode.name == "High Scores" && isButtonTouched == "High Scores" {
//                highScoresMenu(isOpen: true)
//                expand(node: highScoresButton)
//                for node in buttonContainer { node.isUserInteractionEnabled = true }
//                
//            } else if touchedNode.name != "High Scores" && isButtonTouched == "High Scores" {
//                expand(node: highScoresButton)
//            }
//            
//            
//            if touchedNode.name == "Options" && isButtonTouched == "Options" {
//                optionsMenu(isOpen: true)
//                lastMenuOpened = "Options"
//                for node in buttonContainer { node.isUserInteractionEnabled = true }
//                
//            } else if touchedNode.name != "Options" && isButtonTouched == "Options" {
//                rotateCCW(node: optionsButton)
//            }
//            
//            
//            if touchedNode.name == "Music Button" && isButtonTouched == "Music Button" {
//                isMusicMuted.toggle()
//                expand(node: musicButton)
//                
//                if isMusicMuted == false {
//                    musicButton.texture = SKTexture(imageNamed: "Music Button")
//                } else if isMusicMuted == true {
//                    musicButton.texture = SKTexture(imageNamed: "Music Button Muted")
//                }
//                
//            } else if touchedNode.name != "Music Button" && isButtonTouched == "Music Button" {
//                expand(node: musicButton)
//            }
//            
//            
//            if touchedNode.name == "Close Button" && isButtonTouched == "Close Button" {
//                optionsMenu(isOpen: false)
//                highScoresMenu(isOpen: false) // may be buggy\
//                worldSelect(isOpen: false) // button sizes multiply in size because function is being called more than once. Find another way to do it or where calling it more than once won't multiply node sizes over and over again.
//                expand(node: closeButton)
//                
//                lastMenuOpened = ""
//                
//                for node in buttonContainer { node.isUserInteractionEnabled = false }
//            } else if touchedNode.name != "Close Button" && isButtonTouched == "Close Button" {
//                expand(node: closeButton)
//            }
//            
//            
//            isButtonTouched = ""
////            expand(node: playButton)
////            expand(node: optionsButton)
//        }
//    }
//    
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let location = touch.location(in: self)
//            let touchedNode = atPoint(location)
//        }
//    }
//    
//    
//    override func update(_ currentTime: TimeInterval) {
//        
////        print(buttonIsPressed)
////        print(optionsButton.isUserInteractionEnabled)
//    }
//    
//    
//    deinit {
//        print("All Good")
//    }
//    
//    func scoreList() {
//        let scores = GameplayStats.shared.getScore()!.sorted(by: >) as? [Int]
//        print("Scores: \([scores])")
//        var pos = 0
//        
//        let scoreArray = [1, 2, 3, 4, 5]
//        let scoresAsString = scoreArray.map(String.init)
//
//        // This works, but it doesn't space out the strings in an added position yet
//        
//        for highscore in scoresAsString {
//            hsLabel = SKLabelNode(fontNamed: "Times New Roman")
//            hsLabel.text = highscore as String
//            hsLabel.fontSize = 50
//            hsLabel.fontColor = SKColor.white
//            hsLabel.position = CGPoint(x: self.frame.midX, y: (frame.maxY - 50) / 1.1)
//            hsLabel.zPosition = 1000
//            hsLabel.name = "hsLabel"
//            self.addChild(hsLabel)
//            labelContainer.append(hsLabel)
//        }
////
//        
//    }
//    
//    
//}
