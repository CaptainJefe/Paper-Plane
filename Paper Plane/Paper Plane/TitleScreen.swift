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

var isFirstLaunch: Bool = true

class TitleScreen: SKScene {
    
    var howToPlay: SKSpriteNode!
    var gotIt: SKSpriteNode!
    
    var logo = SKSpriteNode(imageNamed: "Paper Plane Logo")
    var background: SKSpriteNode!
    
    var playButton = SKSpriteNode(imageNamed: "play_button_1")
    var optionsButton = SKSpriteNode(imageNamed: "options_button_1")
    var highScoresButton = SKSpriteNode(imageNamed: "high_scores_button_1")
    var menuSeparator: SKSpriteNode!
    
    var musicButton = SKSpriteNode(imageNamed: "")
    var soundButton = SKSpriteNode(imageNamed: "")
    var controlsButton = SKSpriteNode(imageNamed: "")
    var instructionsButton: SKSpriteNode!
    
    var closeButton = SKSpriteNode(imageNamed: "Close Button")
    
    var lastMenuOpened: String!
    
    var buttonIsPressed = false
    
    var bigButtonSize = CGSize(width: 256, height: 128)
    var smallButtonSize = CGSize(width: 160, height: 160)
    
    var isButtonTouched: String!

    var hasBeenOpened: Bool = false
    
    var highScoresLabel: SKSpriteNode!
    var scoreFrame: SKSpriteNode!
    var scoreFrameContainer = [SKSpriteNode]()
    var hsLabel: SKLabelNode!
    var hsNumberLabel: SKLabelNode!
    var separator: SKSpriteNode!
    
    var labelContainer = [SKLabelNode]()
    var mainUIContainer = [SKNode]()
    var highScoresUIContainer = [SKNode]()
    var optionsUIContainer = [SKNode]()
    
    var playButtonTexture1 = SKTexture(imageNamed: "play_button_1")
    var playButtonTexture2 = SKTexture(imageNamed: "play_button_2")
    var playButtonTexture3 = SKTexture(imageNamed: "play_button_3")
    var playButtonTexture4 = SKTexture(imageNamed: "play_button_4")
    var playButtonTexture5 = SKTexture(imageNamed: "play_button_5")
    
    var highScoresTexture1 = SKTexture(imageNamed: "high_scores_button_1")
    var highScoresTexture2 = SKTexture(imageNamed: "high_scores_button_2")
    var highScoresTexture3 = SKTexture(imageNamed: "high_scores_button_3")
    var highScoresTexture4 = SKTexture(imageNamed: "high_scores_button_4")
    var highScoresTexture5 = SKTexture(imageNamed: "high_scores_button_5")
    
    var optionsTexture1 = SKTexture(imageNamed: "options_button_1")
    var optionsTexture2 = SKTexture(imageNamed: "options_button_2")
    var optionsTexture3 = SKTexture(imageNamed: "options_button_3")
    var optionsTexture4 = SKTexture(imageNamed: "options_button_4")
    var optionsTexture5 = SKTexture(imageNamed: "options_button_5")
    
    var menuSeperatorTexture = SKTexture(imageNamed: "menu_separator")
    
    var appVersion: String!
    
    
    override func didMove(to view: SKView) {
        createMainMenu()
        createButtons()
//        createHighScores()
//        createOptions()
        startUp()
        
        _ = SKAction.playSoundFileNamed("Button Click.mp3", waitForCompletion: false) // preloads the sound file to prevent lag when the audio is called for the first time -- seems to work in GameViewController, might preload for all scene instances
        
        appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    
    func startUp() {
        
//        SavedSettings.shared.setTutorialData() // Resets saved tutorial setting so it shows tutorial again
        
        areControlsHidden = SavedSettings.shared.getControlsSettings()
        isMusicMuted = SavedSettings.shared.getMusicSettings() // retrieves and sets value that was last saved
        isSoundMuted = SavedSettings.shared.getSoundSettings() //
        gamesPlayed = SavedData.shared.getGamesPlayed()
        firstTimePlaying = SavedSettings.shared.getTutorialData()
        
        if isFirstLaunch == true {
            let scaleUp = SKAction.scale(to: CGSize(width: logo.size.width * 4, height: logo.size.height * 4), duration: 0)
            let wait = SKAction.wait(forDuration: 1)
            let scaleDown = SKAction.scale(to: CGSize(width: logo.size.width, height: logo.size.height), duration: 1)
            let fadeInLogo = SKAction.fadeIn(withDuration: 1)
            
            for node in mainUIContainer {
                if node.name == "logo" {
                    Animations.shared.fadeAlphaIn(node: self.logo, duration: 1.75, waitTime: 1)
                } else {
                    Animations.shared.fadeAlphaIn(node: node, duration: 0.5, waitTime: 3)
                }
            }
            
            let sequence = SKAction.sequence([scaleUp, wait, scaleDown, fadeInLogo])
            
            logo.run(sequence)
            isFirstLaunch = false
            
        } else {
            
            // Use this for a gentle fade in when coming back to the main menu
            for node in mainUIContainer {
                Animations.shared.fadeAlphaIn(node: node, duration: 0.35, waitTime: 0)

            }
            
            // Use this for UI elements to already exist when coming back to the main menu
//            for node in mainUIContainer {
//                node.alpha = 1
//            }
        }
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
    
    
    func createMainMenu() {
        background = SKSpriteNode(imageNamed: "Title Screen BG")
        background.size = CGSize(width: frame.size.width, height: frame.size.width * 2.5)
        background.position = CGPoint(x: view!.center.x, y: view!.frame.maxY - background.frame.maxY)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -10
        background.alpha = 1
        addChild(background)
        mainUIContainer.append(logo)
        
        logo.size = CGSize(width: logo.size.width * 0.8, height: logo.size.height * 0.8)
        logo.position = CGPoint(x: frame.midX, y: frame.maxY / 1.4)
        logo.alpha = 0
        addChild(logo)
        
        print("center \(view!.center.y)")
        print("view diff \(view!.frame.maxY - background.frame.maxY)") // values change if written above background.position
        print("background.frame.maxY\(background.frame.maxY)")
        print("view.frame.maxY \(view!.frame.maxY)")
    }
    
    
    func createButtons() {
        let UIButtonSize = CGSize(width: playButton.size.width * 1.5, height: playButton.size.height * 1.5)
        
        playButton.size = UIButtonSize // // non number size is CGSize(width: frame.size.width / 2, height: frame.size.width / 4)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY / 1)
        playButton.colorBlendFactor = 0
        playButton.zPosition = 10
        playButton.alpha = 0
        playButton.name = "Play"
        addChild(playButton)
        mainUIContainer.append(playButton)
        
        highScoresButton.size = UIButtonSize // non number size is CGSize(width: frame.size.width / 2, height: frame.size.width / 4)
        highScoresButton.position = CGPoint(x: playButton.position.x, y: playButton.position.y - 70) // playButton.position.y - 150 is was the original
        highScoresButton.colorBlendFactor = 0
        highScoresButton.zPosition = 10
        highScoresButton.alpha = 0
        highScoresButton.name = "High Scores"
        addChild(highScoresButton)
        mainUIContainer.append(highScoresButton)
        
//        optionsButton.size = CGSize(width: optionsButton.size.width, height: optionsButton.size.height)
//        optionsButton.position = CGPoint(x: frame.maxX * 0.9, y: frame.minY + (frame.size.height * 0.05))
        optionsButton.size = UIButtonSize
        optionsButton.position = CGPoint(x: playButton.position.x, y: highScoresButton.position.y - 70)
        optionsButton.colorBlendFactor = 0
        optionsButton.zPosition = 10
        optionsButton.alpha = 0
        optionsButton.name = "Options"
        addChild(optionsButton)
        mainUIContainer.append(optionsButton)
        
        var counter: [CGFloat] = [0,1]
        
        for x in 0...1 {
            menuSeparator = SKSpriteNode(imageNamed: "separator")
            menuSeparator.size = CGSize(width: playButton.size.width * 0.75, height: menuSeparator.size.height)
            menuSeparator.position = CGPoint(x: playButton.position.x, y: (playButton.position.y - 35) - (CGFloat(x) * (playButton.position.y - highScoresButton.position.y)))
            menuSeparator.colorBlendFactor = 0
            menuSeparator.zPosition = 10
            menuSeparator.alpha = 0
            menuSeparator.name = "menuSeparator"
            addChild(menuSeparator)
            mainUIContainer.append(menuSeparator)

        }
    }

    
    func worldSelectMenu() {
        if let skView = self.view {
            
            Assets.sharedInstance.preloadGameAssets()
            
            guard let scene = WorldSelect(fileNamed: "WorldSelect") else { return }
            scene.size = skView.frame.size
            
            let transition = SKTransition.fade(withDuration: 1.5)
            
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene, transition: transition)
        }
    }

    
    func createHighScores() {
        
        highScoresLabel = SKSpriteNode(imageNamed: "high_scores_label")
        highScoresLabel.position = CGPoint(x: frame.midX, y: frame.maxY * 0.88)
        highScoresLabel.size = CGSize(width: highScoresLabel.size.width * 1.2, height: highScoresLabel.size.height * 1.2)
        highScoresLabel.zPosition = 80
        highScoresLabel.alpha = 0
        addChild(highScoresLabel)
        
        let sortedScores = SavedData.shared.getScore()?.sorted(by: >)
        var scoresList = sortedScores ?? [Int](repeating: 0, count: 10)
        let scoresAsString = scoresList.map(String.init)
        
        print("Scores: \(scoresList)")
        
        let scoresArray = [Int](repeating: 0, count: 10) // preset array for testing
        
        
        print(scoresAsString)
        
        var counter: CGFloat = 0
        var counter2: Int = 0 // counter doesn't compile (takes too long) when set as an Int. This is a temp solution
        
        for highscore in scoresAsString.prefix(10) { // scoresAsString[0...4] is also a valid call
            
            hsLabel = SKLabelNode(fontNamed: "Paper Plane Font")
            hsLabel.text = highscore as String
            hsLabel.alpha = 0
            hsLabel.fontSize = 40
            hsLabel.fontColor = SKColor.white
            hsLabel.position = CGPoint(x: self.frame.maxX * 0.8, y: ((frame.maxY) + (counter * -75)) / 1.25)
            hsLabel.zPosition = 160
            hsLabel.name = "hsLabel"
            addChild(hsLabel)
            highScoresUIContainer.append(hsLabel)
            
            let colorArray: Array<UIColor> = [.yellow, .lightGray, .brown, .white, .white, .white, .white, .white, .white, .white,]
            
            hsNumberLabel = SKLabelNode(fontNamed: "Paper Plane Font")
            hsNumberLabel.text = "\(counter2 + 1)."
            hsNumberLabel.alpha = 0
            hsNumberLabel.fontSize = 40
            hsNumberLabel.fontColor = colorArray[counter2]
            hsNumberLabel.position = CGPoint(x: self.frame.maxX * 0.2, y: hsLabel.position.y)
            hsNumberLabel.zPosition = 160
            hsNumberLabel.name = "hsNumberLabel"
            addChild(hsNumberLabel)
            highScoresUIContainer.append(hsNumberLabel)
            
            separator = SKSpriteNode(imageNamed: "separator")
            separator.position = CGPoint(x: self.frame.midX, y: hsLabel.position.y - 40)
            separator.size = CGSize(width: frame.width / 1.2, height: separator.size.height)
            separator.alpha = 0
            separator.colorBlendFactor = 0.25
            addChild(separator)
            highScoresUIContainer.append(separator)
            
            counter += 1
            counter2 += 1
        }
        
        closeButton.size = CGSize(width: 48, height: 48)
        closeButton.alpha = 0
        closeButton.position = CGPoint(x: frame.maxX * 0.9, y: frame.maxY * 0.95)
        closeButton.zPosition = 80
        closeButton.name = "Close Button"
        addChild(closeButton)
        highScoresUIContainer.append(closeButton)
        
        showHighScoresMenu()
    }
    

    // The first time the high scores are spawned, they spawn and are timed fine, but each time after the first time, the labels and the seperators are staggered in timing from the top high scores label and increases time you call high scores menu back. It's like timeIncrease is not clearing and compounding on it's previous value.
    // It looks like the time increase was from an ever increasing in size of the array, which in turn likely was iterating over elements (that were no longer being used, but was at the first listing of the index), so each time the active elements needed be called, all of the old entries were before it. .removeAll() on the array has fixed the issue, however the close button is not timing like it used to.
    
    func showHighScoresMenu() {
        lastMenuOpened = "HighScores"
        
        var timeIncrease: TimeInterval = 0.0
        
        let fadeOutMainUI = SKAction.run { [unowned self] in
            for node in self.mainUIContainer { Animations.shared.fadeAlphaOut(node: node, duration: 0.25, waitTime: 0) }
        }
            
        let wait = SKAction.wait(forDuration: 0.3)
        
        let fadeInScores = SKAction.run { [unowned self] in
            Animations.shared.fadeAlphaIn(node: self.highScoresLabel, duration: 0.3, waitTime: 0)
            for node in self.highScoresUIContainer {
                Animations.shared.fadeAlphaIn(node: node, duration: 0.4, waitTime: 0.15 + timeIncrease)
                timeIncrease += 0.025
            }
        }
        
        let sequence = SKAction.sequence([fadeOutMainUI, wait, fadeInScores])
        
        run(sequence)
        Animations.shared.colorize(node: background, color: .darkGray, colorBlendFactor: 0.75, duration: 0.6)
    }
    
    
    func createOptions() {
        
        if UserDefaults.standard.bool(forKey: "isMusicMuted") == false {
            musicButton.texture = SKTexture(imageNamed: "music_button")
        } else {
            musicButton.texture = SKTexture(imageNamed: "music_button_muted")
        }
        
        if UserDefaults.standard.bool(forKey: "isSoundMuted") == false {
            soundButton.texture = SKTexture(imageNamed: "sound_button")
        } else {
            soundButton.texture = SKTexture(imageNamed: "sound_button_muted")
        }
        
        if UserDefaults.standard.bool(forKey: "areControlsHidden") == false {
            controlsButton.texture = SKTexture(imageNamed: "controls_button")
        } else {
            controlsButton.texture = SKTexture(imageNamed: "controls_button_hidden")
        }
        
        musicButton.size = CGSize(width: 64, height: 64)
        musicButton.alpha = 0
        musicButton.position = CGPoint(x: frame.midX / 3, y: frame.maxY * 0.75)
        musicButton.zPosition = 55
        musicButton.name = "Music Button"
        addChild(musicButton)
        optionsUIContainer.append(musicButton)
        
        let musicLabel = SKLabelNode(fontNamed: "Paper Plane Font")
        musicLabel.text = "Music"
        musicLabel.position = CGPoint(x: frame.midX, y: musicButton.position.y + (musicButton.size.height / 6))
        musicLabel.fontSize = 48
        musicLabel.alpha = 0
        addChild(musicLabel)
        optionsUIContainer.append(musicLabel)
        
        soundButton.size = CGSize(width: 64, height: 64)
        soundButton.alpha = 0
        soundButton.position = CGPoint(x: frame.midX / 3, y: musicButton.position.y - 120)
        soundButton.zPosition = 55
        soundButton.name = "Sound Button"
        addChild(soundButton)
        optionsUIContainer.append(soundButton)
        
        print("music1 \(musicButton.position.y - 120)")
        print("music2 \(musicButton.position.y + (musicButton.size.height / 6))")
        
        let soundLabel = SKLabelNode(fontNamed: "Paper Plane Font")
        soundLabel.text = "Sound"
        soundLabel.position = CGPoint(x: frame.midX, y: soundButton.position.y + (soundButton.size.height / 6))
        soundLabel.fontSize = 48
        soundLabel.alpha = 0
        addChild(soundLabel)
        optionsUIContainer.append(soundLabel)
        
        controlsButton.size = CGSize(width: 64, height: 64)
        controlsButton.alpha = 0
        controlsButton.position = CGPoint(x: frame.midX / 3, y: soundButton.position.y - 120)
        controlsButton.zPosition = 55
        controlsButton.name = "Controls Button"
        addChild(controlsButton)
        optionsUIContainer.append(controlsButton)
        
        let controlsLabel = SKLabelNode(fontNamed: "Paper Plane Font")
        controlsLabel.text = "Controls"
        controlsLabel.position = CGPoint(x: frame.midX, y: controlsButton.position.y + (controlsButton.size.height / 6))
        controlsLabel.fontSize = 48
        controlsLabel.alpha = 0
        addChild(controlsLabel)
        optionsUIContainer.append(controlsLabel)
        
        instructionsButton = SKSpriteNode(imageNamed: "instructions_button")
        instructionsButton.size = CGSize(width: 64, height: 64)
        instructionsButton.alpha = 0
        instructionsButton.position = CGPoint(x: frame.midX, y: controlsButton.position.y - 200)
        instructionsButton.zPosition = 55
        instructionsButton.name = "Instructions Button"
        addChild(instructionsButton)
        optionsUIContainer.append(instructionsButton)
        
        for i in 0...2 {
            
            separator = SKSpriteNode(imageNamed: "separator")
            separator.position = CGPoint(x: self.frame.midX, y: (musicButton.position.y - 60) - CGFloat((i * 120)))
            separator.size = CGSize(width: frame.width / 1.2, height: separator.size.height)
            separator.alpha = 0
            separator.colorBlendFactor = 0.5
            addChild(separator)
            optionsUIContainer.append(separator)
        }
        
        let versionInfo = SKLabelNode(fontNamed: "Paper Plane Font")
        versionInfo.text = "Version \(appVersion!)"
        versionInfo.position = CGPoint(x: frame.midX
                                       , y: frame.maxY * 0.05)
        versionInfo.fontSize = 14
        versionInfo.alpha = 0
        addChild(versionInfo)
        optionsUIContainer.append(versionInfo)
        
        
        showOptionsMenu()
    }
    
    
    func showOptionsMenu() {
        lastMenuOpened = "Options"
        
        closeButton.size = CGSize(width: 48, height: 48)
        closeButton.alpha = 0
        closeButton.position = CGPoint(x: frame.maxX * 0.90, y: frame.maxY * 0.95)
        closeButton.zPosition = 80
        closeButton.name = "Close Button"
        addChild(closeButton)
        optionsUIContainer.append(closeButton)
        
        let fadeOutMainUI = SKAction.run { [unowned self] in
            for node in self.mainUIContainer { Animations.shared.fadeAlphaOut(node: node, duration: 0.25, waitTime: 0) }
        }
            
        let wait = SKAction.wait(forDuration: 0.3)
        
        let fadeInOptions = SKAction.run { [unowned self] in
            for node in self.optionsUIContainer {
                Animations.shared.fadeAlphaIn(node: node, duration: 0.4, waitTime: 0)
            }
        }
        
        let sequence = SKAction.sequence([fadeOutMainUI, wait, fadeInOptions])
        let dimBG = SKAction.colorize(with: .darkGray, colorBlendFactor: 0.75, duration: 0.6)
        
        run(sequence)
        background.run(dimBG)
    }
    
    func instructionsMenu() {
        
        howToPlay = SKSpriteNode(imageNamed: "how_to0")
        howToPlay.size = CGSize(width: howToPlay.size.width * 0.65, height: howToPlay.size.height * 0.65)
        howToPlay.position = CGPoint(x: frame.midX, y: frame.midY)
        howToPlay.alpha = 0
        howToPlay.zPosition = 800
        howToPlay.name = "howToPlay"
        addChild(howToPlay)
        
        gotIt = SKSpriteNode(imageNamed: "got_it")
        gotIt.size = CGSize(width: gotIt.size.width, height: gotIt.size.height)
        gotIt.position = CGPoint(x: howToPlay.frame.midX, y: frame.maxY * 0.33)
        gotIt.alpha = 0
        gotIt.zPosition = 810
        gotIt.name = "gotIt"
        addChild(gotIt)
        
        
        
        let fadeOutOptions = SKAction.run { [unowned self] in
            for node in optionsUIContainer {
                Animations.shared.fadeAlphaOut(node: node, duration: 0.25, waitTime: 0)
            }
        }
        
        let wait = SKAction.wait(forDuration: 0.3)
        
        let fadeInIntructions = SKAction.run { [unowned self] in
            Animations.shared.fadeAlphaIn(node: self.howToPlay, duration: 0.4, waitTime: 0)
            Animations.shared.fadeAlphaIn(node: self.gotIt, duration: 0.4, waitTime: 0)
            Animations.shared.animateIntructions(node: self.howToPlay)
        }
        
        let sequence = SKAction.sequence([fadeOutOptions, wait, fadeInIntructions])
        
        run(sequence)
        
        
    }
    
    
    func closeMenu() {
        
        switch lastMenuOpened {
        case "HighScores":
            
            
            
            let fadeOutScores = SKAction.run { [unowned self] in
                Animations.shared.fadeAlphaOut(node: highScoresLabel, duration: 0.25, waitTime: 0)
                for nodes in highScoresUIContainer { Animations.shared.fadeAlphaOut(node: nodes, duration: 0.25, waitTime: 0) }
            }
            let wait = SKAction.wait(forDuration: 0.4)
            
            let fadeInMainMenu = SKAction.run { [unowned self] in
                for node in mainUIContainer { Animations.shared.fadeAlphaIn(node: node, duration: 0.35, waitTime: 0) }
            }
            let remove = SKAction.run { [unowned self] in
                for node in self.highScoresUIContainer {
                    node.removeFromParent()
                }
                highScoresUIContainer.removeAll()
            }
            
            let sequence = SKAction.sequence([fadeOutScores, wait, fadeInMainMenu, remove])
            let undimBG = SKAction.colorize(with: .darkGray, colorBlendFactor: 0.0, duration: 0.6)
            
            run(sequence)
            background.run(undimBG)
            
            highScoresLabel.removeFromParent()
            
        case "Options":
            
            closeButton.removeFromParent()
            
            let fadeOutOptions = SKAction.run { [unowned self] in
                for nodes in optionsUIContainer { Animations.shared.fadeAlphaOut(node: nodes, duration: 0.25, waitTime: 0) }
            }
            let wait = SKAction.wait(forDuration: 0.4)
            
            let fadeInMainMenu = SKAction.run { [unowned self] in
                for node in mainUIContainer { Animations.shared.fadeAlphaIn(node: node, duration: 0.35, waitTime: 0) }
            }
            let remove = SKAction.run { [unowned self] in
                for node in self.optionsUIContainer {
                    node.removeFromParent()
                }
            }
            
            let sequence = SKAction.sequence([fadeOutOptions, wait, fadeInMainMenu, remove])
            let undimBG = SKAction.colorize(with: .darkGray, colorBlendFactor: 0.0, duration: 0.6)
            
            run(sequence)
            background.run(undimBG)
            
//            Animations.shared.rotateCCW(node: optionsButton)
        default:
            break
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
//            guard isButtonTouched == false else { return }
            
//            for node in mainUIContainer {
//                if node.name == "Play" || node.name == "Options" {
//                    shrink(node: node)
//                }
//            }
            
            if touchedNode.name == "Play" {
                Audio.shared.soundPlayer(node: touchedNode)
                Animations.shared.shrink(node: playButton)
//                Animations.shared.animateTexture(node: playButton, texture: [playButtonTexture2, playButtonTexture3])
                isButtonTouched = "Play"
            }
            
            if touchedNode.name == "High Scores" {
                Audio.shared.soundPlayer(node: touchedNode)
                Animations.shared.shrink(node: highScoresButton)
//                Animations.shared.animateTexture(node: highScoresButton, texture: [highScoresTexture2, highScoresTexture3])
                isButtonTouched = "High Scores"
            }
            
            if touchedNode.name == "Options" {
                Audio.shared.soundPlayer(node: touchedNode)
                Animations.shared.shrink(node: optionsButton)
//                Animations.shared.animateTexture(node: optionsButton, texture: [optionsTexture2, optionsTexture3])
                isButtonTouched = "Options"
            }
            
            if touchedNode.name == "Music Button" {
                Audio.shared.soundPlayer(node: touchedNode)
                Animations.shared.shrink(node: musicButton)
                isButtonTouched = "Music Button"
            }
            
            if touchedNode.name == "Sound Button" {
                Audio.shared.soundPlayer(node: touchedNode)
                Animations.shared.shrink(node: soundButton)
                isButtonTouched = "Sound Button"
            }
            
            if touchedNode.name == "Controls Button" {
                Audio.shared.soundPlayer(node: touchedNode)
                Animations.shared.shrink(node: controlsButton)
                isButtonTouched = "Controls Button"
            }
            
            if touchedNode.name == "Instructions Button" {
                Audio.shared.soundPlayer(node: touchedNode)
                Animations.shared.shrink(node: instructionsButton)
                isButtonTouched = "Instructions Button"
            }
            
            if touchedNode.name == "gotIt" {
                Audio.shared.soundPlayer(node: touchedNode)
                Animations.shared.shrink(node: gotIt)
                isButtonTouched = "gotIt"
            }
            
            if touchedNode.name == "Close Button" {
                Audio.shared.soundPlayer(node: touchedNode)
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
                
//                let expand = SKAction.run { [unowned self] in
//                    Animations.shared.animateTexture(node: playButton, texture: [playButtonTexture2, playButtonTexture1])
//                }
//                let wait = SKAction.wait(forDuration: 0.175)
//                let openWorldSelect = SKAction.run { [unowned self] in
//                    worldSelectMenu()
//                }
//                let sequence = SKAction.sequence([expand, wait, openWorldSelect])
//                
//                run(sequence)
                
                let expand = SKAction.run { [unowned self] in
                    Animations.shared.expand(node: playButton)
                }
                let wait = SKAction.wait(forDuration: 0.175)
                let sequence = SKAction.sequence([expand, wait])
                
                run(sequence, completion: { self.worldSelectMenu() } )
                
                for node in mainUIContainer { node.isUserInteractionEnabled = true }
                
            } else if touchedNode.name != "Play" && isButtonTouched == "Play" {
//                Animations.shared.animateTexture(node: playButton, texture: [playButtonTexture2, playButtonTexture1])
                Animations.shared.expand(node: playButton)
            }
            
            
            if touchedNode.name == "High Scores" && isButtonTouched == "High Scores" {
                
//                Animations.shared.animateTexture(node: highScoresButton, texture: [highScoresTexture2, highScoresTexture1])
                Animations.shared.expand(node: highScoresButton)
                createHighScores()
                
                for node in mainUIContainer { node.isUserInteractionEnabled = true }
                
            } else if touchedNode.name != "High Scores" && isButtonTouched == "High Scores" {
//                Animations.shared.animateTexture(node: highScoresButton, texture: [highScoresTexture2, highScoresTexture1])
                Animations.shared.expand(node: highScoresButton)
            }
            
            
            if touchedNode.name == "Options" && isButtonTouched == "Options" {
                
                Animations.shared.expand(node: optionsButton)
                createOptions()
//                Animations.shared.animateTexture(node: optionsButton, texture: [optionsTexture2, optionsTexture1])
                
                lastMenuOpened = "Options"
                for node in mainUIContainer { node.isUserInteractionEnabled = true }
                
            } else if touchedNode.name != "Options" && isButtonTouched == "Options" {
//                Animations.shared.animateTexture(node: optionsButton, texture: [optionsTexture2, optionsTexture1])
                Animations.shared.expand(node: optionsButton)
            }
            
            
            if touchedNode.name == "Music Button" && isButtonTouched == "Music Button" {
                print("isMM \(isMusicMuted)")
                isMusicMuted.toggle() // default launch is set to false. Make sure the values are not interferring with what the proper values of setMusicSettings needs to be set to. Like if SavedSettings is set to true and when you toggle after a new launch, will it be set to true again when is needs to be set to false? --- It looks like that's not the case and is working as intended, double check though
                print("isMM again \(isMusicMuted)")
                SavedSettings.shared.setMusicSettings()
                Animations.shared.expand(node: musicButton)
                
                if UserDefaults.standard.bool(forKey: "isMusicMuted") == false {
                    musicButton.texture = SKTexture(imageNamed: "music_button")
                } else if UserDefaults.standard.bool(forKey: "isMusicMuted") {
                    musicButton.texture = SKTexture(imageNamed: "music_button_muted")
                }
                
            } else if touchedNode.name != "Music Button" && isButtonTouched == "Music Button" {
                Animations.shared.expand(node: musicButton)
            }
            
            
            if touchedNode.name == "Sound Button" && isButtonTouched == "Sound Button" {
                isSoundMuted.toggle() // toggles bool for sounds
                SavedSettings.shared.setSoundSettings() // saves isSoundMuted boolean in UserDefaults
                Animations.shared.expand(node: soundButton)
                
                if UserDefaults.standard.bool(forKey: "isSoundMuted") == false {
                    soundButton.texture = SKTexture(imageNamed: "sound_button")
                } else if UserDefaults.standard.bool(forKey: "isSoundMuted") {
                    soundButton.texture = SKTexture(imageNamed: "sound_button_muted")
                }
                
            } else if touchedNode.name != "Sound Button" && isButtonTouched == "Sound Button" {
                Animations.shared.expand(node: soundButton)
            }
            
            
            if touchedNode.name == "Controls Button" && isButtonTouched == "Controls Button" {
                areControlsHidden.toggle()
                SavedSettings.shared.setControlsSettings()
                Animations.shared.expand(node: controlsButton)
                
                if UserDefaults.standard.bool(forKey: "areControlsHidden") == false {
                    controlsButton.texture = SKTexture(imageNamed: "controls_button")
                } else if UserDefaults.standard.bool(forKey: "areControlsHidden") == true {
                    controlsButton.texture = SKTexture(imageNamed: "controls_button_hidden")
                }
                
            } else if touchedNode.name != "Controls Button" && isButtonTouched == "Controls Button" {
                Animations.shared.expand(node: controlsButton)
            }
            
            
            if touchedNode.name == "Instructions Button" && isButtonTouched == "Instructions Button" {
                Animations.shared.expand(node: instructionsButton)
                instructionsMenu()
                
            } else if touchedNode.name != "Instructions Button" && isButtonTouched == "Instructions Button" {
                Animations.shared.expand(node: instructionsButton)
            }
            
            
            if touchedNode.name == "gotIt" && isButtonTouched == "gotIt" {
                
                Animations.shared.expand(node: gotIt)
                
                let fadeOut = SKAction.run {
                    Animations.shared.fadeAlphaOut(node: self.howToPlay, duration: 0.25, waitTime: 0)
                    Animations.shared.fadeAlphaOut(node: self.gotIt, duration: 0.25, waitTime: 0)
                }
                
                let wait = SKAction.wait(forDuration: 0.3)
                
                let fadeOptionsIn = SKAction.run {
                    for node in self.optionsUIContainer {
                        Animations.shared.fadeAlphaIn(node: node, duration: 0.4, waitTime: 0)
                    }
                }
                
                
                let remove = SKAction.run {
                    self.gotIt.removeFromParent()
                    self.howToPlay.removeFromParent()
                }
                
                let seq = SKAction.sequence([fadeOut, wait, fadeOptionsIn, remove])
                
                run(seq)
                
            } else if touchedNode.name != "gotIt" && isButtonTouched == "gotIt" {
                Animations.shared.expand(node: gotIt)
            }
            
            
            if touchedNode.name == "Close Button" && isButtonTouched == "Close Button" {
                closeMenu()
                Animations.shared.expand(node: closeButton)
                
                lastMenuOpened = ""
                
                for node in mainUIContainer { node.isUserInteractionEnabled = false }
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
}
