////
////  TitleScreen.swift
////  PlaneTest
////
////  Created by Cade Williams on 10/14/20.
////  Copyright © 2020 Cade Williams. All rights reserved.
////
//
//import SpriteKit
//import UIKit
//import SceneKit
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
//    var worldSelectContainer = [SKSpriteNode]()
//    var worldSelectButton1 = SKSpriteNode(imageNamed: "Castle Icon")
//    var worldSelectButton2 = SKSpriteNode(imageNamed: "Cave Icon")
//    var worldSelectButton3 = SKSpriteNode(imageNamed: "silo_icon")
//    
//    var musicButton = SKSpriteNode(imageNamed: "Music Button")
//    var closeButton = SKSpriteNode(imageNamed: "Close Button")
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
//    var hasBeenOpened: Bool = false
//    
//    var highScoresLabel: SKSpriteNode!
//    var scoreFrame: SKSpriteNode!
//    var scoreFrameContainer = [SKSpriteNode]()
//    var hsLabel: SKLabelNode!
//    var hsNumberLabel: SKLabelNode!
//    var separator: SKSpriteNode!
//    
//    var labelContainer = [SKLabelNode]()
//    var mainUIContainer = [SKNode]()
//    var highScoresUIContainer = [SKNode]()
//    var optionsUIContainer = [SKNode]()
//    
//    var sceneCamera = SKCameraNode()
//    var cameraFocusNode: SKSpriteNode!
//    
//    
//    override func didMove(to view: SKView) {
//        
//        cameraFocusNode = SKSpriteNode()
//        cameraFocusNode.position = CGPoint(x: frame.midX, y: frame.midY)
//        cameraFocusNode.size = CGSize(width: 1, height: 1)
//        cameraFocusNode.alpha = 0
//        addChild(cameraFocusNode)
//        
//        self.camera = sceneCamera
//        
//        createButtons()
//        createHighScores()
//        createOptions()
//        
//        background = SKSpriteNode(imageNamed: "Title Screen BG")
//        background.size = CGSize(width: frame.size.height * 1.5, height: frame.size.height)
//        background.position = CGPoint(x: view.center.x, y: view.center.y)
//        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        background.zPosition = -10
//        addChild(background)
//        mainUIContainer.append(logo)
//        
//        logo.size = CGSize(width: logo.size.width * 2.5, height: logo.size.height * 2.5)
//        logo.position = CGPoint(x: frame.midX, y: frame.maxY / 1.4)
//        addChild(logo)
//    }
//    
//    func setCamera(xPosition: CGFloat) {
//        let moveTo = SKAction.move(to: CGPoint(x: xPosition, y: frame.midY), duration: 0.40)
//        cameraFocusNode.run(moveTo)
//    }
//    
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
//        blurNode.name = "blur"
//        
//        blurNode.run(SKAction.customAction(withDuration: 0.10, actionBlock: { (node: SKNode, elapsedTime: CGFloat) in
//            blurNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": elapsedTime * 30])
//        }))
//    }
//    
//    
//    func createButtons() {
//        playButton.size = CGSize(width: 192, height: 84) // // non number size is CGSize(width: frame.size.width / 2, height: frame.size.width / 4)
//        playButton.position = CGPoint(x: frame.midX, y: frame.midY / 1.1)
//        playButton.colorBlendFactor = 0
//        playButton.zPosition = 10
//        playButton.name = "Play"
//        addChild(playButton)
//        mainUIContainer.append(playButton)
//        
//        highScoresButton.size = CGSize(width: 192, height: 84) // non number size is CGSize(width: frame.size.width / 2, height: frame.size.width / 4)
//        highScoresButton.position = CGPoint(x: playButton.position.x, y: playButton.position.y - 130)
//        highScoresButton.colorBlendFactor = 0
//        highScoresButton.zPosition = 10
//        highScoresButton.name = "High Scores"
//        addChild(highScoresButton)
//        mainUIContainer.append(highScoresButton)
//        
//        optionsButton.size = CGSize(width: frame.size.width / 4, height: frame.size.width / 4)
//        optionsButton.position = CGPoint(x: frame.maxX - (frame.size.width * 0.10), y: frame.minY + (frame.size.height * 0.05))
//        optionsButton.colorBlendFactor = 0
//        optionsButton.zPosition = 10
//        optionsButton.name = "Options"
//        addChild(optionsButton)
//        mainUIContainer.append(optionsButton)
//        
//        worldSelectButton1.size = CGSize(width: worldSelectButton1.texture!.size().width * 2, height: worldSelectButton1.texture!.size().height * 2)
//        worldSelectButton1.alpha = 0
//        worldSelectButton1.position = CGPoint(x: frame.midX * 3, y: frame.maxY * 0.75)
//        worldSelectButton1.zPosition = 55
//        worldSelectButton1.name = "World 1"
//        addChild(worldSelectButton1)
//        worldSelectContainer.append(worldSelectButton1)
//        
//        worldSelectButton2.size = CGSize(width: worldSelectButton2.texture!.size().width * 2, height: worldSelectButton2.texture!.size().height * 2)
//        worldSelectButton2.alpha = 0
//        worldSelectButton2.position = CGPoint(x: worldSelectButton1.position.x, y: worldSelectButton1.position.y - worldSelectButton1.size.height * 1.2)
//        worldSelectButton2.zPosition = 55
//        worldSelectButton2.name = "World 2"
//        addChild(worldSelectButton2)
//        worldSelectContainer.append(worldSelectButton2)
//        
//        worldSelectButton3.size = CGSize(width: worldSelectButton3.texture!.size().width * 2, height: worldSelectButton3.texture!.size().height * 2)
//        worldSelectButton3.alpha = 0
//        worldSelectButton3.position = CGPoint(x: worldSelectButton1.position.x, y: worldSelectButton2.position.y - worldSelectButton1.size.height * 1.2)
//        worldSelectButton3.zPosition = 55
//        worldSelectButton3.name = "World 3"
//        addChild(worldSelectButton3)
//        worldSelectContainer.append(worldSelectButton3)
//    }
//    
//    
////    func startGame() {
////        if let skView = self.view {
////
////            Assets.sharedInstance.preloadGameAssets()
////
////            guard let scene = GameSceneNewNew(fileNamed: "GameSceneNewNew") else { return }
////            scene.size = skView.frame.size
////
////            let transition = SKTransition.fade(withDuration: 1.5)
////
////            scene.scaleMode = .aspectFill
////
////            skView.presentScene(scene, transition: transition)
////        }
////    }
//    
//    func worldSelectMenu() {
//        if let skView = self.view {
//            
//            Assets.sharedInstance.preloadGameAssets()
//            
//            guard let scene = WorldSelect(fileNamed: "WorldSelect") else { return }
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
//    
//    func worldSelect() {
//        // worldSelectButton 2 original position: CGPoint(x: frame.midX, y: worldSelectButton1.position.y - worldSelectButton1.position.y / 2)
//        
//        closeButton.size = CGSize(width: 48, height: 48)
//        closeButton.alpha = 1
//        closeButton.position = CGPoint(x: frame.maxX * 1.88, y: frame.maxY * 0.95)
//        closeButton.zPosition = 80
//        closeButton.name = "Close Button"
//        addChild(closeButton)
//        
//        setCamera(xPosition: frame.midX * 3)
//        
//        var timeIncrease: TimeInterval = 0.0
//        
//        for node in mainUIContainer { Animations.shared.fadeAlphaOut(node: node, duration: 0.25) }
//        for wsButton in worldSelectContainer { Animations.shared.fadeAlphaIn(node: wsButton, duration: 0.25, waitTime: 0.2 + timeIncrease); timeIncrease += 0.15 }
//        
////        Animations.shared.moveUIX(node: worldSelectButton1, duration: 0.25)
////        Animations.shared.moveUIX(node: worldSelectButton2, duration: 0.25)
////
////        Animations.shared.moveUIX(node: logo, duration: 0.25)
////        Animations.shared.moveUIX(node: playButton, duration: 0.25)
////        Animations.shared.moveUIX(node: highScoresButton, duration: 0.25)
////        Animations.shared.moveUIX(node: optionsButton, duration: 0.25)
//        
////        addBlur(node: background)
//        
//        lastMenuOpened = "WorldSelect"
//    }
//    
//    func createHighScores() {
//        
//        highScoresLabel = SKSpriteNode(imageNamed: "highscores_label")
//        highScoresLabel.position = CGPoint(x: frame.midX, y: frame.maxY * 0.88)
//        highScoresLabel.size = CGSize(width: highScoresLabel.size.width * 1.2, height: highScoresLabel.size.height * 1.2)
//        highScoresLabel.zPosition = 80
//        highScoresLabel.alpha = 0
//        addChild(highScoresLabel)
//        
//        let sortedScores = GameplayStats.shared.getScore()?.sorted(by: >)
//        var scoresList = sortedScores ?? [Int](repeating: 0, count: 10)
//        let scoresAsString = scoresList.map(String.init)
//        
//        print("Scores: \(scoresList)")
////        var pos = 0
//        
//        let scoresArray = [Int](repeating: 0, count: 10) // preset array for testing
//        
//        
//        print(scoresAsString)
//
//        // This works, but it doesn't space out the strings in an added position yet
//        
//        var counter: CGFloat = 0
//        var counter2: Int = 0 // counter doesn't compile (takes too long) when set as an Int. This is a temp solution
//        
//        for highscore in scoresAsString.prefix(10) { // scoresAsString[0...4] is also a valid call
//            scoreFrame = SKSpriteNode(imageNamed: "high_scores_frame")
//            scoreFrame.position = CGPoint(x: self.frame.midX, y: ((frame.maxY - 100) + (counter * -120)) / 1.2)
//            scoreFrame.size = CGSize(width: scoreFrame.texture!.size().width * 2.5, height: scoreFrame.texture!.size().height * 2.5)
//            scoreFrame.alpha = 1
//            scoreFrame.zPosition = 150
//            scoreFrame.name = "scoreFrame"
////            addChild(scoreFrame)
//            scoreFrameContainer.append(scoreFrame)
//            
//            hsLabel = SKLabelNode(fontNamed: "Paper Plane Font")
//            hsLabel.text = highscore as String
//            hsLabel.alpha = 0
//            hsLabel.fontSize = 40
//            hsLabel.fontColor = SKColor.white
//            hsLabel.position = CGPoint(x: self.frame.maxX * 0.8, y: ((frame.maxY) + (counter * -75)) / 1.25)
//            hsLabel.zPosition = 160
//            hsLabel.name = "hsLabel"
//            addChild(hsLabel)
//            labelContainer.append(hsLabel)
//            
//            hsNumberLabel = SKLabelNode(fontNamed: "Paper Plane Font")
//            hsNumberLabel.text = "\(counter2 + 1)."
//            hsNumberLabel.alpha = 0
//            hsNumberLabel.fontSize = 40
//            hsNumberLabel.fontColor = .white
//            hsNumberLabel.position = CGPoint(x: self.frame.maxX * 0.2, y: hsLabel.position.y)
//            hsNumberLabel.zPosition = 160
//            hsNumberLabel.name = "hsNumberLabel"
//            addChild(hsNumberLabel)
//            labelContainer.append(hsNumberLabel)
//            
//            separator = SKSpriteNode(imageNamed: "Separator")
//            separator.position = CGPoint(x: self.frame.midX, y: hsLabel.position.y - 40)
//            separator.size = CGSize(width: frame.width / 1.2, height: separator.size.height)
//            separator.alpha = 0
//            separator.colorBlendFactor = 0.5
//            addChild(separator)
//            highScoresUIContainer.append(separator)
//            
//            highScoresUIContainer.append(scoreFrame)
//            highScoresUIContainer.append(hsLabel)
//            highScoresUIContainer.append(hsNumberLabel)
//            highScoresUIContainer.append(separator)
//            counter += 1
//            counter2 += 1
//        }
//    }
//    
//    
//    func showHighScoresMenu() {
//        lastMenuOpened = "HighScores"
//        
//        closeButton.size = CGSize(width: 48, height: 48)
//        closeButton.alpha = 0
//        closeButton.position = CGPoint(x: frame.maxX * 0.9, y: frame.maxY * 0.95)
//        closeButton.zPosition = 80
//        closeButton.name = "Close Button"
//        highScoresUIContainer.append(closeButton)
//        
//        var timeIncrease: TimeInterval = 0.0
//        
//        let fadeOutMainUI = SKAction.run { [unowned self] in
//            for node in self.mainUIContainer { Animations.shared.fadeAlphaOut(node: node, duration: 0.25) }
//        }
//            
//        let wait = SKAction.wait(forDuration: 0.3)
//        
//        let fadeInScores = SKAction.run { [unowned self] in
//            Animations.shared.fadeAlphaIn(node: self.highScoresLabel, duration: 0.3, waitTime: 0)
//            for node in self.highScoresUIContainer {
//                Animations.shared.fadeAlphaIn(node: node, duration: 0.4, waitTime: 0.15 + timeIncrease); timeIncrease += 0.025
//            }
//        }
//        
//        let sequence = SKAction.sequence([fadeOutMainUI, wait, fadeInScores])
//        let dimBG = SKAction.colorize(with: .darkGray, colorBlendFactor: 0.75, duration: 0.6)
//        
//        run(sequence)
//        Animations.shared.colorize(node: background, color: .darkGray, colorBlendFactor: 0.75, duration: 0.6)
//        
//        addChild(closeButton)
//    }
//    
//    
//    
////    func highScoresMenu() {
////        lastMenuOpened = "HighScores"
////
////        closeButton.size = CGSize(width: 48, height: 48)
////        closeButton.alpha = 1
////        closeButton.position = CGPoint(x: -frame.midX, y: frame.maxY * 0.12)
////        closeButton.zPosition = 80
////        closeButton.name = "Close Button"
////
////        setCamera(xPosition: -frame.midX)
////
////        var timeIncrease: TimeInterval = 0.0
////
////        Animations.shared.fadeAlphaIn(node: highScoresLabel, duration: 0.35, waitTime: 0)
////        Animations.shared.fadeAlphaOut(node: logo, duration: 0.5)
////        for buttons in mainUIContainer { Animations.shared.fadeAlphaOut(node: buttons, duration: 0.5) }
////
////        for nodes in highScoresUIContainer {
////            Animations.shared.fadeAlphaIn(node: nodes, duration: 0.25, waitTime: 0.25 + timeIncrease); timeIncrease += 0.05
////        }
////
////        addChild(closeButton)
////    }
//    
//    func createOptions() {
//        
//        musicButton.size = CGSize(width: 64, height: 64)
//        musicButton.alpha = 0
//        musicButton.position = CGPoint(x: frame.midX / 3, y: frame.maxY * 0.75)
//        musicButton.zPosition = 55
//        musicButton.name = "Music Button"
//        addChild(musicButton)
//        optionsUIContainer.append(musicButton)
//        
//        let musicLabel = SKLabelNode(fontNamed: "Paper Plane Font")
//        musicLabel.text = "Music"
//        musicLabel.position = CGPoint(x: frame.midX, y: musicButton.position.y)
//        musicLabel.fontSize = 48
//        musicLabel.alpha = 0
//        addChild(musicLabel)
//        optionsUIContainer.append(musicLabel)
//        
//        if isMusicMuted == false {
//            musicButton.texture = SKTexture(imageNamed: "Music Button")
//        } else if isMusicMuted == true {
//            musicButton.texture = SKTexture(imageNamed: "Music Button Muted")
//        }
//    }
//    
//    
//    func showOptionsMenu() {
//        lastMenuOpened = "Options"
//        
//        closeButton.size = CGSize(width: 48, height: 48)
//        closeButton.alpha = 0
//        closeButton.position = CGPoint(x: frame.maxX * 0.90, y: frame.maxY * 0.95)
//        closeButton.zPosition = 80
//        closeButton.name = "Close Button"
//        addChild(closeButton)
//        optionsUIContainer.append(closeButton)
//        
//        let fadeOutMainUI = SKAction.run { [unowned self] in
//            for node in self.mainUIContainer { Animations.shared.fadeAlphaOut(node: node, duration: 0.25) }
//        }
//            
//        let wait = SKAction.wait(forDuration: 0.3)
//        
//        let fadeInOptions = SKAction.run { [unowned self] in
//            for node in self.optionsUIContainer {
//                Animations.shared.fadeAlphaIn(node: node, duration: 0.4, waitTime: 0)
//            }
//        }
//        
//        let sequence = SKAction.sequence([fadeOutMainUI, wait, fadeInOptions])
//        let dimBG = SKAction.colorize(with: .darkGray, colorBlendFactor: 0.75, duration: 0.6)
//        
//        run(sequence)
//        background.run(dimBG)
//    }
//    
//    
//    func closeMenu() {
//        
//        switch lastMenuOpened {
//        case "WorldSelect":
//            closeButton.removeFromParent()
//            background.removeFromParent()
//            childNode(withName: "blur")?.removeFromParent() // blurNode from addBlur() was never being removed, only its child node: background
//            addChild(background)
//            
//            Animations.shared.fadeAlphaIn(node: logo, duration: 0.6, waitTime: 0)
//            for buttons in mainUIContainer { Animations.shared.fadeAlphaIn(node: buttons, duration: 0.6, waitTime: 0) }
//            for wsButton in worldSelectContainer { Animations.shared.fadeAlphaOut(node: wsButton, duration: 0.5) }
//            
//            setCamera(xPosition: frame.midX)
//            
//        case "HighScores":
//            
//            closeButton.removeFromParent()
//            
//            let fadeOutScores = SKAction.run { [unowned self] in
//                Animations.shared.fadeAlphaOut(node: highScoresLabel, duration: 0.25)
//                for nodes in highScoresUIContainer { Animations.shared.fadeAlphaOut(node: nodes, duration: 0.25) }
//            }
//            let wait = SKAction.wait(forDuration: 0.4)
//            
//            let fadeInMainMenu = SKAction.run { [unowned self] in
//                for node in mainUIContainer { Animations.shared.fadeAlphaIn(node: node, duration: 0.35, waitTime: 0) }
//            }
//            
//            let sequence = SKAction.sequence([fadeOutScores, wait, fadeInMainMenu])
//            let undimBG = SKAction.colorize(with: .darkGray, colorBlendFactor: 0.0, duration: 0.6)
//            
//            run(sequence)
//            background.run(undimBG)
//            
//        case "Options":
//            
//            closeButton.removeFromParent()
//            
//            let fadeOutOptions = SKAction.run { [unowned self] in
//                for nodes in optionsUIContainer { Animations.shared.fadeAlphaOut(node: nodes, duration: 0.25) }
//            }
//            let wait = SKAction.wait(forDuration: 0.4)
//            
//            let fadeInMainMenu = SKAction.run { [unowned self] in
//                for node in mainUIContainer { Animations.shared.fadeAlphaIn(node: node, duration: 0.35, waitTime: 0) }
//            }
//            
//            let sequence = SKAction.sequence([fadeOutOptions, wait, fadeInMainMenu])
//            let undimBG = SKAction.colorize(with: .darkGray, colorBlendFactor: 0.0, duration: 0.6)
//            
//            run(sequence)
//            background.run(undimBG)
//            
//            Animations.shared.rotateCCW(node: optionsButton)
//        default:
//            break
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
////            for node in mainUIContainer {
////                if node.name == "Play" || node.name == "Options" {
////                    shrink(node: node)
////                }
////            }
//            
//            if touchedNode.name == "Play" {
//                Animations.shared.shrink(node: playButton)
//                isButtonTouched = "Play"
//            }
//            
//            if touchedNode.name == "World 1" {
//                Animations.shared.shrink(node: worldSelectButton1)
//                isButtonTouched = "World 1"
//            }
//            
//            if touchedNode.name == "World 2" {
//                Animations.shared.shrink(node: worldSelectButton2)
//                isButtonTouched = "World 2"
//            }
//            
//            if touchedNode.name == "World 3" {
//                Animations.shared.shrink(node: worldSelectButton3)
//                isButtonTouched = "World 3"
//            }
//            
//            if touchedNode.name == "High Scores" {
//                Animations.shared.shrink(node: highScoresButton)
//                isButtonTouched = "High Scores"
//            }
//            
//            if touchedNode.name == "Options" {
//                Animations.shared.rotateCW(node: optionsButton)
//                isButtonTouched = "Options"
//            }
//            
//            if touchedNode.name == "Music Button" {
//                Animations.shared.shrink(node: musicButton)
//                isButtonTouched = "Music Button"
//            }
//            
//            if touchedNode.name == "Close Button" {
//                Animations.shared.shrink(node: closeButton)
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
//                
//                let expand = SKAction.run { [unowned self] in
//                    Animations.shared.expand(node: playButton)
//                }
//                let wait = SKAction.wait(forDuration: 0.075)
//                let openWorldSelect = SKAction.run { [unowned self] in
//                    worldSelectMenu()
//                }
//                let sequence = SKAction.sequence([expand, wait, openWorldSelect])
//                
//                run(sequence)
//                
//                for node in mainUIContainer { node.isUserInteractionEnabled = true }
//                
//            } else if touchedNode.name != "Play" && isButtonTouched == "Play" {
//                Animations.shared.expand(node: playButton)
//            }
//            
//            
//            if touchedNode.name == "World 1" && isButtonTouched == "World 1" {
//                world = "classic"
//                theme = "castle"
//                
////                startGame()
//                Animations.shared.expand(node: worldSelectButton1)
//    
//            } else if touchedNode.name != "World 1" && isButtonTouched == "World 1" {
//                Animations.shared.expand(node: worldSelectButton1)
//            }
//            
//            
//            if touchedNode.name == "World 2" && isButtonTouched == "World 2" {
//                world = "classic"
//                theme = "cave"
//                
////                startGame()
//                Animations.shared.expand(node: worldSelectButton2)
//    
//            } else if touchedNode.name != "World 2" && isButtonTouched == "World 2" {
//                Animations.shared.expand(node: worldSelectButton2)
//            }
//            
//            
//            if touchedNode.name == "World 3" && isButtonTouched == "World 3" {
//                world = "classic"
//                theme = "silo"
//                
////                startGame()
//                Animations.shared.expand(node: worldSelectButton3)
//    
//            } else if touchedNode.name != "World 3" && isButtonTouched == "World 3" {
//                Animations.shared.expand(node: worldSelectButton3)
//            }
//            
//            
//            if touchedNode.name == "High Scores" && isButtonTouched == "High Scores" {
//                showHighScoresMenu()
//                Animations.shared.expand(node: highScoresButton)
//                for node in mainUIContainer { node.isUserInteractionEnabled = true }
//                
//            } else if touchedNode.name != "High Scores" && isButtonTouched == "High Scores" {
//                Animations.shared.expand(node: highScoresButton)
//            }
//            
//            
//            if touchedNode.name == "Options" && isButtonTouched == "Options" {
//                showOptionsMenu()
//                lastMenuOpened = "Options"
//                for node in mainUIContainer { node.isUserInteractionEnabled = true }
//                
//            } else if touchedNode.name != "Options" && isButtonTouched == "Options" {
//                Animations.shared.rotateCCW(node: optionsButton)
//            }
//            
//            
//            if touchedNode.name == "Music Button" && isButtonTouched == "Music Button" {
//                isMusicMuted.toggle()
//                Animations.shared.expand(node: musicButton)
//                
//                if isMusicMuted == false {
//                    musicButton.texture = SKTexture(imageNamed: "Music Button")
//                } else if isMusicMuted == true {
//                    musicButton.texture = SKTexture(imageNamed: "Music Button Muted")
//                }
//                
//            } else if touchedNode.name != "Music Button" && isButtonTouched == "Music Button" {
//                Animations.shared.expand(node: musicButton)
//            }
//            
//            
//            if touchedNode.name == "Close Button" && isButtonTouched == "Close Button" {
//                closeMenu()
//                Animations.shared.expand(node: closeButton)
//                
//                lastMenuOpened = ""
//                
//                for node in mainUIContainer { node.isUserInteractionEnabled = false }
//            } else if touchedNode.name != "Close Button" && isButtonTouched == "Close Button" {
//                Animations.shared.expand(node: closeButton)
//            }
//            
//            isButtonTouched = ""
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
//        sceneCamera.position = cameraFocusNode.position
////        print(buttonIsPressed)
////        print(optionsButton.isUserInteractionEnabled)
//    }
//    
//    
//    deinit {
//        print("All Good")
//    }
//}
//
