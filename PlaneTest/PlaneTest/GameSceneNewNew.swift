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

    var skyPieces: [SKSpriteNode] = [SKSpriteNode(), SKSpriteNode()]
    var skyTexture: SKTexture! { didSet { for sky in skyPieces { sky.texture = skyTexture } } }

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
    var platformTrigger = [SKSpriteNode]() { didSet { topPlatform = platformTrigger.sorted(by: { $0.position.y < $1.position.y})[0] } }
    var topPlatform: SKSpriteNode!
    
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

    override func didMove(to view: SKView) {
        platformGap = frame.midY - (((transitionPlatform.size().height * 3) * CGFloat(min(platformCount,2))))
        setTextures(currentStage: 1)
        physicsWorld.speed = 1.0

        createPlane()
        createLabels()
        createButtons()
        
        createBackground()
        createSky()
        platformer()
        print("tran plat: \(transitionPlatform.size().height)")
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

        noClipLabel = SKLabelNode()
        noClipLabel.position = CGPoint(x: frame.midX, y: frame.minY + 50)
        noClipLabel.zPosition = 200
        noClipLabel.fontSize = 24
        noClipLabel.fontName = "Helvetica"
        noClipLabel.text = "Collision: \(!noClip)"
        addChild(noClipLabel)


        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

        print(frame.width)
        print(frame.height)
        print(" maxY when topPlatform \(self.frame.midY - self.transitionPlatform.size().height * 3)")
//        print("transition size \(transitionPlatform.size())")
    }


    func setTextures(currentStage: Int) {
        stage = currentStage
        // perhaps two or three switch cases which will read which properties are set to which then go down the list and pick which texture fits within those parameters. e.g. World? -> Theme? -> Stage? : World gives you the asset catelog for the particular world | Theme gives you the asset catelog within that chosen world | Stage gives you the sizes for the platforms for any given set theme.


//        switch world {
//        case "classic":
//        case "world2":
//        case "world3":
//        }


        switch theme {
        case "castle":
            firstBackground = SKTexture(imageNamed: "castle_background_1")
            secondBackground = SKTexture(imageNamed: "castle_background_2")
            thirdBackground = SKTexture(imageNamed: "castle_background_3")

            firstPlatform = SKTexture(imageNamed: "desert_platform_1")
            secondPlatform = SKTexture(imageNamed: "desert_platform_2")
            thirdPlatform = SKTexture(imageNamed: "desert_platform_3")
            transitionPlatform = SKTexture(imageNamed: "desert_transition_platform")

            castleSky = SKTexture(imageNamed: "sky_background")

        case "cave":
            firstBackground = SKTexture(imageNamed: "cave_background_2")
            secondBackground = SKTexture(imageNamed: "cave_background_2")
            thirdBackground = SKTexture(imageNamed: "cave_background_3")

            firstPlatform = SKTexture(imageNamed: "desert_platform_1")
            secondPlatform = SKTexture(imageNamed: "desert_platform_2")
            thirdPlatform = SKTexture(imageNamed: "desert_platform_3")
            transitionPlatform = SKTexture(imageNamed: "desert_transition_platform")

            desertSky = SKTexture(imageNamed: "sky_background")
            
        case "reactor":
            firstBackground = SKTexture(imageNamed: "desert_background_1")
            secondBackground = SKTexture(imageNamed: "desert_background_2")
            thirdBackground = SKTexture(imageNamed: "desert_background_3")

            firstPlatform = SKTexture(imageNamed: "desert_platform_1")
            secondPlatform = SKTexture(imageNamed: "desert_platform_2")
            thirdPlatform = SKTexture(imageNamed: "desert_platform_3")
            transitionPlatform = SKTexture(imageNamed: "desert_transition_platform")

            desertSky = SKTexture(imageNamed: "sky_background")

        default:
            break
        }


        switch stage {
        case 1:
            backgroundTexture = firstBackground
            platformTexture = firstPlatform
            skyTexture = castleSky

        case 2:
            backgroundTexture = secondBackground
            platformTexture = secondPlatform
            skyTexture = castleSky

        case 3:
            backgroundTexture = thirdBackground
            platformTexture = thirdPlatform
            skyTexture = castleSky

        case 0:
            platformTexture = transitionPlatform
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

            backgroundSpeed = 1
            wallSpeed = 1
            platformSpeed = 0.6

        case 1:
            plane.texture = SKTexture(imageNamed: "Plane 2")
            plane.speed = 5
            plane.run(repeatLeft)

            backgroundSpeed = 1.3
            wallSpeed = 1.3
            platformSpeed = 0.9

        case 2:
            plane.texture = SKTexture(imageNamed: "Plane 3")
            plane.speed = 3
            plane.run(repeatLeft)

            backgroundSpeed = 1.6
            wallSpeed = 1.6
            platformSpeed = 1.3

        case 3:
            plane.texture = SKTexture(imageNamed: "Plane 4")
            plane.speed = 1
            plane.run(repeatLeft)

            backgroundSpeed = 1.8
            wallSpeed = 1.8
            platformSpeed = 1.5

        case 4:
            plane.texture = SKTexture(imageNamed: "Plane 5")
//            let move = SKAction.moveBy(x: 0, y: 0, duration: 40)
//            let loop = SKAction.repeatForever(move)
//            plane.run(loop)
            plane.run(repeatDown)

            backgroundSpeed = 2.2
            wallSpeed = 2.2
            platformSpeed = 1.8

        case 5:
            plane.texture = SKTexture(imageNamed: "Plane 6")
            plane.speed = 4
            plane.run(repeatRight)

            backgroundSpeed = 1.8
            wallSpeed = 1.8
            platformSpeed = 1.5

        case 6:
            plane.texture = SKTexture(imageNamed: "Plane 7")
            plane.speed = 5
            plane.run(repeatRight)

            backgroundSpeed = 1.6
            wallSpeed = 1.6
            platformSpeed = 1.3

        case 7:
            plane.texture = SKTexture(imageNamed: "Plane 8")
            plane.speed = 6
            plane.run(repeatRight)

            backgroundSpeed = 1.3
            wallSpeed = 1.3
            platformSpeed = 0.9

        case 8:
            plane.texture = SKTexture(imageNamed: "Plane 9")
            plane.speed = 8
            plane.run(repeatRight)

            backgroundSpeed = 1
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
        scoreLabel = SKLabelNode(fontNamed: "Asai-Analogue")
        scoreLabel.text = "\(score)"
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 120)
        scoreLabel.fontSize = 150
        scoreLabel.zPosition = 220
        addChild(scoreLabel)

        label = SKLabelNode(fontNamed: "")
        label.text = "Mode: \(mode)"
        label.position = CGPoint(x: 660, y: 1280)
        label.horizontalAlignmentMode = .right
        label.zPosition = 50
//        addChild(label)
    }


    func createBackground() {

        for i in 0 ... 1 {

            let background = backgroundPieces[i]
            background.texture = backgroundTexture
            background.anchorPoint = CGPoint(x: 0, y: 0)
            background.zPosition = -5
            background.size = CGSize(width: frame.size.width, height: frame.size.width * 2.5)

            background.position = CGPoint(x: 0, y: background.size.height + (-background.size.height) + (-background.size.height * CGFloat(i)))

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
        for i in 0 ... 1 {

            let sky = skyPieces[i]
            sky.texture = skyTexture
            sky.anchorPoint = CGPoint(x: 0, y: 0)
            sky.zPosition = -25
            sky.size = CGSize(width: frame.size.width, height: frame.size.width * 2.5)

            sky.position = CGPoint(x: sky.size.width + (-sky.size.width) + (-sky.size.width * CGFloat(i)), y: 0)

            self.addChild(sky)
            nodeArray.append(sky)

            let scrollSideways = SKAction.moveBy(x: sky.size.width, y: 0, duration: 22)
            let scrollReset = SKAction.moveBy(x: -sky.size.width, y: 0, duration: 0)
            let scrollLoop = SKAction.sequence([scrollSideways, scrollReset])
            let scrollForever = SKAction.repeatForever(scrollLoop)

            sky.run(scrollForever)
        }
    }
    
    
    func createPlatforms() {
   
        let min = CGFloat(frame.width / 12)
        let max = CGFloat(frame.width / 3)
        var xPosition = CGFloat.random(in: -min ... max)


        if platformCount >= 19 && platformCount < 30 {
            setTextures(currentStage: 0)
            xPosition = frame.width * 0.125
        } else if platformCount == 30 {
            setTextures(currentStage: 2)
        } else if platformCount >= 50 && platformCount < 60 {
            setTextures(currentStage: 0)
            xPosition = 184
        } else if platformCount == 60 {
            setTextures(currentStage: 3)
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

        let newNodes: Set<SKSpriteNode> = [platformLeft, platformRight]
        for node in newNodes {
            platformGroup.insert(node)
        }

        let gapSize: CGFloat = -frame.size.width / 6
        platformLeft.position = CGPoint(x: xPosition + platformLeft.size.width - gapSize, y: platformGap )
        platformRight.position = CGPoint(x: xPosition + gapSize, y: platformGap)
        // scoreNode.position = CGPoint(x: frame.midX, y: platformLeft.position.y - platformLeft.size.height / 2)

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
        
        // platformMonitor()
    }
    
    
    func platformer() {
        if self.platformCount == 0 {
            self.createPlatforms()
            self.createPlatforms()
            self.createPlatforms()
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

        finalScoreLabel = SKLabelNode(fontNamed: "Asai-Analogue")
        finalScoreLabel.text = "Score"
        finalScoreLabel.color = .darkGray
        finalScoreLabel.fontSize = 70
        finalScoreLabel.position = CGPoint(x: gameOverWindow.frame.midX, y: gameOverWindow.frame.maxY * 1.2)
        finalScoreLabel.zPosition = 210

        let scalePrelim = SKAction.scale(to: CGSize(width: 1, height: 1), duration: 0)
        let scaleGameOverMenuUp = SKAction.scale(to: CGSize(width: frame.size.width - frame.size.width / 6, height: frame.size.width - frame.size.width / 6), duration: 0.065)
        let scaleMenuButtonsUp = SKAction.scale(to: CGSize(width: 96, height: 96), duration: 0.065)

        let scaleSeq = SKAction.sequence([scalePrelim, scaleMenuButtonsUp])

        let moveScore = SKAction.move(to: CGPoint(x: gameOverWindow.frame.midX, y: gameOverWindow.frame.midY + 10), duration: 1.6)
        let pulseUp = SKAction.scale(to: 2.0, duration: 0.8)
        let pulseDown = SKAction.scale(to: 1, duration: 0.8)

        let pulseSeq = SKAction.sequence([pulseUp, pulseDown])


        if gameState == 1 {

            GameplayStats.shared.setScore(score)

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

        // if contact.bodyA.node?.name == "scoreDetect" || contact.bodyB.node?.name == "scoreDetect" {
        //     if contact.bodyA.node == plane {
        //         contact.bodyB.node?.removeFromParent()
        //     } else {
        //         contact.bodyA.node?.removeFromParent()
        //     }

        //     score += 1

        //     return
        // }

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
            if self.topPlatform.position.y >= (self.frame.midY - self.transitionPlatform.size().height * 3) {
                print("topPlatform End position: \(topPlatform.position.y)")
                self.createPlatforms()
//                         self.platformArray.append(self.topPlatform)
                // print("called createPlatforms()")
            }
        }
        print(topPlatform.position.y)
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
