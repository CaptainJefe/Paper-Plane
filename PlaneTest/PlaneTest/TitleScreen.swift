//
//  TitleScreen.swift
//  PlaneTest
//
//  Created by Cade Williams on 10/14/20.
//  Copyright © 2020 Cade Williams. All rights reserved.
//

import SpriteKit
import UIKit
import SceneKit

var isMusicMuted = true

class TitleScreen: SKScene {
    var logo = SKSpriteNode(imageNamed: "Paper Plane Logo")
    var background: SKSpriteNode!
    
    var playButton = SKSpriteNode(imageNamed: "Play Button")
    var optionsButton = SKSpriteNode(imageNamed: "Options Button")
    var highScoresButton = SKSpriteNode(imageNamed: "High Scores Button")
    
    var worldSelectContainer = [SKSpriteNode]()
    var worldSelectButton1 = SKSpriteNode(imageNamed: "Castle Icon")
    var worldSelectButton2 = SKSpriteNode(imageNamed: "Cave Icon")
    var worldSelectButton3 = SKSpriteNode(imageNamed: "silo_icon")
    
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
    
    var highScoresLogo: SKSpriteNode!
    var scoreFrame: SKSpriteNode!
    var scoreFrameContainer = [SKSpriteNode]()
    var hsLabel: SKLabelNode!
    var labelContainer = [SKLabelNode]()
    var highScoresUIContainer = [SKNode]()
    
    var sceneCamera = SKCameraNode()
    var cameraFocusNode: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        
        cameraFocusNode = SKSpriteNode()
        cameraFocusNode.position = CGPoint(x: frame.midX, y: frame.midY)
        cameraFocusNode.size = CGSize(width: 1, height: 1)
        cameraFocusNode.alpha = 0
        addChild(cameraFocusNode)
        
        self.camera = sceneCamera
        
        createButtons()
        scoreList()
        
        background = SKSpriteNode(imageNamed: "Title Screen BG")
        background.size = CGSize(width: frame.size.height * 1.5, height: frame.size.height)
        background.position = CGPoint(x: view.center.x, y: view.center.y)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -10
        addChild(background)
        
        logo.size = CGSize(width: logo.size.width * 2.5, height: logo.size.height * 2.5)
        logo.position = CGPoint(x: frame.midX, y: frame.maxY / 1.4)
        addChild(logo)
    }
    
    func setCamera(xPosition: CGFloat) {
        let moveTo = SKAction.move(to: CGPoint(x: xPosition, y: frame.midY), duration: 0.40)
        cameraFocusNode.run(moveTo)
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
        playButton.size = CGSize(width: 192, height: 84) // // non number size is CGSize(width: frame.size.width / 2, height: frame.size.width / 4)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY / 1.1)
        playButton.colorBlendFactor = 0
        playButton.zPosition = 10
        playButton.name = "Play"
        addChild(playButton)
        buttonContainer.append(playButton)
        
        highScoresButton.size = CGSize(width: 192, height: 84) // non number size is CGSize(width: frame.size.width / 2, height: frame.size.width / 4)
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
        
        worldSelectButton1.size = CGSize(width: worldSelectButton1.texture!.size().width * 2, height: worldSelectButton1.texture!.size().height * 2)
        worldSelectButton1.alpha = 0
        worldSelectButton1.position = CGPoint(x: frame.midX * 3, y: frame.maxY * 0.75)
        worldSelectButton1.zPosition = 55
        worldSelectButton1.name = "World 1"
        addChild(worldSelectButton1)
        worldSelectContainer.append(worldSelectButton1)
        
        worldSelectButton2.size = CGSize(width: worldSelectButton2.texture!.size().width * 2, height: worldSelectButton2.texture!.size().height * 2)
        worldSelectButton2.alpha = 0
        worldSelectButton2.position = CGPoint(x: worldSelectButton1.position.x, y: worldSelectButton1.position.y - worldSelectButton1.size.height * 1.2)
        worldSelectButton2.zPosition = 55
        worldSelectButton2.name = "World 2"
        addChild(worldSelectButton2)
        worldSelectContainer.append(worldSelectButton2)
        
        worldSelectButton3.size = CGSize(width: worldSelectButton3.texture!.size().width * 2, height: worldSelectButton3.texture!.size().height * 2)
        worldSelectButton3.alpha = 0
        worldSelectButton3.position = CGPoint(x: worldSelectButton1.position.x, y: worldSelectButton2.position.y - worldSelectButton1.size.height * 1.2)
        worldSelectButton3.zPosition = 55
        worldSelectButton3.name = "World 3"
        addChild(worldSelectButton3)
        worldSelectContainer.append(worldSelectButton3)
    }
    
    
    func startGame() {
        if let skView = self.view {
            
            Assets.sharedInstance.preloadGameAssets()
            
            guard let scene = GameSceneNewNew(fileNamed: "GameSceneNewNew") else { return }
            scene.size = skView.frame.size
            
            let transition = SKTransition.fade(withDuration: 1.5)
            
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene, transition: transition)
        }
    }

    
    func worldSelect() {
        // worldSelectButton 2 original position: CGPoint(x: frame.midX, y: worldSelectButton1.position.y - worldSelectButton1.position.y / 2)
        
        closeButton.size = CGSize(width: 48, height: 48)
        closeButton.alpha = 1
        closeButton.position = CGPoint(x: frame.maxX * 1.88, y: frame.maxY * 0.95)
        closeButton.zPosition = 80
        closeButton.name = "Close Button"
        addChild(closeButton)
        
        setCamera(xPosition: frame.midX * 3)
        
        var timeIncrease: TimeInterval = 0.0
        
        Animations.shared.fadeAlphaOut(node: logo, duration: 0.5)
        for buttons in buttonContainer { Animations.shared.fadeAlphaOut(node: buttons, duration: 0.5) }
        for wsButton in worldSelectContainer { Animations.shared.fadeAlphaIn(node: wsButton, duration: 0.4, waitTime: 0.2 + timeIncrease); timeIncrease += 0.15 }
        
//        Animations.shared.moveUIX(node: worldSelectButton1, duration: 0.25)
//        Animations.shared.moveUIX(node: worldSelectButton2, duration: 0.25)
//
//        Animations.shared.moveUIX(node: logo, duration: 0.25)
//        Animations.shared.moveUIX(node: playButton, duration: 0.25)
//        Animations.shared.moveUIX(node: highScoresButton, duration: 0.25)
//        Animations.shared.moveUIX(node: optionsButton, duration: 0.25)
        
//        addBlur(node: background)
        
        lastMenuOpened = "WorldSelect"
    }
    
    
    func highScoresMenu() {
        lastMenuOpened = "HighScores"
        
        highScoresWindow.size = CGSize(width: highScoresWindow.size.width, height: highScoresWindow.size.height)
        highScoresWindow.setScale(1.7)
        highScoresWindow.alpha = 1
        highScoresWindow.color = .green
        highScoresWindow.position = CGPoint(x: frame.midX, y: frame.midY)
        highScoresWindow.zPosition = 50
        
        closeButton.size = CGSize(width: 48, height: 48)
        closeButton.alpha = 1
        closeButton.position = CGPoint(x: -frame.midX, y: frame.maxY * 0.12)
        closeButton.zPosition = 80
        closeButton.name = "Close Button"
        
//        Animations.shared.scaleUp(node: highScoresWindow)
        
        setCamera(xPosition: -frame.midX)
        
        var timeIncrease: TimeInterval = 0.0
        
        Animations.shared.fadeAlphaIn(node: highScoresLogo, duration: 0.35, waitTime: 0)
        Animations.shared.fadeAlphaOut(node: logo, duration: 0.5)
        for buttons in buttonContainer { Animations.shared.fadeAlphaOut(node: buttons, duration: 0.5) }
        
        for nodes in highScoresUIContainer {
            Animations.shared.fadeAlphaIn(node: nodes, duration: 0.25, waitTime: 0.25 + timeIncrease); timeIncrease += 0.05
        }
        
        addChild(closeButton)
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
        closeButton.zPosition = 80
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
            closeButton.removeFromParent()
            background.removeFromParent()
            childNode(withName: "blur")?.removeFromParent() // blurNode from addBlur() was never being removed, only its child node: background
            addChild(background)
            
            Animations.shared.fadeAlphaIn(node: logo, duration: 0.6, waitTime: 0)
            for buttons in buttonContainer { Animations.shared.fadeAlphaIn(node: buttons, duration: 0.6, waitTime: 0) }
            for wsButton in worldSelectContainer { Animations.shared.fadeAlphaOut(node: wsButton, duration: 0.5) }
            
            setCamera(xPosition: frame.midX)

            
//            Animations.shared.moveUIX(node: worldSelectButton1, duration: 0.25)
//            Animations.shared.moveUIX(node: worldSelectButton2, duration: 0.25)
//
//            Animations.shared.moveUIX(node: logo, duration: 0.25)
//            Animations.shared.moveUIX(node: playButton, duration: 0.25)
//            Animations.shared.moveUIX(node: highScoresButton, duration: 0.25)
//            Animations.shared.moveUIX(node: optionsButton, duration: 0.25)
            
        case "HighScores":
//            highScoresWindow.removeFromParent()
            closeButton.removeFromParent()
            
            logo.isHidden = false
            playButton.isHidden = false
            highScoresButton.isHidden = false
            optionsButton.isHidden = false
            
            Animations.shared.fadeAlphaIn(node: logo, duration: 0.6, waitTime: 0)
            for buttons in buttonContainer { Animations.shared.fadeAlphaIn(node: buttons, duration: 0.6, waitTime: 0) }
            Animations.shared.fadeAlphaOut(node: highScoresLogo, duration: 0.5)
            for nodes in highScoresUIContainer { Animations.shared.fadeAlphaOut(node: nodes, duration: 0.5) }
            
            setCamera(xPosition: frame.midX)
            
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
            
            if touchedNode.name == "World 3" {
                Animations.shared.shrink(node: worldSelectButton3)
                isButtonTouched = "World 3"
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
                for node in buttonContainer { node.isUserInteractionEnabled = true }
                
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
            
            
            if touchedNode.name == "World 3" && isButtonTouched == "World 3" {
                world = "classic"
                theme = "silo"
                
                startGame()
                Animations.shared.expand(node: worldSelectButton3)
    
            } else if touchedNode.name != "World 3" && isButtonTouched == "World 3" {
                Animations.shared.expand(node: worldSelectButton3)
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
        sceneCamera.position = cameraFocusNode.position
//        print(buttonIsPressed)
//        print(optionsButton.isUserInteractionEnabled)
    }
    
    
    deinit {
        print("All Good")
    }
    
    func scoreList() {
        
        highScoresLogo = SKSpriteNode(imageNamed: "highscores_logo")
        highScoresLogo.position = CGPoint(x: -frame.midX, y: frame.maxY * 0.88)
        highScoresLogo.size = CGSize(width: highScoresLogo.size.width * 1.5, height: highScoresLogo.size.height * 1.5)
        highScoresLogo.zPosition = 80
        highScoresLogo.alpha = 0
        addChild(highScoresLogo)
        
        let sortedScores = GameplayStats.shared.getScore()?.sorted(by: >)
        var scoresList = sortedScores ?? [0]
        
        print("Scores: \(scoresList)")
//        var pos = 0
        
        let scoresArray = [1, 2, 3, 4, 5] // preset array for testing
        let scoresAsString = scoresList.map(String.init)

        // This works, but it doesn't space out the strings in an added position yet
        
        var counter: CGFloat = 0
        
        for highscore in scoresAsString.prefix(5) { // scoresAsString[0...4] is also a valid call
            scoreFrame = SKSpriteNode(imageNamed: "high_scores_frame")
            scoreFrame.position = CGPoint(x: -self.frame.midX, y: ((frame.maxY - 100) + (counter * -120)) / 1.2)
            scoreFrame.size = CGSize(width: scoreFrame.texture!.size().width * 2.5, height: scoreFrame.texture!.size().height * 2.5)
            scoreFrame.alpha = 0
            scoreFrame.zPosition = 150
            scoreFrame.name = "scoreFrame"
            addChild(scoreFrame)
            scoreFrameContainer.append(scoreFrame)
            
            hsLabel = SKLabelNode(fontNamed: "Asai-Analogue")
            hsLabel.text = highscore as String
            hsLabel.alpha = 0
            hsLabel.fontSize = 65
            hsLabel.fontColor = SKColor.white
            hsLabel.position = CGPoint(x: -self.frame.maxX / 1.25, y: ((frame.maxY - 120) + (counter * -120)) / 1.2)
            hsLabel.zPosition = 160
            hsLabel.name = "hsLabel"
            addChild(hsLabel)
            labelContainer.append(hsLabel)
            
            highScoresUIContainer.append(scoreFrame)
            highScoresUIContainer.append(hsLabel)
            counter += 1
        }
    }
}
