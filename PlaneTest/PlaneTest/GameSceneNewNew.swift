//
//  GameScene.swift
//  PlaneTest
//
//  Created by Cade Williams on 8/21/20.
//  Copyright © 2020 Cade Williams. All rights reserved.
//

//struct Collisions {
//    static let spawn: UInt32 = 0x1 << 1
//    static let detect: UInt32 = 0x1 << 2
//}

var stage = 1
var world: String!
var theme: String!

import AVFoundation
import SpriteKit

class GameSceneNewNew: SKScene, SKPhysicsContactDelegate {

    var buttonRight: SKSpriteNode!
    var buttonLeft: SKSpriteNode!
    var pauseButton: SKSpriteNode!

    var pauseMenu = SKSpriteNode(imageNamed: "Pause Window")
    var gameOverWindow = SKSpriteNode(imageNamed: "Game Over Window")
    var homeButton = SKSpriteNode(imageNamed: "Home Button")
    var restartButton = SKSpriteNode(imageNamed: "Restart Button")

    var backgroundPieces: [SKSpriteNode] = [SKSpriteNode(), SKSpriteNode()]
    var backgroundSpeed: CGFloat = 1.0 { didSet { for background in backgroundPieces { background.speed = backgroundSpeed } } }
    var backgroundTexture: SKTexture! { didSet { for background in backgroundPieces { background.texture = backgroundTexture } } }

    var cloudPieces: [SKSpriteNode] = [SKSpriteNode(), SKSpriteNode()]
    var skyTexture: SKTexture!
    var cloudsTexture: SKTexture! { didSet { for clouds in cloudPieces { clouds.texture = cloudsTexture } } }

    var wallPieces: [SKSpriteNode] = [SKSpriteNode(imageNamed: "Wall"), SKSpriteNode(imageNamed: "Wall")]
    var wallPieces2: [SKSpriteNode] = [SKSpriteNode(imageNamed: "Wall"), SKSpriteNode(imageNamed: "Wall")]
    var wallSpeed: CGFloat = 1.0 { didSet { for walls in wallPieces { walls.speed = wallSpeed }; for walls in wallPieces2 { walls.speed = wallSpeed } } }

    var plane: SKSpriteNode!
    var platformGroup = Set<SKSpriteNode>() { didSet { platformTrigger = platformGroup.filter { $0.position.y < (frame.height / 2) } } }
    var platformSpeed: CGFloat = 0.6 { didSet { for platforms in platformGroup { platforms.speed = platformSpeed } } }

    var platformTexture: SKTexture!
    var platformPhysics: SKPhysicsBody!
    var platformGap: CGFloat!
    var platformCount = 0 {
        didSet {
            platformGap = frame.midY - (((transitionPlatform.size().height * 3) * CGFloat(min(platformCount,2))))
        }
    }

    var spawnNode: SKSpriteNode!

    var timer: Timer?
    var gameState: Int = 0

    var label: SKLabelNode!
    var mode = 8 { didSet { label.text = "Mode: \(mode)" } }

    var scoreLabel: SKLabelNode!
    var score = 0 { didSet { scoreLabel.text = "\(score)" } }
    var finalScoreLabel: SKLabelNode!

    var gameIsPaused = false

    var isButtonTouched: String!
    var isLeftButtonPressed: Bool!
    var isRightButtonPressed: Bool!

    var nodeArray = [SKNode]()
    var platformDelta: CGFloat = 0.0
    var platformArray = [SKSpriteNode]() {
        didSet {
            
            if platformArray.count > 1 {
                platformDelta = platformArray[0].position.y - platformArray[1].position.y
            }
        }
    }
    
    var firstBackground: SKTexture!
    var secondBackground: SKTexture!
    var thirdBackground: SKTexture!
    var platformTrigger = [SKSpriteNode]() { didSet { lowestPlatform = platformTrigger.sorted(by: { $0.position.y < $1.position.y})[0]; highestPlatform = platformTrigger.sorted(by: { $0.position.y > $1.position.y})[0]} }
    var lowestPlatform: SKSpriteNode!
    var highestPlatform: SKSpriteNode!
    
    var firstPlatform: SKTexture! { didSet { firstPlatformSize = firstPlatform.size() } }
    var secondPlatform: SKTexture!
    var thirdPlatform: SKTexture!
    var transitionPlatform = SKTexture(imageNamed: "desert_transition_platform")
    var firstPlatformSize: CGSize!

    var castleSky: SKTexture!
    var desertSky: SKTexture!

    var toggleNoClip: SKSpriteNode!
    var noClipLabel: SKLabelNode!
    var noClip = true { didSet { noClipLabel.text = "Collision: \(!noClip)" } }

    var initialPlatforms = true
    
    var increaseWorldSpeed: Int = 0

    override func didMove(to view: SKView) {
        
        // add a transparent bar at the top for UI elements
        let topBar = SKSpriteNode()
        topBar.size = CGSize(width: frame.width, height: frame.height / 10)
        topBar.position = CGPoint(x: frame.midX, y: frame.maxY - (topBar.size.height / 2))
        topBar.color = .black
        topBar.alpha = 0.6
        topBar.zPosition = 10
//        addChild(topBar)
        
        print("When lowestPlatform is greater than this point \((self.frame.midY / 2) - self.transitionPlatform.size().height * 3)")
        platformGap = frame.midY - (((transitionPlatform.size().height * 3) * CGFloat(min(platformCount,2))))
        
        initiateTextures()
        createPlane()
        createLabels()
        createButtons()
        
        createBackground()
        createSky()
        platformer()
//        print("tran plat: \(transitionPlatform.size().height)")
//        createWalls()
//        startPlatforms()
        planeMode()
        musicPlayer()
//        createSky()

        toggleNoClip = SKSpriteNode(imageNamed: "no_clip")
        toggleNoClip.size = CGSize(width: 48, height: 48)
        toggleNoClip.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 50)
        toggleNoClip.color = .black
        toggleNoClip.alpha = 1
        toggleNoClip.zPosition = 400
        toggleNoClip.name = "noClip"
        addChild(toggleNoClip)

        noClipLabel = SKLabelNode(fontNamed: "Paper Plane Font")
        noClipLabel.position = CGPoint(x: frame.midX, y: frame.minY + 50)
        noClipLabel.zPosition = 200
        noClipLabel.fontSize = 30
        noClipLabel.text = "Collision: \(!noClip)"
        addChild(noClipLabel)


        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

//        print(frame.width)
//        print(frame.height)
//        print(" maxY when lowestPlatform \(self.frame.midY - self.transitionPlatform.size().height * 3)")
//        print("transition size \(transitionPlatform.size())")
    }
    
    func animateBackground(texture: SKTexture) {
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        let fadeIn = SKAction.fadeIn(withDuration: 0.4)
        let setTexture = SKAction.run {
            self.backgroundTexture = texture
        }
        let seq = SKAction.sequence([fadeOut, setTexture, fadeIn])
        
        run(seq)
    }


    func initiateTextures() {
        // perhaps two or three switch cases which will read which properties are set to which then go down the list and pick which texture fits within those parameters. e.g. World? -> Theme? -> Stage? : World gives you the asset catelog for the particular world | Theme gives you the asset catelog within that chosen world | Stage gives you the sizes for the platforms for any given set theme.


//        switch world {
//        case "classic":
//        case "world2":
//        case "world3":
//        }


        switch theme {
        case "castle":
            firstBackground = SKTexture(imageNamed: "castle_background_2")
            secondBackground = SKTexture(imageNamed: "castle_background_1")
            thirdBackground = SKTexture(imageNamed: "castle_background_3")

            firstPlatform = SKTexture(imageNamed: "desert_platform_1")
            secondPlatform = SKTexture(imageNamed: "desert_platform_2")
            thirdPlatform = SKTexture(imageNamed: "desert_platform_3")
            transitionPlatform = SKTexture(imageNamed: "desert_transition_platform")
            
            skyTexture = SKTexture(imageNamed: "sky_background_day")
            cloudsTexture = SKTexture(imageNamed: "clouds_day")

        case "chasm":
            firstBackground = SKTexture(imageNamed: "cave_background_1")
            secondBackground = SKTexture(imageNamed: "cave_background_2")
            thirdBackground = SKTexture(imageNamed: "cave_background_3")

            firstPlatform = SKTexture(imageNamed: "desert_platform_1")
            secondPlatform = SKTexture(imageNamed: "desert_platform_2")
            thirdPlatform = SKTexture(imageNamed: "desert_platform_3")
            transitionPlatform = SKTexture(imageNamed: "desert_transition_platform")

            skyTexture = SKTexture(imageNamed: "sky_background_night")
            
        case "silo":
            firstBackground = SKTexture(imageNamed: "silo_background_1")
            secondBackground = SKTexture(imageNamed: "silo_background_2")
            thirdBackground = SKTexture(imageNamed: "silo_background_1")

            firstPlatform = SKTexture(imageNamed: "desert_platform_1")
            secondPlatform = SKTexture(imageNamed: "desert_platform_2")
            thirdPlatform = SKTexture(imageNamed: "desert_platform_3")
            transitionPlatform = SKTexture(imageNamed: "desert_transition_platform")

            skyTexture = SKTexture(imageNamed: "sky_background_night")
            cloudsTexture = SKTexture(imageNamed: "clouds_night")

        default:
            break
        }
        
        setBackground(currentStage: 1)
        setPlatforms(currentStage: 1)
    }

    func setPlatforms(currentStage: Int) {
        switch currentStage {
        case 1:
            platformTexture = firstPlatform
        case 2:
            platformTexture = secondPlatform
        case 3:
            platformTexture = thirdPlatform
        case 0:
            platformTexture = transitionPlatform
        default:
            break
        }
    }
    
    func setBackground(currentStage: Int) {
        switch currentStage {
        case 1:
            backgroundTexture = firstBackground
        case 2:
            backgroundTexture = secondBackground
//            animateBackground(texture: secondBackground)
        case 3:
            backgroundTexture = thirdBackground
        default:
            break
        }
    }


    func musicPlayer() {
        let bgMusic = SKAudioNode(fileNamed: "Paper Plane.mp3")
        addChild(bgMusic)

        if isMusicMuted == true {
            bgMusic.run(SKAction.changeVolume(to: 0, duration: 0))
        }
    }


    @objc func planeMode() {
        let currentLocation = plane.position.x

        let moveLeft = SKAction.moveTo(x: currentLocation - 1212.5, duration: 40) // old x value was (x: -1025)
        let repeatLeft = SKAction.repeatForever(moveLeft)

        let moveRight = SKAction.moveTo(x: currentLocation + 1212.5, duration: 40) // old x value was (x: 1400)
        let repeatRight = SKAction.repeatForever(moveRight)

        let moveDown = SKAction.moveTo(x: currentLocation, duration: 40)
        let repeatDown = SKAction.repeatForever(moveDown)

        if mode == 4 {
            plane.isPaused = true
        } else {
            plane.isPaused = false
        }

        switch mode {
        case 0:
            plane.texture = SKTexture(imageNamed: "Plane 1")
            plane.speed = 7
            plane.run(repeatLeft)

            backgroundSpeed = 0.3
            wallSpeed = 1
            platformSpeed = 0.6

        case 1:
            plane.texture = SKTexture(imageNamed: "Plane 2")
            plane.speed = 5
            plane.run(repeatLeft)

            backgroundSpeed = 0.6
            wallSpeed = 1.3
            platformSpeed = 0.9

        case 2:
            plane.texture = SKTexture(imageNamed: "Plane 3")
            plane.speed = 3
            plane.run(repeatLeft)

            backgroundSpeed = 0.9
            wallSpeed = 1.6
            platformSpeed = 1.3

        case 3:
            plane.texture = SKTexture(imageNamed: "Plane 4")
            plane.speed = 1
            plane.run(repeatLeft)

            backgroundSpeed = 1.1
            wallSpeed = 1.8
            platformSpeed = 1.5

        case 4:
            plane.texture = SKTexture(imageNamed: "Plane 5")
//            let move = SKAction.moveBy(x: 0, y: 0, duration: 40)
//            let loop = SKAction.repeatForever(move)
//            plane.run(loop)
            plane.run(repeatDown)

            backgroundSpeed = 1.3
            wallSpeed = 2.2
            platformSpeed = 1.8

        case 5:
            plane.texture = SKTexture(imageNamed: "Plane 6")
            plane.speed = 4
            plane.run(repeatRight)

            backgroundSpeed = 1.1
            wallSpeed = 1.8
            platformSpeed = 1.5

        case 6:
            plane.texture = SKTexture(imageNamed: "Plane 7")
            plane.speed = 5
            plane.run(repeatRight)

            backgroundSpeed = 0.9
            wallSpeed = 1.6
            platformSpeed = 1.3

        case 7:
            plane.texture = SKTexture(imageNamed: "Plane 8")
            plane.speed = 6
            plane.run(repeatRight)

            backgroundSpeed = 0.6
            wallSpeed = 1.3
            platformSpeed = 0.9

        case 8:
            plane.texture = SKTexture(imageNamed: "Plane 9")
            plane.speed = 8
            plane.run(repeatRight)

            backgroundSpeed = 0.3
            wallSpeed = 1
            platformSpeed = 0.6

        default:
            break
        }
    }


    func createPlane() {
        let planeTexture = SKTexture(imageNamed: "Plane 9")
        plane = SKSpriteNode(texture: planeTexture)
        plane.position = CGPoint(x: frame.midX / 2, y: frame.maxY - frame.maxY / 4)
        plane.zPosition = 5
        plane.alpha = 1
//        plane.colorBlendFactor = 1
//        plane.color = plane.color
        plane.size = CGSize(width: 96, height: 96)
        plane.name = "plane"
        addChild(plane)
        nodeArray.append(plane)

        plane.physicsBody = SKPhysicsBody(circleOfRadius: plane.size.width / 7)
        plane.physicsBody!.contactTestBitMask = plane.physicsBody!.collisionBitMask
        plane.physicsBody?.collisionBitMask = 0
        plane.physicsBody?.isDynamic = true
    }


    func createLabels() {
        scoreLabel = SKLabelNode(fontNamed: "Paper Plane Font") // Asai-Analogue
        scoreLabel.text = "\(score)"
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY * 0.95)
        scoreLabel.fontSize = 60
        scoreLabel.zPosition = 220
        addChild(scoreLabel)

        label = SKLabelNode(fontNamed: "Paper Plane Font")
        label.text = "Mode: \(mode)"
        label.position = CGPoint(x: 660, y: 1280)
        label.horizontalAlignmentMode = .right
        label.zPosition = 50
//        addChild(label)
    }


    func createBackground() {

        for i in 0 ... 1 {

            // use anchorPoint (0, 0) with old background.position -- old anchor/position doesn't set the top of BG at the top of the scene
            let background = backgroundPieces[i]
            background.texture = backgroundTexture
            background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            background.zPosition = -5
            background.size = CGSize(width: frame.size.width, height: frame.size.width * 2.5)

            
            background.position = CGPoint(x: view!.center.x, y: view!.center.y + background.size.height + (-background.size.height) + (-background.size.height * CGFloat(i)))
            
//            background.position = CGPoint(x: 0, y: background.size.height + (-background.size.height) + (-background.size.height * CGFloat(i)))

            self.addChild(background)
            nodeArray.append(background)

            let scrollUp = SKAction.moveBy(x: 0, y: background.size.height, duration: 5)
            let scrollReset = SKAction.moveBy(x: 0, y: -background.size.height, duration: 0)
            let scrollLoop = SKAction.sequence([scrollUp, scrollReset])
            let scrollForever = SKAction.repeatForever(scrollLoop)


            background.run(scrollForever)
        }
    }

    func createSky() {
        let sky = SKSpriteNode()
        sky.texture = skyTexture
        sky.position = CGPoint(x: frame.midX, y: frame.midY)
        sky.size = CGSize(width: frame.size.width, height: frame.size.height)
        sky.zPosition = -30
        addChild(sky)
        
        for i in 0 ... 1 {

            let clouds = cloudPieces[i]
            clouds.texture = cloudsTexture
            clouds.anchorPoint = CGPoint(x: 0, y: 0)
            clouds.zPosition = -25
            clouds.size = CGSize(width: frame.size.width, height: frame.size.width * 2.5)

            clouds.position = CGPoint(x: sky.size.width + (-sky.size.width) + (-sky.size.width * CGFloat(i)), y: 0)

            self.addChild(clouds)
            nodeArray.append(clouds)

            let scrollSideways = SKAction.moveBy(x: clouds.size.width, y: 0, duration: 22)
            let scrollReset = SKAction.moveBy(x: -clouds.size.width, y: 0, duration: 0)
            let scrollLoop = SKAction.sequence([scrollSideways, scrollReset])
            let scrollForever = SKAction.repeatForever(scrollLoop)

            clouds.run(scrollForever)
        }
    }
    
    
    func createPlatforms(yPosition: CGFloat) {
   
        let min = CGFloat(frame.width / 6)
        let max = CGFloat(frame.width / 3)
        var xPosition = CGFloat.random(in: -min ... max)
        
//        print("min \(min)")
//        print("max \(max)")
//        print("xPosition \(xPosition)")
//        print("frame.x \(frame.minX)")


        if platformCount >= 19 && platformCount < 30 {
            setPlatforms(currentStage: 0)
            xPosition = frame.width * 0.125
        } else if platformCount == 30 {
            setPlatforms(currentStage: 2)
        } else if platformCount >= 49 && platformCount < 60 {
            setPlatforms(currentStage: 0)
            xPosition = frame.width * 0.125
        } else if platformCount == 60 {
            setPlatforms(currentStage: 3)
        }
        
        if score == 30 {
            setBackground(currentStage: 2)
        } else if score == 60 {
            setBackground(currentStage: 3)
        }


        platformPhysics = SKPhysicsBody(rectangleOf: CGSize(width: platformTexture.size().width, height: platformTexture.size().height))
        let platformLeft = SKSpriteNode(texture: platformTexture)
        platformLeft.physicsBody = platformPhysics.copy() as? SKPhysicsBody
        platformLeft.physicsBody?.isDynamic = false
        platformLeft.physicsBody?.affectedByGravity = false
        platformLeft.physicsBody?.collisionBitMask = 0
        platformLeft.scale(to: CGSize(width: platformLeft.size.width * 3, height: platformLeft.size.height * 3))
        platformLeft.zPosition = 20
        platformLeft.name = "left_platform"
        platformLeft.speed = platformSpeed
        platformArray.append(platformLeft)

        let platformRight = SKSpriteNode(texture: platformTexture)
        platformRight.physicsBody = platformPhysics.copy() as? SKPhysicsBody
        platformRight.physicsBody?.isDynamic = true
        platformRight.physicsBody?.collisionBitMask = 0
        platformRight.scale(to: CGSize(width: platformRight.size.width * 3, height: platformRight.size.height * 3))
        platformRight.zPosition = 20
        platformRight.name = "right_platform"
        platformRight.speed = platformSpeed
        
        let scoreNode = SKSpriteNode(color: UIColor.clear, size: CGSize(width: frame.width, height: firstPlatform.size().height))
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.zPosition = 100
        scoreNode.name = "scoreDetect"
        scoreNode.speed = platformSpeed


        let newNodes: Set<SKSpriteNode> = [platformLeft, platformRight, scoreNode]
        for node in newNodes {
            platformGroup.insert(node)
        }

        let gapSize: CGFloat = -frame.size.width / 6
        platformLeft.position = CGPoint(x: xPosition + platformLeft.size.width - gapSize, y: yPosition )
        platformRight.position = CGPoint(x: xPosition + gapSize, y: yPosition)
        scoreNode.position = CGPoint(x: frame.midX, y: platformLeft.position.y)

        let endPosition = frame.maxY + frame.midY

        let moveAction = SKAction.moveBy(x: 0, y: endPosition, duration: 7)

        for node in newNodes {
            let moveSequence = SKAction.sequence([
                moveAction,
                SKAction.removeFromParent(),
                SKAction.run {
                    self.platformGroup.remove(node)
                }
            ])

            addChild(node)
            nodeArray.append(node)
            node.run(moveSequence)
        }
        
        platformCount += 1
        print("platform position \(platformLeft.position.y)")
        
        increaseWorldSpeed += 1
        if increaseWorldSpeed % 10 == 0 {
            if scene!.speed <= 1.75 {
                scene?.speed = scene!.speed + 0.05
                print("Game Speed: \(scene!.speed)")
                if scene!.speed > 1.75 {
                    scene?.speed = 1.75
                }
            }
        }
        
        print(platformCount)
//         platformMonitor()
    }
    
    
    func platformer() {
        if self.platformCount == 0 {
            self.createPlatforms(yPosition: platformGap)
            self.createPlatforms(yPosition: platformGap)
            self.createPlatforms(yPosition: platformGap)
        }
    }
    


    func createButtons() {
        buttonLeft = SKSpriteNode()
        buttonLeft.size = CGSize(width: frame.width / 2, height: frame.height)
        buttonLeft.position = CGPoint(x: frame.midX / 2, y: frame.midY)
//        buttonLeft.color = .black
        buttonLeft.alpha = 1
        buttonLeft.name = "buttonLeft"
        buttonLeft.zPosition = 200
        addChild(buttonLeft)

        buttonRight = SKSpriteNode()
        buttonRight.size = CGSize(width: frame.width / 2, height: frame.height)
        buttonRight.position = CGPoint(x: frame.midX * 1.5, y: frame.midY)
//        buttonRight.color = .black
        buttonRight.alpha = 1
        buttonRight.name = "buttonRight"
        buttonRight.zPosition = 200
        addChild(buttonRight)

        pauseButton = SKSpriteNode(imageNamed: "Pause Button")
        pauseButton.size = CGSize(width: 48, height: 48)
        pauseButton.position = CGPoint(x: frame.maxX - 50, y: frame.maxY - 50)
        pauseButton.zPosition = 250
        pauseButton.name = "pauseButton"
        addChild(pauseButton)
    }


    func changeMode(node: SKSpriteNode) {
        guard gameIsPaused == false else { return } // this may cause a bug if the player has died and presses the pause button to set gameIsPaused to true, which the restart you need to click the pause button again to set flag to false

        if node == buttonLeft {
            mode -= 1
        } else if node == buttonRight {
            mode += 1
        }

        if mode <= 8 && mode >= 0 {
             planeMode()
        } else if mode > 8 {
         mode = 8
        } else if mode < 0 {
         mode = 0
        }


        if gameState == 1 {
            gameOver() // may want to be wary on how this is called because it is dependent on both gameState to == 1 and this call to be present as well
        }
    }


    func restartGame(node: SKSpriteNode) {
        if let scene = GameSceneNewNew(fileNamed: "GameSceneNewNew") {
            scene.scaleMode = .aspectFill
            scene.size = self.view!.frame.size
            let transition = SKTransition.fade(with: .black, duration: 2)
            view?.presentScene(scene, transition: transition)
        }
    }


    func backToTitle(node: SKSpriteNode) {
        if let skView = self.view {

            guard let scene = TitleScreen(fileNamed: "TitleScreen") else { return }
            let transition = SKTransition.fade(withDuration: 1.5)
            scene.size = skView.frame.size

            scene.scaleMode = .aspectFill

            skView.presentScene(scene, transition: transition)
            pauseButton.removeFromParent()
            buttonLeft.removeFromParent()
            buttonRight.removeFromParent()
        }
    }


    func pause(isPaused: Bool) {
        if isPaused == true {
            for node in nodeArray {
                node.isPaused = true
            }
            // self.view?.isPaused = isPaused
        } else if isPaused == false {
            for node in nodeArray {
                node.isPaused = false
            }
        }
    }


    func pauseGame() {
        pauseMenu.size = CGSize(width: 1, height: 1)
//        pauseMenu.color = .black
        pauseMenu.alpha = 1
//        pauseMenu.texture = nil
        pauseMenu.zPosition = 210
        pauseMenu.position = CGPoint(x: frame.midX, y: frame.midY + 100)

        homeButton.size = CGSize(width: 80, height: 80)
//        homeButton.texture = nil
        homeButton.zPosition = 220
        homeButton.position = CGPoint(x: pauseMenu.frame.midX + pauseMenu.frame.midX / 3, y: pauseMenu.frame.midY)
        homeButton.name = "homeButton"

        restartButton.size = CGSize(width: 80, height: 80)
        restartButton.zPosition = 220
//        restartButton.texture = nil
        restartButton.position = CGPoint(x: pauseMenu.frame.midX - pauseMenu.frame.midX / 3, y: pauseMenu.frame.midY)
        restartButton.name = "restartButton"

        let scalePrelim = SKAction.scale(to: CGSize(width: 1, height: 1), duration: 0)
        let scalePauseMenuUp = SKAction.scale(to: CGSize(width: 300, height: 150), duration: 0.065)
        let scaleMenuButtonsUp = SKAction.scale(to: CGSize(width: 80, height: 80), duration: 0.065)

        let scaleSeq = SKAction.sequence([scalePrelim, scaleMenuButtonsUp])

        if gameIsPaused == false {
            addChild(pauseMenu)
            addChild(homeButton)
            addChild(restartButton)

            pauseMenu.run(scalePauseMenuUp)
            homeButton.run(scaleSeq)
            restartButton.run(scaleSeq)

            gameIsPaused.toggle()
            pause(isPaused: gameIsPaused)

        } else if gameIsPaused == true {
            pauseMenu.removeFromParent()
            homeButton.removeFromParent()
            restartButton.removeFromParent()

            gameIsPaused.toggle()
            pause(isPaused: gameIsPaused)
        }
    }


    func gameOver() {
        childNode(withName: "continueLabel")?.removeFromParent()
        
        gameOverWindow.size = CGSize(width: 1, height: 1)
        gameOverWindow.alpha = 1
        gameOverWindow.zPosition = 170
        gameOverWindow.position = CGPoint(x: frame.midX, y: frame.midY + 100)

        homeButton.size = CGSize(width: 96, height: 96)
        homeButton.zPosition = 210
        homeButton.position = CGPoint(x: gameOverWindow.frame.midX + 75, y: gameOverWindow.frame.midY - 75)
        homeButton.name = "homeButton"

        restartButton.size = CGSize(width: 96, height: 96)
        restartButton.zPosition = 210
        restartButton.position = CGPoint(x: gameOverWindow.frame.midX - 75, y: gameOverWindow.frame.midY - 75)
        restartButton.name = "restartButton"

        finalScoreLabel = SKLabelNode(fontNamed: "Paper Plane Font")
        finalScoreLabel.text = "Score"
        finalScoreLabel.color = .darkGray
        finalScoreLabel.fontSize = 70
        finalScoreLabel.position = CGPoint(x: gameOverWindow.frame.midX, y: gameOverWindow.frame.maxY * 1.27)
        finalScoreLabel.zPosition = 210

        let scalePrelim = SKAction.scale(to: CGSize(width: 1, height: 1), duration: 0)
        let scaleGameOverMenuUp = SKAction.scale(to: CGSize(width: frame.size.width - frame.size.width / 6, height: frame.size.width - frame.size.width / 6), duration: 0.065)
        let scaleMenuButtonsUp = SKAction.scale(to: CGSize(width: 96, height: 96), duration: 0.065)

        let scaleSeq = SKAction.sequence([scalePrelim, scaleMenuButtonsUp])

        let moveScore = SKAction.move(to: CGPoint(x: gameOverWindow.frame.midX, y: gameOverWindow.frame.maxY * 1.15), duration: 1.6)
        let pulseUp = SKAction.scale(to: 2.0, duration: 0.8)
        let pulseDown = SKAction.scale(to: 1, duration: 0.8)

        let pulseSeq = SKAction.sequence([pulseUp, pulseDown])


        if gameState == 1 {

            GameplayStats.shared.setScore(score)
            
            scene!.speed = 1.00

            addChild(gameOverWindow)
            addChild(homeButton)
            addChild(restartButton)

            gameOverWindow.run(scaleGameOverMenuUp)
            homeButton.run(scaleSeq)
            restartButton.run(scaleSeq)

            addChild(finalScoreLabel)
            scoreLabel.run(moveScore)
            scoreLabel.run(pulseSeq)

            gameIsPaused = true
            pause(isPaused: gameIsPaused)
        }
    }


    func didBegin(_ contact: SKPhysicsContact) {
//        print("collision")

         if contact.bodyA.node?.name == "scoreDetect" || contact.bodyB.node?.name == "scoreDetect" {
             if contact.bodyA.node == plane {
                 contact.bodyB.node?.removeFromParent()
             } else {
                 contact.bodyA.node?.removeFromParent()
             }

             score += 1

             return
         }

//        if contact.bodyA.node?.name == "platformTrigger" || contact.bodyB.node?.name == "platformTrigger" {
//            if contact.bodyA.node?.name == "spawn" || contact.bodyB.node?.name == "spawn" {
//                let create = SKAction.run { [unowned self] in
//                    self.createPlatforms()
//                }
//
//                run(create)
//
//            }
//        }


        guard contact.bodyA.node != nil && contact.bodyB.node != nil else {
            return
        }

        guard noClip == false else { return }

        if contact.bodyA.node == plane || contact.bodyB.node == plane {
            if contact.bodyA.node?.name == "platformTrigger" || contact.bodyB.node?.name == "platformTrigger" {
                return
            }
            
            if let particles = SKEmitterNode(fileNamed: "DestroyPlane") {
                particles.position = plane.position
                particles.zPosition = 50
                addChild(particles)
            }
            
            let continueLabel = SKLabelNode(fontNamed: "Paper Plane Font")
            continueLabel.position = CGPoint(x: frame.midX, y: frame.maxY * 0.65)
            continueLabel.fontSize = 45
            continueLabel.text = "Tap to continue"
            continueLabel.color = .black
            continueLabel.alpha = 0
            continueLabel.zPosition = 70
            continueLabel.name = "continueLabel"
            addChild(continueLabel)
            
            let fadeAlphaTo = SKAction.fadeAlpha(to: 0.5, duration: 1)
            let fadeIn = SKAction.fadeIn(withDuration: 1.5)
            let wait = SKAction.wait(forDuration: 1.2)
            let fadeOut = SKAction.fadeOut(withDuration: 1.5)
            let fadeInFadeOut = SKAction.sequence([fadeIn, wait, fadeOut])
            let repeatForever = SKAction.repeatForever(fadeInFadeOut)
            
            continueLabel.run(repeatForever)

            plane.removeFromParent()
            backgroundSpeed = 0
            wallSpeed = 0
            platformSpeed = 0
            gameState = 1

            pauseButton.removeFromParent()
            toggleNoClip.removeFromParent()
        }
    }


    func start() {
        scene?.view?.isPaused = false
    }


    override func update(_ currentTime: TimeInterval) {
        if platformCount >= 3 {
            // print("platformCount: \(platformCount)")
             // Dont care about duplicate position platforms
//            print("platformTrigger: \(platformTrigger.count)")
            // DispatchQueue.global(qos: .background).async {
            //    while self.topPlatform.position.y < (self.frame.midY - self.transitionPlatform.size().height * 3) {
            if self.lowestPlatform.position.y >= ((self.frame.midY / 1.5) - self.transitionPlatform.size().height * 3) {
                
                self.createPlatforms(yPosition: lowestPlatform.position.y - (transitionPlatform.size().height * 3 - firstPlatform.size().height / 2))
                
//                         self.platformArray.append(self.topPlatform)
                // print("called createPlatforms()")
            }
            
            if highestPlatform.position.y >= plane.position.y {
                score += 1
            }
        }
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)



        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)

            let cycle = SKAction.run {
                self.changeMode(node: touchedNode as! SKSpriteNode)
            }
            let delay = SKAction.wait(forDuration: 0.10)
            let seq = SKAction.sequence([cycle, delay])
            let repeatAction = SKAction.repeatForever(seq)

            if touchedNode.name == "buttonLeft" {
                isButtonTouched = "buttonLeft"

                buttonLeft.run(repeatAction, withKey: "cycle")
//                isLeftButtonPressed = true
            }

            if touchedNode.name == "buttonRight" {
                isButtonTouched = "buttonRight"

                buttonRight.run(repeatAction, withKey: "cycle")
//                isRightButtonPressed = true
            }

            if touchedNode.name == "pauseButton" {
                Animations.shared.shrink(node: pauseButton)
                isButtonTouched = "pauseButton"
            }

            if touchedNode.name == "homeButton" {
                Animations.shared.shrink(node: homeButton)
                isButtonTouched = "homeButton"
            }

            if touchedNode.name == "restartButton" {
                Animations.shared.shrink(node: restartButton)
                isButtonTouched = "restartButton"
            }

            if touchedNode.name == "noClip" {
                Animations.shared.shrink(node: toggleNoClip)
                isButtonTouched = "noClip"
            }
        }
    }


    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)

            // logically it can be put as only: else if isButtonIsTouched == "\stringName" rather than including touchedNode.name as well
            if touchedNode.name == "noClip" && isButtonTouched == "noClip" {
                Animations.shared.expand(node: toggleNoClip)
            } else if touchedNode.name != "" && isButtonTouched == "noClip" {
                Animations.shared.expand(node: toggleNoClip)
            }

            if touchedNode.name == "pauseButton" && isButtonTouched == "pauseButton" {
                pauseGame()
                Animations.shared.expand(node: pauseButton)
            } else if touchedNode.name != "" && isButtonTouched == "pauseButton" {
                Animations.shared.expand(node: pauseButton)
            }

            if touchedNode.name == "homeButton" {
                Animations.shared.expand(node: homeButton)
                backToTitle(node: homeButton)
            } else if touchedNode.name != "" && isButtonTouched == "homeButton" {
                Animations.shared.expand(node: homeButton)
            }

            if touchedNode.name == "restartButton" {
                Animations.shared.expand(node: restartButton)
                restartGame(node: restartButton)
            } else if touchedNode.name != "" && isButtonTouched == "restartButton" {
                Animations.shared.expand(node: restartButton)
            }

            if touchedNode.name == "noClip" {
                noClip = !noClip
            }



            buttonLeft.removeAction(forKey: "cycle")
            buttonRight.removeAction(forKey: "cycle")

            isButtonTouched = ""
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)

            // this may be bugged or lack the feature of swiping your finger button to button to quickly change presses. May need to just be moved to touchedEnded in some form or another.

            if touchedNode.name != "buttonleft" {
                buttonLeft.removeAction(forKey: "cycle")
            }

            if touchedNode.name != "buttonRight" {
                buttonLeft.removeAction(forKey: "cycle")
            }
        }
    }
}
