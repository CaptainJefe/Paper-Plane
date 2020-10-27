//
//  GameScene.swift
//  PlaneTest
//
//  Created by Cade Williams on 8/21/20.
//  Copyright © 2020 Cade Williams. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let buttonRight = UIButton(type: .system)
    let buttonLeft = UIButton(type: .system)
    
    var backgroundPieces: [SKSpriteNode] = [SKSpriteNode(imageNamed: "Background"), SKSpriteNode(imageNamed: "Background")]
    var backgroundSpeed: CGFloat = 1.0 { didSet { for background in backgroundPieces { background.speed = backgroundSpeed } } }

//    var platformLeft: SKSpriteNode!
//    var platformRight: SKSpriteNode!
//    var scoreNode: SKSpriteNode!
    
    var platformGroup = Set<SKSpriteNode>()
    var platformSpeed: CGFloat = 0.6 { didSet { for platforms in platformGroup { platforms.speed = platformSpeed } } }
    
    
    let platformTexture = SKTexture(imageNamed: "platform")
    var platformPhysics: SKPhysicsBody!
    
    var plane: SKSpriteNode!
    var timer: Timer?
    
    var gameState: Int = 0
    
    var label: SKLabelNode!
    var mode = 8 { didSet { label.text = "Mode: \(mode)" } }
    
    var scoreLabel: SKLabelNode!
    var score = 0 { didSet { scoreLabel.text = "\(score)" } }
    
    
    // Going to use whenever I want to have a transition period; i.e. when count == 20 (when 20 are created) do a certain thing, like straight down movement so platforms are next to each other
    var platformCount = 0
    
    var bgScroll: InfiniteScrollingBackground?
//    let images = [UIImage(named: "Background")!, UIImage(named: "Background")!]
    
    
    override func didMove(to view: SKView) {
        createPlane()
        createLabels()
        createButtons()
        createBackground()
        startPlatforms()
        planeMode()
//        createSky()
        
        platformPhysics = SKPhysicsBody(texture: platformTexture, size: platformTexture.size())
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        

//        bgScroll = InfiniteScrollingBackground(images: images, scene: self, scrollDirection: .top, transitionSpeed: 3)
//        bgScroll?.scroll()
//        bgScroll?.zPosition = 1
    }
    
    @objc func planeMode() {
        
        if mode == 4 {
            plane.isPaused = true
        } else {
            plane.isPaused = false
        }
        
        switch mode {
        case 0:
            plane.texture = SKTexture(imageNamed: "airplane_side_left")
            plane.speed = 7
            let move = SKAction.moveTo(x: -1025, duration: 40)
            let loop = SKAction.repeatForever(move)
            plane.run(loop)
            
            bgScroll?.speed = 1
            backgroundSpeed = 1
            platformSpeed = 0.6

        case 1:
            plane.texture = SKTexture(imageNamed: "airplane_side_left2")
            plane.speed = 5
            let move = SKAction.moveTo(x: -1025, duration: 40)
            let loop = SKAction.repeatForever(move)
            plane.run(loop)
            
            bgScroll?.speed = 2
            backgroundSpeed = 1.3
            platformSpeed = 0.9
           
        case 2:
            plane.texture = SKTexture(imageNamed: "airplane_side_left3")
            plane.speed = 3
            let move = SKAction.moveTo(x: -1025, duration: 40)
            let loop = SKAction.repeatForever(move)
            plane.run(loop)
            
            bgScroll?.speed = 3
            backgroundSpeed = 1.6
            platformSpeed = 1.3
            
        case 3:
            plane.texture = SKTexture(imageNamed: "airplane_side_left4")
            plane.speed = 1
            let move = SKAction.moveTo(x: -1025, duration: 40)
            let loop = SKAction.repeatForever(move)
            plane.run(loop)
            
            bgScroll?.speed = 3.5
            backgroundSpeed = 1.9
            platformSpeed = 1.6
            
        case 4:
            plane.texture = SKTexture(imageNamed: "airplane_down")
//            let move = SKAction.moveBy(x: 0, y: 0, duration: 40)
//            let loop = SKAction.repeatForever(move)
//            plane.run(loop)
            
            bgScroll?.speed = 5.5
            backgroundSpeed = 2.3
            platformSpeed = 1.9
            
        case 5:
            plane.texture = SKTexture(imageNamed: "airplane_side_right4")
            plane.speed = 4
            let move = SKAction.moveTo(x: 1400, duration: 40)
            let loop = SKAction.repeatForever(move)
            plane.run(loop)

            bgScroll?.speed = 3.5
            backgroundSpeed = 1.9
            platformSpeed = 1.6
            
        case 6:
            plane.texture = SKTexture(imageNamed: "airplane_side_right3")
            plane.speed = 5
            let move = SKAction.moveTo(x: 1400, duration: 40)
            let loop = SKAction.repeatForever(move)
            plane.run(loop)
            
            bgScroll?.speed = 3
            backgroundSpeed = 1.6
            platformSpeed = 1.3
            
        case 7:
            plane.texture = SKTexture(imageNamed: "airplane_side_right2")
            plane.speed = 6
            let move = SKAction.moveTo(x: 1400, duration: 40)
            let loop = SKAction.repeatForever(move)
            plane.run(loop)
            
            bgScroll?.speed = 2
            backgroundSpeed = 1.3
            platformSpeed = 0.9
            
        case 8:
            plane.texture = SKTexture(imageNamed: "airplane_side_right")
            plane.speed = 8
            let move = SKAction.moveTo(x: 1400, duration: 40)
            let loop = SKAction.repeatForever(move)
            plane.run(loop)
            
            bgScroll?.speed = 1
            backgroundSpeed = 1
            platformSpeed = 0.6
            
        default:
            break
        }
    }
    
    func createPlane() {
        let planeTexture = SKTexture(imageNamed: "airplane_side_right")
        plane = SKSpriteNode(imageNamed: "planeTexture")
        plane.position = CGPoint(x: 180, y: 1000)
        plane.zPosition = 5
        plane.alpha = 1
//        plane.colorBlendFactor = 1
//        plane.color = plane.color
        plane.size = CGSize(width: 100, height: 100)
        addChild(plane)
        
        plane.physicsBody = SKPhysicsBody(texture: planeTexture, size: planeTexture.size())
        plane.physicsBody!.contactTestBitMask = plane.physicsBody!.collisionBitMask
        plane.physicsBody?.collisionBitMask = 0
        plane.physicsBody?.isDynamic = true
    }
    
    func createLabels() {
        scoreLabel = SKLabelNode(fontNamed: "")
        scoreLabel.text = "\(score)"
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 150)
        scoreLabel.fontSize = 100
        scoreLabel.zPosition = 50
        addChild(scoreLabel)
        
        label = SKLabelNode(fontNamed: "")
        label.text = "Mode: \(mode)"
        label.position = CGPoint(x: 660, y: 1280)
        label.horizontalAlignmentMode = .right
        label.zPosition = 50
        addChild(label)
    }
    
    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "Background")
            
        for i in 0 ... 1 {
            
            let background = backgroundPieces[i]
            background.texture = backgroundTexture
            background.anchorPoint = CGPoint(x: 0, y: 0)
            background.zPosition = -5
            background.position = CGPoint(x: 0, y: backgroundTexture.size().height + (-backgroundTexture.size().height) + (-backgroundTexture.size().height * CGFloat(i)))
            
            self.addChild(background)
            
            let scrollUp = SKAction.moveBy(x: 0, y: backgroundTexture.size().height, duration: 5)
            let scrollReset = SKAction.moveBy(x: 0, y: -backgroundTexture.size().height, duration: 0)
            let scrollLoop = SKAction.sequence([scrollUp, scrollReset])
            let scrollForever = SKAction.repeatForever(scrollLoop)
            
            background.run(scrollForever)
        }
    }
    
    func createPlatforms() {
        
        let platformLeft = SKSpriteNode(texture: platformTexture)
        platformLeft.physicsBody = platformPhysics.copy() as? SKPhysicsBody
        platformLeft.physicsBody?.isDynamic = false
        platformLeft.scale(to: CGSize(width: platformLeft.size.width * 4, height: platformLeft.size.height * 4))
        platformLeft.zPosition = 20
        platformLeft.name = "left"
        platformLeft.speed = platformSpeed
        

        let platformRight = SKSpriteNode(texture: platformTexture)
        platformRight.physicsBody = platformPhysics.copy() as? SKPhysicsBody
        platformRight.physicsBody?.isDynamic = false
        platformRight.scale(to: CGSize(width: platformRight.size.width * 4, height: platformRight.size.height * 4))
        platformRight.zPosition = 20
        platformRight.name = "right"
        platformRight.speed = platformSpeed
        
        let scoreNode = SKSpriteNode(color: UIColor.clear, size: CGSize(width: frame.width, height: 32))
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.name = "scoreDetect"
        scoreNode.zPosition = 40
        scoreNode.speed = platformSpeed

        
        let newNodes: Set<SKSpriteNode> = [platformLeft, platformRight, scoreNode]
        for node in newNodes {
            platformGroup.insert(node)
        }
        

        let yPosition = frame.width - platformRight.frame.width

        let max = CGFloat(frame.width / 4)
        let xPosition = CGFloat.random(in: -80...max)

        let gapSize: CGFloat = -50


        platformLeft.position = CGPoint(x: xPosition + platformLeft.size.width - gapSize, y: -yPosition)
        platformRight.position = CGPoint(x: xPosition + gapSize, y: -yPosition)
        scoreNode.position = CGPoint(x: frame.midX, y: yPosition - (scoreNode.size.width / 1.5))

        let endPosition = frame.maxY + (platformLeft.frame.height * 3)

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
        
        let wait = SKAction.wait(forDuration: 0.9)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        
        run(repeatForever)
        
        
    }
    
    func createButtons() {
        buttonLeft.frame = CGRect(x: 0, y: 0, width: 210, height: 900)
//        buttonLeft.backgroundColor = .gray
        buttonLeft.alpha = 0.55
        buttonLeft.setTitle("Left", for: .normal)
        buttonLeft.addTarget(self, action: #selector(changeMode), for: .touchUpInside)
        buttonLeft.tag = 0
        view?.addSubview(buttonLeft)
        
        buttonRight.frame = CGRect(x: 210, y: 0, width: 210, height: 900)
//        buttonRight.backgroundColor = .darkGray
        buttonRight.alpha = 0.55
        buttonRight.setTitle("Right", for: .normal)
        buttonRight.addTarget(self, action: #selector(changeMode), for: .touchUpInside)
        buttonRight.tag = 1
        view?.addSubview(buttonRight)
    }
    
    @objc func changeMode(_ sender: UIButton!) {
        if sender.tag == 0 {
            mode -= 1
        } else if sender.tag == 1 {
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
            restartGame(sender)
        }
    }
    
    func restartGame(_ sender: UIButton!) {
        if let scene = GameScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(with: .black, duration: 2)
            view?.presentScene(scene, transition: transition)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "scoreDetect" || contact.bodyB.node?.name == "scoreDetect" {
            if contact.bodyA.node == plane {
                contact.bodyB.node?.removeFromParent()
            } else {
                contact.bodyA.node?.removeFromParent()
            }

            score += 1

            return
        }

        guard contact.bodyA.node != nil && contact.bodyB.node != nil else {
            return
        }

//        if contact.bodyA.node == plane || contact.bodyB.node == plane {
//            if let particles = SKEmitterNode(fileNamed: "DestroyPlane") {
//                particles.position = plane.position
//                particles.zPosition = 50
//                addChild(particles)
//            }
//
//            plane.removeFromParent()
//            speed = 0
//            gameState = 1
//        }
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
    }
}
