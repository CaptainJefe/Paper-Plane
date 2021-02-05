//
//  GameScene.swift
//  PlaneTest
//
//  Created by Cade Williams on 8/21/20.
//  Copyright © 2020 Cade Williams. All rights reserved.
//

import AVFoundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var buttonRight: SKSpriteNode!
    var buttonLeft: SKSpriteNode!
    var pauseButton: SKSpriteNode!
    
    var pauseMenu = SKSpriteNode(imageNamed: "Pause Window")
    var gameOverWindow = SKSpriteNode(imageNamed: "Game Over Window")
    var homeButton = SKSpriteNode(imageNamed: "Home Button")
    var restartButton = SKSpriteNode(imageNamed: "Restart Button")
    
    var backgroundPieces: [SKSpriteNode] = [SKSpriteNode(imageNamed: "Background"), SKSpriteNode(imageNamed: "Background")]
    var backgroundSpeed: CGFloat = 1.0 { didSet { for background in backgroundPieces { background.speed = backgroundSpeed } } }
    
    var wallPieces: [SKSpriteNode] = [SKSpriteNode(imageNamed: "Wall"), SKSpriteNode(imageNamed: "Wall")]
    var wallPieces2: [SKSpriteNode] = [SKSpriteNode(imageNamed: "Wall"), SKSpriteNode(imageNamed: "Wall")]
    var wallSpeed: CGFloat = 1.0 { didSet { for walls in wallPieces { walls.speed = wallSpeed }; for walls in wallPieces2 { walls.speed = wallSpeed } } }

    var plane: SKSpriteNode!
    var platformGroup = Set<SKSpriteNode>()
    var platformSpeed: CGFloat = 0.6 { didSet { for platforms in platformGroup { platforms.speed = platformSpeed } } }
    
    var platformTexture = SKTexture(imageNamed: "platform")
    var platformPhysics: SKPhysicsBody!
    
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
    
    
    var nodeArray = [SKNode]()
    
    // Going to use whenever I want to have a transition period; i.e. when count == 20 (when 20 are created) do a certain thing, like straight down movement so platforms are next to each other
    var platformCount = 0
    
    
    override func didMove(to view: SKView) {
        createPlane()
        createLabels()
        createButtons()
        createBackground()
//        createWalls()
        startPlatforms()
        planeMode()
        musicPlayer()
//        createSky()
        
        spawnNode = SKSpriteNode(color: UIColor.clear, size: CGSize(width: frame.width, height: 20))
        spawnNode.name = "spawn"
        spawnNode.zPosition = 40
        spawnNode.position = CGPoint(x: frame.midX, y: -(frame.minY + (frame.midY / 2)) + 512) // original is - 390 // 768 is 1.5x the height of the transition platform so when it spawns it needs to go it's entire height to space correctly, so it's entire height + half of it's height because it spawns from the middle of the texture.
        addChild(spawnNode)
        
        spawnNode.physicsBody = SKPhysicsBody(rectangleOf: spawnNode.size)
        spawnNode.physicsBody?.isDynamic = false
        spawnNode.physicsBody!.contactTestBitMask = spawnNode.physicsBody!.collisionBitMask
        spawnNode.physicsBody?.collisionBitMask = 1
        spawnNode.physicsBody?.affectedByGravity = false
        

        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    func musicPlayer() {
        let bgMusic = SKAudioNode(fileNamed: "Paper Plane.mp3")
        addChild(bgMusic)
        
        if isMusicMuted == true {
            bgMusic.run(SKAction.changeVolume(to: 0, duration: 0))
        }
    }
    
    @objc func planeMode() {
        
        if mode == 4 {
            plane.isPaused = true
        } else {
            plane.isPaused = false
        }
        
        switch mode {
        case 0:
            plane.texture = SKTexture(imageNamed: "Plane 1")
            plane.speed = 7
            let move = SKAction.moveTo(x: -1025, duration: 40)
            let loop = SKAction.repeatForever(move)
            plane.run(loop)
            
            
            backgroundSpeed = 1
            wallSpeed = 1
            platformSpeed = 0.6

        case 1:
            plane.texture = SKTexture(imageNamed: "Plane 2")
            plane.speed = 5
            let move = SKAction.moveTo(x: -1025, duration: 40)
            let loop = SKAction.repeatForever(move)
            plane.run(loop)
            
            
            backgroundSpeed = 1.3
            wallSpeed = 1.3
            platformSpeed = 0.9
           
        case 2:
            plane.texture = SKTexture(imageNamed: "Plane 3")
            plane.speed = 3
            let move = SKAction.moveTo(x: -1025, duration: 40)
            let loop = SKAction.repeatForever(move)
            plane.run(loop)
            
            
            backgroundSpeed = 1.6
            wallSpeed = 1.6
            platformSpeed = 1.3
            
        case 3:
            plane.texture = SKTexture(imageNamed: "Plane 4")
            plane.speed = 1
            let move = SKAction.moveTo(x: -1025, duration: 40)
            let loop = SKAction.repeatForever(move)
            plane.run(loop)
            
            
            backgroundSpeed = 1.9
            wallSpeed = 1.9
            platformSpeed = 1.6
            
        case 4:
            plane.texture = SKTexture(imageNamed: "Plane 5")
//            let move = SKAction.moveBy(x: 0, y: 0, duration: 40)
//            let loop = SKAction.repeatForever(move)
//            plane.run(loop)
            
            
            backgroundSpeed = 2.3
            wallSpeed = 2.3
            platformSpeed = 1.9
            
        case 5:
            plane.texture = SKTexture(imageNamed: "Plane 6")
            plane.speed = 4
            let move = SKAction.moveTo(x: 1400, duration: 40)
            let loop = SKAction.repeatForever(move)
            plane.run(loop)

            
            backgroundSpeed = 1.9
            wallSpeed = 1.9
            platformSpeed = 1.6
            
        case 6:
            plane.texture = SKTexture(imageNamed: "Plane 7")
            plane.speed = 5
            let move = SKAction.moveTo(x: 1400, duration: 40)
            let loop = SKAction.repeatForever(move)
            plane.run(loop)
            
            
            backgroundSpeed = 1.6
            wallSpeed = 1.6
            platformSpeed = 1.3
            
        case 7:
            plane.texture = SKTexture(imageNamed: "Plane 8")
            plane.speed = 6
            let move = SKAction.moveTo(x: 1400, duration: 40)
            let loop = SKAction.repeatForever(move)
            plane.run(loop)
            
            
            backgroundSpeed = 1.3
            wallSpeed = 1.3
            platformSpeed = 0.9
            
        case 8:
            plane.texture = SKTexture(imageNamed: "Plane 9")
            plane.speed = 8
            let move = SKAction.moveTo(x: 1400, duration: 40)
            let loop = SKAction.repeatForever(move)
            plane.run(loop)
            
            
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
        plane.position = CGPoint(x: 180, y: 1000)
        plane.zPosition = 5
        plane.alpha = 1
//        plane.colorBlendFactor = 1
//        plane.color = plane.color
        plane.size = CGSize(width: 100, height: 100)
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
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 150)
        scoreLabel.fontSize = 150
        scoreLabel.zPosition = 65
        addChild(scoreLabel)
        
        label = SKLabelNode(fontNamed: "")
        label.text = "Mode: \(mode)"
        label.position = CGPoint(x: 660, y: 1280)
        label.horizontalAlignmentMode = .right
        label.zPosition = 50
//        addChild(label)
    }
    
    
    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "Background")
        let wallTexture = SKTexture(imageNamed: "Wall")
            
        for i in 0 ... 1 {
            
            let background = backgroundPieces[i]
            background.texture = backgroundTexture
            background.anchorPoint = CGPoint(x: 0, y: 0)
            background.zPosition = -5
            background.position = CGPoint(x: 0, y: backgroundTexture.size().height + (-backgroundTexture.size().height) + (-backgroundTexture.size().height * CGFloat(i)))
            
            self.addChild(background)
            nodeArray.append(background)
            
            // walls won't loop properly unless they are being moved as backgroundTexture.size().height it seems, despite them both being the height, 2048px
            
            let wallLeft = wallPieces[i]
            wallLeft.texture = nil
            wallLeft.anchorPoint = CGPoint(x: 0, y: 0)
            wallLeft.zPosition = 50
            wallLeft.position = CGPoint(x: frame.minX, y: wallTexture.size().height + (-wallTexture.size().height) + (-wallTexture.size().height * CGFloat(i)))
            
            self.addChild(wallLeft)
            nodeArray.append(wallLeft)
            
            let wallRight = wallPieces2[i]
            wallRight.texture = nil
            wallRight.anchorPoint = CGPoint(x: 0, y: 0)
            wallRight.zPosition = 50
            wallRight.position = CGPoint(x: frame.maxX - 130, y: wallTexture.size().height + (-wallTexture.size().height) + (-wallTexture.size().height * CGFloat(i)))
            
            self.addChild(wallRight)
            nodeArray.append(wallRight)
            
            let scrollUp = SKAction.moveBy(x: 0, y: backgroundTexture.size().height, duration: 5)
            let scrollReset = SKAction.moveBy(x: 0, y: -backgroundTexture.size().height, duration: 0)
            let scrollLoop = SKAction.sequence([scrollUp, scrollReset])
            let scrollForever = SKAction.repeatForever(scrollLoop)
            
            background.run(scrollForever)
            wallLeft.run(scrollForever)
            wallRight.run(scrollForever)
        }
    }
    
    func createWalls() {
        let wallTexture = SKTexture(imageNamed: "Wall")
        
        for i in 0 ... 1 {
            
            let wallLeft = wallPieces[i]
            wallLeft.texture = wallTexture
            wallLeft.anchorPoint = CGPoint(x: 0, y: 0)
            wallLeft.zPosition = 50
            wallLeft.position = CGPoint(x: 0, y: wallTexture.size().height + (-wallTexture.size().height) + (-wallTexture.size().height * CGFloat(i)))
            
            let wallRight = wallPieces[i]
            wallRight.texture = wallTexture
            wallRight.anchorPoint = CGPoint(x: 0, y: 0)
            wallRight.zPosition = 50
            wallRight.position = CGPoint(x: 0, y: wallTexture.size().height + (-wallTexture.size().height) + (-wallTexture.size().height * CGFloat(i)))
            
            self.addChild(wallLeft)
            nodeArray.append(wallLeft)
            
            self.addChild(wallRight)
            nodeArray.append(wallRight)
            
            let scrollUp = SKAction.moveBy(x: 0, y: wallTexture.size().height, duration: 5)
            let scrollReset = SKAction.moveBy(x: 0, y: -wallTexture.size().height, duration: 0)
            let scrollLoop = SKAction.sequence([scrollUp, scrollReset])
            let scrollForever = SKAction.repeatForever(scrollLoop)
            
            wallLeft.run(scrollForever)
            wallRight.run(scrollForever)
        }
    }
    
    
    func createPlatforms() {
        let min = CGFloat(frame.width / 12)
        let max = CGFloat(frame.width / 3)
        var xPosition = CGFloat.random(in: -min ... max)
        
        if platformCount > 14 {
            platformTexture = SKTexture(imageNamed: "platform2")
        } else if platformCount > 4 {
            platformTexture = SKTexture(imageNamed: "Transition Platform")
            xPosition = 119
        }
        print(max)
        print(frame.width)
        
        platformPhysics = SKPhysicsBody(rectangleOf: CGSize(width: platformTexture.size().width, height: platformTexture.size().height))
        
        
        let platformLeft = SKSpriteNode(texture: platformTexture)
        platformLeft.physicsBody = platformPhysics.copy() as? SKPhysicsBody
        platformLeft.physicsBody?.isDynamic = false
        platformLeft.physicsBody?.affectedByGravity = false
        platformLeft.physicsBody?.collisionBitMask = 0
        platformLeft.scale(to: CGSize(width: platformLeft.size.width * 4, height: platformLeft.size.height * 4))
        platformLeft.zPosition = 20
        platformLeft.name = "platform"
        platformLeft.speed = platformSpeed

        let platformRight = SKSpriteNode(texture: platformTexture)
        platformRight.physicsBody = platformPhysics.copy() as? SKPhysicsBody
        platformRight.physicsBody?.isDynamic = true
        platformRight.physicsBody?.collisionBitMask = 0
        platformRight.scale(to: CGSize(width: platformRight.size.width * 4, height: platformRight.size.height * 4))
        platformRight.zPosition = 20
        platformRight.name = "platform"
        platformRight.speed = platformSpeed
        
        let scoreNode = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width, height: 32))
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.zPosition = 100
        scoreNode.name = "scoreDetect"
        scoreNode.speed = platformSpeed

        let platformTrigger = SKSpriteNode(color: UIColor.orange, size: CGSize(width: frame.width, height: 1))
        platformTrigger.physicsBody = SKPhysicsBody(rectangleOf: platformTrigger.size)
        platformTrigger.physicsBody?.isDynamic = true
        platformTrigger.physicsBody?.affectedByGravity = false
        platformTrigger.physicsBody?.collisionBitMask = 0
        platformTrigger.zPosition = 100
        platformTrigger.name = "platformTrigger"
        platformTrigger.speed = platformSpeed
        
        let newNodes: Set<SKSpriteNode> = [platformLeft, platformRight, scoreNode, platformTrigger]
        for node in newNodes {
            platformGroup.insert(node)
        }
        

        let yPosition = frame.minY + (frame.midY / 2)

        let gapSize: CGFloat = -70


        platformLeft.position = CGPoint(x: xPosition + platformLeft.size.width - gapSize, y: -yPosition)
        platformRight.position = CGPoint(x: xPosition + gapSize, y: -yPosition)
        scoreNode.position = CGPoint(x: frame.midX, y: platformLeft.position.y - platformLeft.size.height / 2)
        platformTrigger.position = CGPoint(x: frame.midX, y: platformLeft.position.y)

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
        
//        print(platformGroup[1].speed)
        platformCount += 1
        
        print()
    }
    
    
    func startPlatforms() {
        
        
        
        let create = SKAction.run { [unowned self] in
            self.createPlatforms()
            platformCount += 1
        }
        
        run(create)
    }
    
    
    func createButtons() {
        buttonLeft = SKSpriteNode()
        buttonLeft.size = CGSize(width: frame.width / 2, height: frame.height)
        buttonLeft.position = CGPoint(x: frame.midX / 2, y: frame.midY)
//        buttonLeft.color = .black
        buttonLeft.alpha = 1
        buttonLeft.name = "buttonLeft"
        buttonLeft.zPosition = 40
        addChild(buttonLeft)
        
        buttonRight = SKSpriteNode()
        buttonRight.size = CGSize(width: frame.width / 2, height: frame.height)
        buttonRight.position = CGPoint(x: frame.midX * 1.5, y: frame.midY)
//        buttonRight.color = .black
        buttonRight.alpha = 1
        buttonRight.name = "buttonRight"
        buttonRight.zPosition = 40
        addChild(buttonRight)
        
        pauseButton = SKSpriteNode(imageNamed: "Pause Button")
        pauseButton.size = CGSize(width: 64, height: 64)
        pauseButton.position = CGPoint(x: frame.maxX - 150, y: frame.maxY - 150)
        pauseButton.zPosition = 50
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
        if let scene = GameScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(with: .black, duration: 2)
            view?.presentScene(scene, transition: transition)
        }
    }
    
    
    func backToTitle(node: SKSpriteNode) {
        if let skView = self.view {
            
            guard let scene = TitleScreen(fileNamed: "TitleScreen") else { return }
            let transition = SKTransition.fade(withDuration: 1.5)
            
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
        pauseMenu.zPosition = 50
        pauseMenu.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        
        homeButton.size = CGSize(width: 128, height: 128)
//        homeButton.texture = nil
        homeButton.zPosition = 55
        homeButton.position = CGPoint(x: pauseMenu.frame.midX + 100, y: pauseMenu.frame.midY)
        homeButton.name = "homeButton"
        
        restartButton.size = CGSize(width: 128, height: 128)
        restartButton.zPosition = 55
//        restartButton.texture = nil
        restartButton.position = CGPoint(x: pauseMenu.frame.midX - 100, y: pauseMenu.frame.midY)
        restartButton.name = "restartButton"
        
        let scalePrelim = SKAction.scale(to: CGSize(width: 1, height: 1), duration: 0)
        let scalePauseMenuUp = SKAction.scale(to: CGSize(width: 512, height: 256), duration: 0.065)
        let scaleMenuButtonsUp = SKAction.scale(to: CGSize(width: 128, height: 128), duration: 0.065)
        
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
//        pauseMenu.color = .black
        gameOverWindow.alpha = 1
        gameOverWindow.zPosition = 60
        gameOverWindow.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        
        homeButton.size = CGSize(width: 128, height: 128)
        homeButton.zPosition = 65
        homeButton.position = CGPoint(x: gameOverWindow.frame.midX + 100, y: gameOverWindow.frame.midY / 1.2)
        homeButton.name = "homeButton"
        
        restartButton.size = CGSize(width: 128, height: 128)
        restartButton.zPosition = 65
        restartButton.position = CGPoint(x: gameOverWindow.frame.midX - 100, y: gameOverWindow.frame.midY / 1.2)
        restartButton.name = "restartButton"
        
        finalScoreLabel = SKLabelNode(fontNamed: "Asai-Analogue")
        finalScoreLabel.text = "Score"
        finalScoreLabel.color = .darkGray
        finalScoreLabel.fontSize = 80
        finalScoreLabel.position = CGPoint(x: gameOverWindow.frame.midX, y: gameOverWindow.frame.maxY * 1.2)
        finalScoreLabel.zPosition = 95
        
        let scalePrelim = SKAction.scale(to: CGSize(width: 1, height: 1), duration: 0)
        let scaleGameOverMenuUp = SKAction.scale(to: CGSize(width: 512, height: 512), duration: 0.065)
        let scaleMenuButtonsUp = SKAction.scale(to: CGSize(width: 128, height: 128), duration: 0.065)
        
        let scaleSeq = SKAction.sequence([scalePrelim, scaleMenuButtonsUp])
        
        let moveScore = SKAction.move(to: CGPoint(x: gameOverWindow.frame.midX, y: gameOverWindow.frame.midY + 50), duration: 1.6)
        let pulseUp = SKAction.scale(to: 2.0, duration: 0.8)
        let pulseDown = SKAction.scale(to: 1, duration: 0.8)
        
        let pulseSeq = SKAction.sequence([pulseUp, pulseDown])
        
        
        if gameState == 1 {
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
    
    
    func shrink(node: SKSpriteNode) {
        let shrink = SKAction.scale(to: 0.75, duration: 0.1)
        let fade = SKAction.run {
            node.colorBlendFactor = 0.35
        }
        let sequence = SKAction.sequence([shrink, fade])
        
        node.run(sequence)
    }
    
    
    func expand(node: SKSpriteNode) {
//        let wait = SKAction.wait(forDuration: 0.11)
        let expand = SKAction.scale(to: 1.1, duration: 0.075)
        let normal = SKAction.scale(to: 1.0, duration: 0.1)
        let defaultColor = SKAction.run {
            node.colorBlendFactor = 0
        }
        let sequence = SKAction.sequence([expand, defaultColor, normal])
        
        node.run(sequence)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("collision")
        
        if contact.bodyA.node?.name == "scoreDetect" || contact.bodyB.node?.name == "scoreDetect" {
            if contact.bodyA.node == plane {
                contact.bodyB.node?.removeFromParent()
            } else {
                contact.bodyA.node?.removeFromParent()
            }

            score += 1

            return
        }
        
        if contact.bodyA.node?.name == "platformTrigger" || contact.bodyB.node?.name == "platformTrigger" {
            if contact.bodyA.node?.name == "spawn" || contact.bodyB.node?.name == "spawn" {
                let create = SKAction.run { [unowned self] in
                    self.createPlatforms()
                    platformCount += 1
                }
                
                run(create)
                
            }
        }

        
        guard contact.bodyA.node != nil && contact.bodyB.node != nil else {
            return
        }
        
        
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
        }
    }
    
    
    func start() {
        scene?.view?.isPaused = false
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        // increasing game speed incremetally as game progresses to increase challenge
//        if score == 25 {
//            physicsWorld.speed = 1.2
//        } else if score == 50 {
//            physicsWorld.speed = 1.4
//        } else if score == 75 {
//            physicsWorld.speed = 1.5
//        }
//
//        if score == 10 {
//            plane.colorBlendFactor = 1
//            plane.color = .orange
//        } else if score == 20 {
//            plane.color = .green
//        }
        
//        print("\(platformGroup.first?.speed)")
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "buttonLeft" {
                changeMode(node: buttonLeft)
            }
            
            if touchedNode.name == "buttonRight" {
                changeMode(node: buttonRight)
            }
            
            if touchedNode.name == "pauseButton" {
                shrink(node: pauseButton)
                isButtonTouched = "pauseButton"
            }
            
            if touchedNode.name == "homeButton" {
                shrink(node: homeButton)
                isButtonTouched = "homeButton"
            }
            
            if touchedNode.name == "restartButton" {
                shrink(node: restartButton)
                isButtonTouched = "restartButton"
            }
        }
    }
        
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            // logically it can be put as only: else if isButtonIsTouched == "\stringName" rather than including touchedNode.name as well
            
            if touchedNode.name == "pauseButton" && isButtonTouched == "pauseButton" {
                pauseGame()
                expand(node: pauseButton)
            } else if touchedNode.name != "" && isButtonTouched == "pauseButton" {
                expand(node: pauseButton)
            }
            
            if touchedNode.name == "homeButton" {
                expand(node: homeButton)
                backToTitle(node: homeButton)
            } else if touchedNode.name != "" && isButtonTouched == "homeButton" {
                expand(node: homeButton)
            }
            
            if touchedNode.name == "restartButton" {
                expand(node: restartButton)
                restartGame(node: restartButton)
            } else if touchedNode.name != "" && isButtonTouched == "restartButton" {
                expand(node: restartButton)
            }
            
            isButtonTouched = ""
        }
    }
}
