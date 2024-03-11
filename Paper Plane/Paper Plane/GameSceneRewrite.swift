//
//  GameScene.swift
//  PlaneTest
//
//  Created by Cade Williams on 8/21/20.
//  Copyright Â© 2020 Cade Williams. All rights reserved.
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

class GameSceneRewrite: SKScene, SKPhysicsContactDelegate {
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   INITIALIZERS
    // ------------------------------------------------------------------------------------------------------------------------------------------
    
    var currentStage: Int = 1
    var currentBG: Int = 1
    var updateInitializer: Bool = false
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   BUTTONS, UI, MENUS
    // ------------------------------------------------------------------------------------------------------------------------------------------
    
    var howToPlay: SKSpriteNode!
    var gotIt: SKSpriteNode!
    
    var buttonRight: SKSpriteNode!
    var buttonLeft: SKSpriteNode!
    var leftControl: SKSpriteNode!
    var rightControl: SKSpriteNode!
    var pauseButton: SKSpriteNode!
    
    var gameOverWindow: SKSpriteNode!
    var homeButton = SKSpriteNode(imageNamed: "home_button_2")
    var restartButton = SKSpriteNode(imageNamed: "restart_button")
    var levelSelectButton = SKSpriteNode(imageNamed: "level_select_button")
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   SKY AND CLOUDS
    // ------------------------------------------------------------------------------------------------------------------------------------------
    
    var cloudPieces: [SKSpriteNode] = [SKSpriteNode(), SKSpriteNode()]
    var cloudsTexture: SKTexture! { didSet { for clouds in cloudPieces { clouds.texture = cloudsTexture } } }
    
    var sky: SKSpriteNode!
    var skyTexture: SKTexture!
    var castleSky: SKTexture!
    var desertSky: SKTexture!
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   BACKGROUND
    // ------------------------------------------------------------------------------------------------------------------------------------------
    
    var backgroundArray = [SKSpriteNode]()
    var lastBackgroundPosition: CGFloat!
    
    var backgroundTexture: SKTexture! { didSet { for background in backgroundArray { background.texture = backgroundTexture } } }
    var firstBackground: SKTexture!
    var secondBackground: SKTexture!
    var thirdBackground: SKTexture!
    
    var plane: SKSpriteNode!
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   PLATFORMS
    // ------------------------------------------------------------------------------------------------------------------------------------------
    
    var lastPlatformPosition: CGFloat = 662.0 // Needs to start at y-pos 422, so I made it 662 because of how yPosition is calculated. May be changed.
    var distanceBetweenPlatforms: CGFloat = 240.0
    
    var platformGroup = Set<SKSpriteNode>()
    var platformPhysics: SKPhysicsBody!
    var platformGap: CGFloat!
    var platformCount = 0 { didSet { platformGap = frame.midY - (((transitionPlatform.size().height * 3) * CGFloat(min(platformCount, 2)))) } }
    var platformDelta: CGFloat = 0.0
    var platformArray = [SKSpriteNode]() {
        didSet {
            if platformArray.count > 1 {
                platformDelta = platformArray[0].position.y - platformArray[1].position.y
            }
        }
    }
    
    var platformTexture: SKTexture!
    var firstPlatform: SKTexture! { didSet { firstPlatformSize = firstPlatform.size() } }
    var secondPlatform: SKTexture!
    var thirdPlatform: SKTexture!
    var transitionPlatform = SKTexture(imageNamed: "transition_platform")
    var firstPlatformSize: CGSize!
    
    var initialPlatforms = true
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   LABELS & TOGGLES
    // ------------------------------------------------------------------------------------------------------------------------------------------
    
    var timer: Timer?
    var gameState: Int = 0
    
    var label: SKLabelNode!
    var mode = 8 { didSet { label.text = "Mode: \(mode)" } }
    
    var scoreLabel: SKLabelNode!
    var score = 0 { didSet { scoreLabel.text = "\(score)" } }
    var finalScoreLabel: SKLabelNode!
    var bestScore: SKLabelNode!
    
    var gameIsPaused = false
    
    var isButtonTouched: String!
    var isLeftButtonPressed: Bool!
    var isRightButtonPressed: Bool!
    
    var toggleNoClip: SKSpriteNode!
    var noClipLabel: SKLabelNode!
    var noClip = false { didSet { noClipLabel.text = "Collision: \(!noClip)" } }
    
    var planeCoords: SKLabelNode!
    
    var lpLabel: SKLabelNode!
    
    var increaseWorldSpeed: Int = 0
    
    var gameHasStarted: Bool = false
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   MISC NODES & CONTAINERS
    // ------------------------------------------------------------------------------------------------------------------------------------------
    
    var nodeArray = [SKNode]()
    
    var UINode: SKNode!
    
    var gameOverUIContainer = [SKNode]()

    var countdownLabel: SKLabelNode!
    var count = 3 { didSet { countdownLabel.text = "\(count)" } }
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   MISC VARIABLES & CONSTANTS
    // ------------------------------------------------------------------------------------------------------------------------------------------
    
    var shouldDetectScore: Bool = true
    
    var isPlaneDestroyed: Bool = false
    
    var lastRandom: CGFloat = 0.0

    var positionAtScore: CGFloat!

    var minGapSize: CGFloat!

    let playerCamera = SKCameraNode()

    var visualPlatformTrigger: SKSpriteNode!
    
    let planeCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let platformCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    
    var screenBoundsNode: SKSpriteNode! { didSet { screenBoundsNode.position.y = frame.midY } }
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   FUNCTIONS
    // ------------------------------------------------------------------------------------------------------------------------------------------

    
    override func didMove(to view: SKView) {
        
        print("frame middle: \(CGPoint(x: -frame.midX, y: frame.midY))")
        
        visualPlatformTrigger = SKSpriteNode()
        visualPlatformTrigger.color = .clear
        visualPlatformTrigger.alpha = 0.5
        addChild(visualPlatformTrigger)

        print("transitionPlat height\(transitionPlatform.size().height)")
        
        UINode = SKNode()
        addChild(UINode)

        let midXNode = SKSpriteNode(color: .clear, size: CGSize(width: 5, height: 2500))
        midXNode.position = CGPoint(x: frame.midX, y: frame.midY)
        midXNode.zPosition = 900
        addChild(midXNode)

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
        print ("platformGap \(platformGap)") // 422.0 initially

//        lastPlatformPosition = frame.midY - (((transitionPlatform.size().height * 3) * CGFloat(min(platformCount,2))))
        
        lastBackgroundPosition = view.center.y * 3.5 // 1477.0 -- need to figure maybe a better offset to initalize background spawn position

        // INITIAL FUNCTIONS
        
        initiateTextures()
        createPlane()
        createLabels()
        createButtons()
        createBackground()
        createBackground()
        createSky()
//        createPlatforms()
//        createPlatforms()
//        createPlatforms()
        createPlatforms()
        createPlatforms()
        createPlatforms()
        planeMode()
        preGame()
//        musicPlayer()

        camera = playerCamera
        playerCamera.position.x = frame.midX
        scene?.addChild(playerCamera)
        
        let zoomOutCamera = SKAction.scale(to: 3, duration: 1)
//        playerCamera.run(zoomOutCamera)

        let barrier = SKSpriteNode()
        barrier.position = CGPoint(x: frame.midX, y: frame.midY)
        barrier.size = CGSize(width: frame.size.width, height: frame.size.height)
        barrier.zPosition = 750
        barrier.color = .clear
        barrier.name = "barrier"
//        addChild(barrier)

        toggleNoClip = SKSpriteNode(imageNamed: "no_clip")
        toggleNoClip.size = CGSize(width: 48, height: 48)
        toggleNoClip.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 50)
        toggleNoClip.color = .black
        toggleNoClip.alpha = 1
        toggleNoClip.zPosition = 400
        toggleNoClip.name = "noClip"
//        UINode.addChild(toggleNoClip)

        noClipLabel = SKLabelNode(fontNamed: "Paper Plane Font")
        noClipLabel.position = CGPoint(x: frame.midX, y: frame.minY + 50)
        noClipLabel.fontSize = 30
        noClipLabel.text = "Collision: \(!noClip)"
//        UINode.addChild(noClipLabel)

        planeCoords = SKLabelNode(fontNamed: "Paper Plane Font")
        planeCoords.position = CGPoint(x: frame.midX, y: frame.minY + 100)
        planeCoords.text = "\((Int)(plane.position.y))"
        planeCoords.fontSize = 22
        planeCoords.zPosition = 1000
//        UINode.addChild(planeCoords)


        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        // ScreenBoundsNode does the same thing as self.phyicsBody = ...
        
        screenBoundsNode = SKSpriteNode()
        screenBoundsNode.position = CGPoint(x: frame.minX, y: frame.minY)
        screenBoundsNode.color = .blue
        screenBoundsNode.alpha = 0.55
        screenBoundsNode.zPosition = 555
        screenBoundsNode.physicsBody = SKPhysicsBody(edgeLoopFrom: view.frame)
//        addChild(screenBoundsNode)

//        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

        // lets every node initialize before attempting to pause them
        let wait = SKAction.wait(forDuration: 0.001)
        let runAction = SKAction.run { [unowned self] in
            for node in self.nodeArray {
                node.isPaused = true
            }
        }
        let seq = SKAction.sequence([wait, runAction])

        run(seq)
    }
    

    func getSpriteDetails(node: SKSpriteNode) {
        var nodeFrame: CGRect = node.calculateAccumulatedFrame()

        let minX = nodeFrame.minX
        let maxX = nodeFrame.maxX
        let midX = nodeFrame.size.width/2
        let name = node.name

        print("Object Name: \(name)\n Left Min: \(minX)\n MidPoint of Width: \(midX)\n Right Max: \(maxX)\n Node Width: \(nodeFrame.size.width)")

    }
    

    func preGame() {

        for node in platformGroup {
            if node.name == "platformLeft" || node.name == "platformRight" {
                node.color = .darkGray
                node.colorBlendFactor = 0.65
            }
        }
        
        for node in backgroundArray {
            node.color = .darkGray
            node.colorBlendFactor = 0.65
        }

        for node in cloudPieces {
            node.color = .darkGray
            node.colorBlendFactor = 0.65
        }

        if firstTimePlaying == true {
            howToPlay = SKSpriteNode(imageNamed: "how_to0")
            howToPlay.size = CGSize(width: howToPlay.size.width * 0.65, height: howToPlay.size.height * 0.65)
            howToPlay.position = CGPoint(x: frame.midX, y: frame.midY)
            howToPlay.zPosition = 800
            howToPlay.name = "howToPlay"
            addChild(howToPlay)

            gotIt = SKSpriteNode(imageNamed: "got_it")
            gotIt.size = CGSize(width: gotIt.size.width, height: gotIt.size.height)
            gotIt.position = CGPoint(x: howToPlay.frame.midX, y: frame.maxY * 0.33)
            gotIt.zPosition = 810
            gotIt.name = "gotIt"
            addChild(gotIt)

            Animations.shared.animateIntructions(node: howToPlay)

        } else {
            countdown()
        }

        //        let startLabel = SKLabelNode(fontNamed: "Paper Plane Font")
        //        startLabel.position = CGPoint(x: frame.midX, y: frame.maxY * 0.65)
        //        startLabel.fontSize = 50
        //        startLabel.text = "Tap to start"
        //        startLabel.color = .black
        //        startLabel.alpha = 0
        //        startLabel.zPosition = 70
        //        startLabel.name = "startLabel"
        //        addChild(startLabel)
        //
        //        let fadeAlphaTo = SKAction.fadeAlpha(to: 0.5, duration: 1)
        //        let fadeIn = SKAction.fadeIn(withDuration: 1.5)
        //        let wait = SKAction.wait(forDuration: 1.2)
        //        let fadeOut = SKAction.fadeOut(withDuration: 1.5)
        //        let fadeInFadeOut = SKAction.sequence([fadeIn, wait, fadeOut])
        //        let repeatForever = SKAction.repeatForever(fadeInFadeOut)
        //
        //        startLabel.run(repeatForever)
    }
    

    func countdown() {

        countdownLabel = SKLabelNode(fontNamed: "Paper Plane Font")
        countdownLabel.position = CGPoint(x: frame.midX, y: frame.maxY * 0.75)
        countdownLabel.zPosition = 300
        countdownLabel.fontSize = 100
        countdownLabel.text = "\(count)"
        addChild(countdownLabel)

        let decreaseCounter = SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.run { [unowned self] in
            self.count -= 1
        }])

        let endCountdown = SKAction.run { [unowned self] in
            self.countdownLabel.removeFromParent()
            childNode(withName: "barrier")?.removeFromParent()

            for node in platformGroup {
                if node.name == "platformLeft" || node.name == "platformRight" {
                    node.colorBlendFactor = 0
                }
            }
            
            for node in backgroundArray {
                node.colorBlendFactor = 0
            }

            for node in cloudPieces {
                node.colorBlendFactor = 0
            }

            self.start()
        }

        run(SKAction.sequence([SKAction.repeat(decreaseCounter, count: 3), endCountdown]))
    }
    
    
    func start() {

        for node in self.children as [SKNode] {
            node.isPaused = false
        }
        
        gameHasStarted = true
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
        
        switch theme {
        case "castle":
            firstBackground = SKTexture(imageNamed: "castle_background_1")
            secondBackground = SKTexture(imageNamed: "castle_background_2")
            thirdBackground = SKTexture(imageNamed: "castle_background_3")

            firstPlatform = SKTexture(imageNamed: "platform_1")
            secondPlatform = SKTexture(imageNamed: "platform_2")
            thirdPlatform = SKTexture(imageNamed: "platform_3")
            transitionPlatform = SKTexture(imageNamed: "transition_platform")

            skyTexture = SKTexture(imageNamed: "sky_background_day")
            cloudsTexture = SKTexture(imageNamed: "clouds_day")

        case "chasm":
            firstBackground = SKTexture(imageNamed: "chasm_background_1")
            secondBackground = SKTexture(imageNamed: "chasm_background_2")
            thirdBackground = SKTexture(imageNamed: "chasm_background_3")

            firstPlatform = SKTexture(imageNamed: "platform_1")
            secondPlatform = SKTexture(imageNamed: "platform_2")
            thirdPlatform = SKTexture(imageNamed: "platform_3")
            transitionPlatform = SKTexture(imageNamed: "transition_platform")

            skyTexture = SKTexture(imageNamed: "sky_background_night")

        case "silo":
            firstBackground = SKTexture(imageNamed: "silo_background_1")
            secondBackground = SKTexture(imageNamed: "silo_background_2")
            thirdBackground = SKTexture(imageNamed: "silo_background_3")

            firstPlatform = SKTexture(imageNamed: "platform_1")
            secondPlatform = SKTexture(imageNamed: "platform_2")
            thirdPlatform = SKTexture(imageNamed: "platform_3")
            transitionPlatform = SKTexture(imageNamed: "transition_platform")

            skyTexture = SKTexture(imageNamed: "sky_background_night")
            cloudsTexture = SKTexture(imageNamed: "clouds_night")

        default:
            break
        }

        setBackground()
        setPlatforms()
    }
    

    func setPlatforms() {
        
        switch currentStage {
        case 1:
            platformTexture = firstPlatform
        case 2:
            platformTexture = secondPlatform
        case 3...:
            platformTexture = thirdPlatform
        case ..<0:
            platformTexture = transitionPlatform
        default:
            break
        }
    }
    

    func setBackground() {
        
        switch currentBG { // previously currentStage
        case 1:
            backgroundTexture = firstBackground
        case 2:
            backgroundTexture = secondBackground
            //            animateBackground(texture: secondBackground)
        case 3...:
            backgroundTexture = thirdBackground
        default:
            break
        }
        
        currentBG += 1
    }


    func musicPlayer() {
        Audio.shared.musicPlayer(node: self.scene!)
    }


    @objc func planeMode() {
        
        // Thought to be considered: Instead of modifying scene.speed in createPlatforms, create a variable instead that modifies modX/modY with a multiplier to prevent controls from feeling too fast. Faster controls may be better though considering the higher speeds.
        
        var modX: CGFloat!
        var modY: CGFloat!
    
        switch mode {
        case 0:
            plane.texture = SKTexture(imageNamed: "Plane 1")
            modX = -320
            modY = 40

        case 1:
            plane.texture = SKTexture(imageNamed: "Plane 2")
            modX = -260
            modY = 100

        case 2:
            plane.texture = SKTexture(imageNamed: "Plane 3")
            modX = -160
            modY = 160

        case 3:
            plane.texture = SKTexture(imageNamed: "Plane 4")
            modX = -80
            modY = 280

        case 4:
            plane.texture = SKTexture(imageNamed: "Plane 5")
            modX = 0
            modY = 360

        case 5:
            plane.texture = SKTexture(imageNamed: "Plane 6")
            modX = 80
            modY = 280

        case 6:
            plane.texture = SKTexture(imageNamed: "Plane 7")
            modX = 160
            modY = 160

        case 7:
            plane.texture = SKTexture(imageNamed: "Plane 8")
            modX = 260
            modY = 100

        case 8:
            plane.texture = SKTexture(imageNamed: "Plane 9")
            modX = 320
            modY = 40

        default:
            break
        }
        
        plane.removeAllActions()
        
        let moveByXY = SKAction.moveBy(x: modX, y: -modY, duration: 1.25) // would like duration to be 1, but 1.25 feels pretty good in terms of movement speed
        let repeatMove = SKAction.repeatForever(moveByXY)
        
        plane.run(repeatMove)
        
        plane.physicsBody = SKPhysicsBody(texture: plane.texture!, size: plane.size) // changed the hitbox, but collision detections are lost
    }
    
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   NODE AND OBJECT CREATION
    // ------------------------------------------------------------------------------------------------------------------------------------------


    func createPlane() {
        
        let planeTexture = SKTexture(imageNamed: "Plane 9")
        plane = SKSpriteNode(texture: planeTexture)
        plane.position = CGPoint(x: frame.midX / 2, y: frame.maxY - frame.maxY / 4)
        plane.zPosition = 5
        plane.alpha = 1
        plane.size = CGSize(width: 96 * 0.875, height: 96 * 0.875)
        plane.name = "plane"
        addChild(plane)
        nodeArray.append(plane)

//        plane.physicsBody = SKPhysicsBody(circleOfRadius: plane.size.width / 7)
        plane.physicsBody = SKPhysicsBody(texture: planeTexture, size: plane.size)
        plane.physicsBody!.contactTestBitMask = plane.physicsBody!.collisionBitMask
        plane.physicsBody?.categoryBitMask = planeCategory
        plane.physicsBody?.collisionBitMask = 0
//        plane.physicsBody!.contactTestBitMask = scoreCategory
        
//        plane.physicsBody?.contactTestBitMask = worldCategory | platformCategory
//        plane.physicsBody?.collisionBitMask = worldCategory | platformCategory
        plane.physicsBody?.isDynamic = true
    }


    func createLabels() {
        
        scoreLabel = SKLabelNode(fontNamed: "Paper Plane Font") // Asai-Analogue
        scoreLabel.text = "\(score)"
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY * 0.93)
        scoreLabel.fontSize = 60
        scoreLabel.zPosition = 220
        UINode.addChild(scoreLabel)

        label = SKLabelNode(fontNamed: "Paper Plane Font")
        label.text = "Mode: \(mode)"
        label.position = CGPoint(x: 660, y: 1280)
        label.horizontalAlignmentMode = .right
        label.zPosition = 50
        UINode.addChild(label)
        //        addChild(label)
    }


    func createBackground() {

        let background = SKSpriteNode()
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -5
        background.size = CGSize(width: frame.size.width, height: frame.size.width * 2.5)
        backgroundArray.append(background)
        
        // Doesn't get called at the same time as setBackground in createPlatforms when target score is reached
        
        for background in backgroundArray {
            background.texture = backgroundTexture
        }
        
        var yPositionBG = lastBackgroundPosition - background.size.height
        
        background.position = CGPoint(x: view!.center.x, y: yPositionBG)
        
        print("view.center.y \(view!.center.y)")

        addChild(background)
        nodeArray.append(background)
        
        // It works! Only issue is that the background moves by a constant y-amount no matter how fast the plane is moving downward. Might be worth looking into a solution to dynamically change the moveBy-y value in order to match plane speed.
        
        let moveBackground = SKAction.moveBy(x: 0, y: -10, duration: 1)
        let repeatMove = SKAction.repeatForever(moveBackground)
        background.run(repeatMove)
    }
                                      

    func createSky() {
        
        sky = SKSpriteNode()
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
            clouds.name = "clouds"

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
    
    
    func createPlatforms() {
        
        var yPosition = lastPlatformPosition - distanceBetweenPlatforms // distanceBetweenPlatforms may need to be size relative like transitionPlatform.size.height
        
        let minGapSize: CGFloat = -frame.size.width / 6 // replaced by horizontalPlatformGap???
        let newNodes: Set<SKSpriteNode>
        
        var randMin: Int = 1
        var randMax: Int = 18
        
        var platformRandomizer = CGFloat(Int.random(in: randMin ... randMax))
        
        if 1...6 ~= lastRandom { // Last Platform Set Was Left Only
            randMin = 7
        }
        else if 13...18 ~= lastRandom { // Last Platform Set Was Right Only
            randMax = 12
        }
        
        var transitionCheck = false
        
        if platformCount == 30 {
            yPosition = lastPlatformPosition - (distanceBetweenPlatforms * 1.5) // creates a consistent gap before first platform of stage and transition chute
            currentStage = -currentStage
            currentStage += 1
            setPlatforms()
            platformCount = 0
            
        } else if platformCount >= 19 {
            if platformCount == 19 {
                yPosition = lastPlatformPosition - (distanceBetweenPlatforms * 1.5) // creates a consistent gap before final platform of stage and transition chute
                currentStage = -currentStage
                setPlatforms()
            }
            
            transitionCheck = true
            platformRandomizer = 11
        }

        if score == 30 || score == 60 {
            setBackground()
        }
        
        if transitionCheck == true {
            randMin = 7
            randMax = 7
        }
        
        let platformLeft = SKSpriteNode(texture: platformTexture)
        platformLeft.setScale(3.0)
//        platformLeft.physicsBody = SKPhysicsBody(rectangleOf: platformLeft.size)
        platformLeft.physicsBody = SKPhysicsBody(texture: platformTexture, size: platformLeft.size)
        platformLeft.physicsBody?.isDynamic = false
        platformLeft.physicsBody?.affectedByGravity = false
        platformLeft.physicsBody?.collisionBitMask = 0
//        platformLeft.physicsBody?.categoryBitMask = platformCategory
        platformLeft.physicsBody?.contactTestBitMask = planeCategory // doesn't seem to matter which value this is set to, but for when using pixel perfect, updating plane hitboxes, it needs to be enabled else plane runs into without being destroyed
        platformLeft.zPosition = 20
        platformLeft.name = "platformLeft"
        platformArray.append(platformLeft)
        
        let platformRight = SKSpriteNode(texture: platformTexture)
        platformRight.setScale(3.0)
//        platformRight.physicsBody = SKPhysicsBody(rectangleOf: platformRight.size)
        platformRight.physicsBody = SKPhysicsBody(texture: platformTexture, size: platformRight.size)
        platformRight.physicsBody?.isDynamic = false
        platformRight.physicsBody?.affectedByGravity = false
        platformRight.physicsBody?.collisionBitMask = 0
        //        platformRight.physicsBody?.categoryBitMask = platformCategory
        platformRight.physicsBody?.contactTestBitMask = planeCategory
        platformRight.zPosition = 20
        platformRight.name = "platformRight"
        
        let scoreNode = SKSpriteNode(color: UIColor.clear, size: CGSize(width: frame.width, height: firstPlatform.size().height / 4))
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = scoreCategory
        scoreNode.physicsBody?.contactTestBitMask = planeCategory
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.zPosition = 100
        scoreNode.name = "scoreDetect"
        
        
        let horizontalPlatformGap = platformLeft.size.width / 4
        let width = frame.size.width / 6
        var xPosRandomizer = CGFloat.random(in: -(frame.midX * 0.75) ... (frame.midX * 0.75 - horizontalPlatformGap)) // Offsetting the maximum by the platformGap seems to match values for minimum jut for either platform on either side.
    
        
        // ---------------------------------------
        //   FORCED CONDITIONS AND RANDOMIZATION
        // ---------------------------------------
        
        
        if platformCount == 0 && platformArray.count <= 1 {
            platformRandomizer = 1 // forces a single left platform on the initial spawn
        } else if platformCount == 0 {
            xPosRandomizer = CGFloat.random(in: -(frame.midX * 0.65) ... (frame.midX * 0.65 - horizontalPlatformGap))
        } else if platformCount >= 19 {
            platformRandomizer = 13
        }

//        platformRandomizer = 1
        
        switch platformRandomizer {
            
        case 1...6: // A Single Left Platform Spawns
            
            newNodes = [platformLeft, scoreNode]
            
            xPosRandomizer = CGFloat.random(in: (frame.midX * 0.75) ... (frame.midX * 0.75))
            
            if platformCount == 0 && platformArray.count <= 1 {
                xPosRandomizer = frame.midX * 0.70 - horizontalPlatformGap
            } else if platformCount == 0 || platformCount == 19 {
                xPosRandomizer = CGFloat.random(in: -(frame.midX * 0.75 - horizontalPlatformGap) ... (frame.minX))
            } else {
                xPosRandomizer = CGFloat.random(in: frame.minX ... (frame.midX * 0.65))
            }
            
            print("Spawned One Left Platform")

        case 7...12: // A Single Right Platform Spawns
            
            newNodes = [platformRight, scoreNode]
            
            if platformCount == 0 || platformCount == 19 {
                xPosRandomizer = CGFloat.random(in: -(frame.midX * 0.75) ... -(frame.midX * 0.5 - horizontalPlatformGap))
            } else {
                xPosRandomizer = CGFloat.random(in: -(frame.midX * 0.65 + horizontalPlatformGap) ... (frame.minX - horizontalPlatformGap))
            }
            
            print("Spawn One Right Platform")

        default: // 13...18 | Both Platforms Spawn
            
            newNodes = [platformLeft, platformRight, scoreNode]
            
            if platformCount == 0 || platformCount == 19 {
                xPosRandomizer = CGFloat.random(in: -(frame.midX * 0.65) ... (frame.midX * 0.65 - horizontalPlatformGap))
            } else {
                xPosRandomizer = CGFloat.random(in: -(frame.midX * 0.75) ... (frame.midX * 0.75 - horizontalPlatformGap))
            }
            
            print("Spawned Both Left and Right Platform")
        }
        
        print("currentStage post: \(currentStage)")
        
        for node in newNodes {
            platformGroup.insert(node)
        }
        
        print("transitionCheck: \(transitionCheck)")
        
        getSpriteDetails(node: platformLeft)
        getSpriteDetails(node: platformRight)
        
        platformLeft.position = CGPoint(x: xPosRandomizer, y: yPosition)
        platformRight.position = CGPoint(x: xPosRandomizer + platformLeft.size.width + horizontalPlatformGap, y: yPosition)
        
       if transitionCheck == true {
        
            platformLeft.position = CGPoint(x: frame.width * 0.125 + platformLeft.size.width - minGapSize, y: yPosition)
            platformRight.position = CGPoint(x: frame.width * 0.125 + minGapSize, y: yPosition)
        }
        
        scoreNode.position = CGPoint(x: frame.midX, y: platformLeft.position.y)
        
        let endPosition = lastPlatformPosition + 1000 // by the time the block of code gets executed, it's likely not actively reading the positional change of the node to remove it. Probably needs an SKAction to run until the condition to remove the node is met because the block below doesn't seem to be running (because conditions are being met in time).

        for node in newNodes {

            addChild(node)
            nodeArray.append(node)
            lastPlatformPosition = node.position.y // stores the spawned position of most recently created platform(s). Used to reference this position to form static distance between the most recent platform(s) and the next platform(s) that will be spawned next.


        let nodeSeq = SKAction.sequence([

            SKAction.removeFromParent(),
            SKAction.run {
                print("node removed")
            },
            SKAction.run {
                self.platformGroup.remove(node)
            }
        ])

            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [self] timer in

                if node.position.y > plane.position.y + (transitionPlatform.size().height * 6) { // number chosen it based on when plane reaches so many further platforms down
                    timer.invalidate()
                    node.run(nodeSeq)
                    print("timer ran!")
                }
            }
        }

        
        platformCount += 1

        print("added platform: \(platformCount)")

        lastRandom = platformRandomizer

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
    }


//    func createPlatforms() {
//
//        let yPosition = lastPlatformPosition - distanceBetweenPlatforms // distanceBetweenPlatforms may need to be size relative like transitionPlatform.size.height
//
//        // Need to gut this and remove references to moving platforms because they will now need to be locked to a specific coordinate
//
//        minGapSize = frame.width / 6
//        let newNodes: Set<SKSpriteNode>
//        var xPosition = min((CGFloat(Int.random(in: 2 ... 12)) / 12.0) * frame.size.width, frame.size.width - minGapSize)
//
//        var randMin: Int = 1
//        var randMax: Int = 16
//
//        if 1...6 ~= lastRandom { // Last Platform Set Was Left Only
//            randMin = 7
//        }
//        else if 11...16 ~= lastRandom { // Last Platform Set Was Right Only
//            randMax = 10
//        }
//
//
//        var transitionCheck = false
//
//        if platformCount == 30 {
//            currentStage = -currentStage
//            currentStage += 1
//            setPlatforms()
//            platformCount = 0
//
//        } else if platformCount >= 19 {
//            if platformCount == 19 {
//                currentStage = -currentStage
//                setPlatforms()
//            }
//
//            transitionCheck = true
//            xPosition = frame.width * 0.125
//        }
//
////        if score == 30 || score == 60 {
////            setBackground()
////        }
//
//        if score == 28 || score == 58 {
//            setBackground()
//        }
//
//        if transitionCheck == true {
//            randMin = 7
//            randMax = 7
//        }
//
//
//        print("currentStage post: \(currentStage)")
//
//
//        platformPhysics = SKPhysicsBody(rectangleOf: CGSize(width: platformTexture.size().width, height: platformTexture.size().height))
//        let platformLeft = SKSpriteNode(texture: platformTexture)
//        platformLeft.physicsBody = platformPhysics.copy() as? SKPhysicsBody
//        platformLeft.physicsBody?.isDynamic = false
//        platformLeft.physicsBody?.affectedByGravity = false
//        platformLeft.physicsBody?.collisionBitMask = 0
//        platformLeft.scale(to: CGSize(width: platformLeft.size.width * 3, height: platformLeft.size.height * 3))
//        platformLeft.zPosition = 20
//        platformLeft.name = "left_platform"
//        platformArray.append(platformLeft)
//
//        let platformRight = SKSpriteNode(texture: platformTexture)
//        platformRight.physicsBody = platformPhysics.copy() as? SKPhysicsBody
//        platformRight.physicsBody?.isDynamic = false // was set to true
//        platformRight.physicsBody?.collisionBitMask = 0
//        platformRight.scale(to: CGSize(width: platformRight.size.width * 3, height: platformRight.size.height * 3))
//        platformRight.zPosition = 20
//        platformRight.name = "right_platform"
//
//        let scoreNode = SKSpriteNode(color: UIColor.clear, size: CGSize(width: frame.width, height: firstPlatform.size().height))
//        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
//        scoreNode.physicsBody?.isDynamic = false
//        scoreNode.zPosition = 100
//        scoreNode.name = "scoreDetect"
//
//
//        // randomizer need to check if one or both platform needs to be added
//
//        let platformRandomizer = CGFloat(Int.random(in: randMin ... randMax))
//
//        let minGapSize: CGFloat = -frame.size.width / 6
//
//        var lpx: CGFloat = xPosition + platformLeft.size.width - minGapSize
//        var rpx: CGFloat = xPosition + minGapSize
//        var lpp: CGPoint
//        var rpp: CGPoint
//        var score_gap: [CGFloat] = []
//        var xAdjuster: CGFloat = 0
//
//
//        if 1...6 ~= platformRandomizer { // Single Left Platform Spawns
//            newNodes = [platformLeft, scoreNode]
//            lpx = frame.width * (platformRandomizer / 18)
//            rpx = 0
//            score_gap.append(frame.width - lpx)
//            score_gap.append(frame.maxX)
//
//
//            print("left")
//
//        }
//        else if 11...16 ~= platformRandomizer { // Single Right Platform Spawns
//            newNodes = [platformRight, scoreNode]
//            rpx = frame.width * (platformRandomizer / 18)
//            lpx = 0
//            score_gap.append(frame.minX)
//            score_gap.append(frame.minX + frame.width - rpx)
//
//            lpp = CGPoint(x: frame.minX - (platformLeft.size.width / 2), y: yPosition)
//            rpp = CGPoint(x: rpx, y: yPosition)
//            print("right")
//
//        }
//        else { // Both Platforms Spawn
//            newNodes = [platformLeft, platformRight, scoreNode]
//            score_gap.append(frame.minX + (lpx * 2))
//            score_gap.append(frame.maxX - (rpx * 2))
//            lpp = CGPoint(x: lpx, y: yPosition)
//            rpp = CGPoint(x: rpx, y: yPosition)
//            print("double")
//        }
//
//
//        if positionAtScore != nil && score_gap[0]...score_gap[1] ~= positionAtScore {
//
//            xAdjuster = min(positionAtScore - score_gap[0],score_gap[1] - positionAtScore)
//            print("Adjuster Triggered! Previous Score Position: \(positionAtScore!)\n Scoring Gap Between \(score_gap[0]) and \(score_gap[1])\n Adjustment: \(xAdjuster)")
//
//        }
//
//        for node in newNodes {
//            platformGroup.insert(node)
//        }
//
//        print("transitionCheck: \(transitionCheck)")
//
//
//        // Glancing at this section, could this be moved in the if else case above?
//
//        if lpx == 0 {
//            platformLeft.position = CGPoint(x: frame.minX - (platformLeft.size.width / 2), y: yPosition)
//            platformRight.position = CGPoint(x: rpx - xAdjuster, y: yPosition)
//        }
//        else if rpx == 0 {
//            platformLeft.position = CGPoint(x: lpx + xAdjuster, y: yPosition)
//            platformRight.position = CGPoint(x: frame.maxX + (platformRight.size.width / 2), y: yPosition)
//
//        }
//        else {
//            if transitionCheck == true {
//
//                platformLeft.position = CGPoint(x: lpx, y: yPosition)
//                platformRight.position = CGPoint(x: xPosition + minGapSize, y: yPosition)
//            }
//            else {
//
//                platformLeft.position = CGPoint(x: lpx + xAdjuster, y: yPosition)
//                platformRight.position = CGPoint(x: rpx, y: yPosition)
//            }
//        }
//
//
////        print("transitionPlatform height: \(transitionPlatform.size().height)")
//
//        getSpriteDetails(node: platformLeft)
//        getSpriteDetails(node: platformRight)
//
//        scoreNode.position = CGPoint(x: frame.midX, y: platformLeft.position.y)
//
//
//        lpLabel = SKLabelNode()
//        lpLabel.fontName = "Paper Plane Font"
//        lpLabel.position = CGPoint(x: frame.midX, y: platformLeft.position.y - platformLeft.size.height)
//        lpLabel.fontSize = 36
//        lpLabel.zPosition = 360
//        lpLabel.text = "num: \(platformCount), lpx: \((Int)(platformLeft.position.x)) rpx: \((Int)(platformRight.position.x))"
//        addChild(lpLabel)
//
//        var labelBG = SKSpriteNode()
//        labelBG.color = .black
//        labelBG.alpha = 0.55
//        labelBG.size = CGSize(width: frame.width, height: 36)
//        labelBG.position = CGPoint(x: frame.midX, y: lpLabel.position.y - 10)
//        labelBG.zPosition = 355
//        addChild(labelBG)
//
//        let endPosition = lastPlatformPosition + 1000 // by the time the block of code gets executed, it's likely not actively reading the positional change of the node to remove it. Probably needs an SKAction to run until the condition to remove the node is met because the block below doesn't seem to be running (because conditions are being met in time).
//
//        for node in newNodes {
//
//            addChild(node)
//            nodeArray.append(node)
//            lastPlatformPosition = node.position.y // stores the spawned position of most recently created platform(s). Used to reference this position to form static distance between the most recent platform(s) and the next platform(s) that will be spawned next.
//
//
//        let nodeSeq = SKAction.sequence([
//
//            SKAction.removeFromParent(),
//            SKAction.run {
//                print("node removed")
//            },
//            SKAction.run {
//                self.platformGroup.remove(node)
//            }
//        ])
//
//            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [self] timer in
//
//                if node.position.y > plane.position.y + (transitionPlatform.size().height * 6) { // number chosen it based on when plane reaches so many further platforms down
//                    timer.invalidate()
//                    node.run(nodeSeq)
//                    print("timer ran!")
//                }
//            }
//
////            print("node pos \(node.position)")
//
//        }
//
//
//
//
//
//        platformCount += 1
//
//        print("added platform: \(platformCount)")
//
//        lastRandom = platformRandomizer
//
//        increaseWorldSpeed += 1
//        if increaseWorldSpeed % 10 == 0 {
//            if scene!.speed <= 1.75 {
//                scene?.speed = scene!.speed + 0.05
//                print("Game Speed: \(scene!.speed)")
//                if scene!.speed > 1.75 {
//                    scene?.speed = 1.75
//                }
//            }
//        }
//    }


    func createButtons() {
        
        buttonLeft = SKSpriteNode()
        buttonLeft.size = CGSize(width: frame.width / 2, height: frame.height)
        buttonLeft.position = CGPoint(x: frame.midX / 2, y: frame.midY)
        //        buttonLeft.color = .black
        buttonLeft.alpha = 1
        buttonLeft.name = "buttonLeft"
        buttonLeft.zPosition = 200
        UINode.addChild(buttonLeft)

        buttonRight = SKSpriteNode()
        buttonRight.size = CGSize(width: frame.width / 2, height: frame.height)
        buttonRight.position = CGPoint(x: frame.midX * 1.5, y: frame.midY)
        //        buttonRight.color = .black
        buttonRight.alpha = 1
        buttonRight.name = "buttonRight"
        buttonRight.zPosition = 200
        UINode.addChild(buttonRight)

        // leftControl and rightControl are fake button. Just a UI piece to indicate where to tap for movement

        leftControl = SKSpriteNode(imageNamed: "left_control_button")
        leftControl.size = CGSize(width: 96, height: 96)
        leftControl.position = CGPoint(x: frame.maxX * 0.2, y: frame.maxY * 0.15)
        leftControl.alpha = 1
        leftControl.zPosition = 190
        leftControl.name = "leftControl"
        leftControl.isHidden = UserDefaults.standard.bool(forKey: "areControlsHidden")
        UINode.addChild(leftControl)

        rightControl = SKSpriteNode(imageNamed: "right_control_button")
        rightControl.size = CGSize(width: 96, height: 96)
        rightControl.position = CGPoint(x: frame.maxX * 0.8, y: frame.maxY * 0.15)
        rightControl.alpha = 1
        rightControl.zPosition = 190
        rightControl.name = "rightControl"
        rightControl.isHidden = UserDefaults.standard.bool(forKey: "areControlsHidden")
        UINode.addChild(rightControl)

        pauseButton = SKSpriteNode(imageNamed: "Pause Button")
        pauseButton.size = CGSize(width: 48, height: 48)
        pauseButton.position = CGPoint(x: frame.maxX - 50, y: frame.maxY - 50)
        pauseButton.zPosition = 250
        pauseButton.name = "pauseButton"
        UINode.addChild(pauseButton)
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
    
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   SCENE CHANGING METHODS
    // ------------------------------------------------------------------------------------------------------------------------------------------


    func restartGame() {
        
        if let scene = GameSceneRewrite(fileNamed: "GameSceneRewrite") {
            scene.scaleMode = .aspectFill
            scene.size = self.view!.frame.size
            let transition = SKTransition.fade(with: .black, duration: 2)
            view?.presentScene(scene, transition: transition)
        }
    }


    func backToTitle() {
        
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
    
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   IN-GAME MENUS
    // ------------------------------------------------------------------------------------------------------------------------------------------
    

    func pauseGame() {
        
        scoreLabel.alpha = 0

        homeButton.size = CGSize(width: 48, height: 48)
        homeButton.zPosition = 250
        homeButton.position = CGPoint(x: frame.maxX * 0.35, y: UINode.position.y + (frame.maxY * 0.90))
        homeButton.name = "homeButton"

        restartButton.size = CGSize(width: 48, height: 48)
        restartButton.zPosition = 250
        restartButton.position = CGPoint(x: frame.maxX * 0.65, y: UINode.position.y + (frame.maxY * 0.90))
        restartButton.name = "restartButton"

        levelSelectButton.size = CGSize(width: 48, height: 48)
        levelSelectButton.zPosition = 250
        levelSelectButton.position = CGPoint(x: frame.maxX * 0.5, y: UINode.position.y + (frame.maxY * 0.90))
        levelSelectButton.name = "levelSelectButton"

        let pauseLabel = SKLabelNode(fontNamed: "Paper Plane Font")
        pauseLabel.position = CGPoint(x: frame.midX, y: UINode.position.y + (frame.maxY * 0.65))
        pauseLabel.text = "Paused"
        pauseLabel.fontSize = 48
        pauseLabel.zPosition = 250
        pauseLabel.name = "pauseLabel"

        addChild(homeButton)
        addChild(restartButton)
        addChild(levelSelectButton)
        addChild(pauseLabel)

        for node in nodeArray {
            node.isPaused = true
        }
    }
    

    func closePauseMenu() {
        
        scoreLabel.alpha = 1
        homeButton.removeFromParent()
        restartButton.removeFromParent()
        levelSelectButton.removeFromParent()
        childNode(withName: "pauseLabel")?.removeFromParent()

        for node in nodeArray {
            node.isPaused = false
        }
    }
    
    func destroyPlane() {

        if let particles = SKEmitterNode(fileNamed: "DestroyPlane") {
            particles.position = plane.position
            particles.zPosition = 50
            addChild(particles)
        }

        leftControl.removeFromParent()
        rightControl.removeFromParent()

        Animations.shared.fadeAlphaOut(node: scoreLabel, duration: 0.5, waitTime: 0)

        // SKAction.colorize doesn't work for some reason
        for node in backgroundArray {
            node.color = .darkGray
            node.colorBlendFactor = 0.65
        }

        for node in cloudPieces {
            node.color = .darkGray
            node.colorBlendFactor = 0.65
        }
        
        for node in platformGroup {
            if node.name == "scoreDetect" {
                node.color = .clear
            } else {
                node.color = .darkGray
                node.colorBlendFactor = 0.65
            }
        }
        
        sky.color = .darkGray
        sky.colorBlendFactor = 0.65

        let continueLabel = SKLabelNode(fontNamed: "Paper Plane Font")
        continueLabel.position = CGPoint(x: frame.midX, y: UINode.position.y + (frame.maxY * 0.725))
        continueLabel.fontSize = 45
        continueLabel.text = "Tap to continue"
        continueLabel.color = .black
        continueLabel.alpha = 0
        continueLabel.zPosition = 70
        continueLabel.name = "continueLabel"
        addChild(continueLabel)

        _ = SKAction.fadeAlpha(to: 0.5, duration: 1)
        let fadeIn = SKAction.fadeIn(withDuration: 1.5)
        let wait = SKAction.wait(forDuration: 1.2)
        let fadeOut = SKAction.fadeOut(withDuration: 1.5)
        let fadeInFadeOut = SKAction.sequence([fadeIn, wait, fadeOut])
        let repeatForever = SKAction.repeatForever(fadeInFadeOut)

        continueLabel.run(repeatForever)

        for node in nodeArray {
            if node.name != "clouds" {
                node.removeAllActions()
            }
        }
        
        plane.removeFromParent()
        gameState = 1

        pauseButton.removeFromParent()
        toggleNoClip.removeFromParent()
    }


    func gameOver() {
        
        guard gameState == 1 else { return }

        buttonLeft.removeFromParent()
        buttonRight.removeFromParent()

        SavedData.shared.setScore(score)
        SavedData.shared.setScore(score)

        SavedData.shared.setGamesPlayed()

        let sortedScores = SavedData.shared.getScore()?.sorted(by: >).first
        let scoreAsString = sortedScores.map(String.init)

        childNode(withName: "continueLabel")?.removeFromParent()
        childNode(withName: "continueLabel")?.removeAllActions()
        childNode(withName: "gameOverLabel")?.removeFromParent()

        let gameOverLabel = SKSpriteNode(imageNamed: "game_over_label")
        gameOverLabel.position = CGPoint(x: frame.midX, y: UINode.position.y + frame.maxY * 0.825)
        gameOverLabel.size = CGSize(width: gameOverLabel.size.width * 1.5, height: gameOverLabel.size.height * 1.5)
        gameOverLabel.zPosition = 200
        gameOverLabel.alpha = 0
        gameOverLabel.name = "gameOverLabel"
        addChild(gameOverLabel)
        gameOverUIContainer.append(gameOverLabel)

        gameOverWindow = SKSpriteNode(imageNamed: "game_over_window")
        gameOverWindow.position = CGPoint(x: frame.midX, y: UINode.position.y + (frame.midY * 1.1))
        gameOverWindow.size = CGSize(width: gameOverWindow.size.width * 1.8, height: gameOverWindow.size.height * 1.8)
        gameOverWindow.zPosition = 170
        gameOverWindow.alpha = 0
        gameOverWindow.name = "gameOverWindow"
        addChild(gameOverWindow)
        gameOverUIContainer.append(gameOverWindow)

        restartButton.size = CGSize(width: 80, height: 80)
        restartButton.position = CGPoint(x: gameOverWindow.frame.minX + (restartButton.frame.width / 2), y: gameOverWindow.frame.minY - 70)
        restartButton.alpha = 0
        restartButton.zPosition = 210
        restartButton.name = "restartButton"
        addChild(restartButton)
        gameOverUIContainer.append(restartButton)

        levelSelectButton.size = CGSize(width: 80, height: 80)
        levelSelectButton.position = CGPoint(x: gameOverWindow.frame.midX, y: gameOverWindow.frame.minY - 70)
        levelSelectButton.alpha = 0
        levelSelectButton.zPosition = 210
        levelSelectButton.name = "levelSelectButton"
        addChild(levelSelectButton)
        gameOverUIContainer.append(levelSelectButton)

        homeButton.size = CGSize(width: 80, height: 80)
        homeButton.position = CGPoint(x: gameOverWindow.frame.maxX - (homeButton.frame.width / 2), y: gameOverWindow.frame.minY - 70)
        homeButton.zPosition = 210
        homeButton.alpha = 0
        homeButton.name = "homeButton"
        addChild(homeButton)
        gameOverUIContainer.append(homeButton)

        bestScore = SKLabelNode(fontNamed: "Paper Plane Font")
        bestScore.text = scoreAsString
        bestScore.alpha = 0
        bestScore.zPosition = 210
        bestScore.fontSize = 65
        bestScore.fontColor = SKColor.white
        bestScore.position = CGPoint(x: gameOverWindow.frame.midX, y: gameOverWindow.frame.midY - 65)
        bestScore.name = "bestScore"
        addChild(bestScore)
        gameOverUIContainer.append(bestScore)

        //        let moveScore = SKAction.move(to: CGPoint(x: gameOverWindow.frame.midX, y: gameOverWindow.frame.maxY * 0.9), duration: 1.3)
        //        let pulseUp = SKAction.scale(to: 2.0, duration: 0.8)
        //        let pulseDown = SKAction.scale(to: 1, duration: 0.8)
        //
        //        let pulseSeq = SKAction.sequence([pulseUp, pulseDown])

        //        scoreLabel.run(moveScore)
        //        scoreLabel.run(pulseSeq)

        scene!.speed = 1.00

        scoreLabel.position = CGPoint(x: gameOverWindow.frame.midX, y: frame.maxY * 0.645) // not positioning correctly

        for node in gameOverUIContainer {
            Animations.shared.fadeAlphaIn(node: node, duration: 0.75, waitTime: 0)
        }

        Animations.shared.fadeAlphaIn(node: gameOverLabel, duration: 0.75, waitTime: 0)
        Animations.shared.fadeAlphaIn(node: scoreLabel, duration: 0.75, waitTime: 0)

        for node in nodeArray {
            if node.name != "clouds" {
                node.isPaused = true
            }
        }
    }
    
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   UPDATE, COLLISIONS, & TOUCHES HANDLING
    // ------------------------------------------------------------------------------------------------------------------------------------------
    
    
    override func update(_ currentTime: TimeInterval) {

        lastBackgroundPosition = backgroundArray.last?.position.y // Doesn't work when placed in createBackground() for some reason despite the logic feeling right
        
        planeCoords.text = "\((Int)(plane.position.y))"
//        print("Plane PosY \((Int)(plane.position.y))")


        playerCamera.position.y = plane.position.y - (frame.midY / 3)
        UINode.position.y = playerCamera.position.y - (frame.size.height / 2)
        sky.position.y = playerCamera.position.y
        
        for i in cloudPieces {
            i.position.y = playerCamera.position.y - frame.midY
        }
        
        
//        print("platformCount \(platformGroup.count)")

        // may want to change the static number to a multiple of transitionPlatform.size().height to avoid potential scaling issues. 480 = transitionPlatform.size().height * 6; 720 = transitionPlatform.size().height. These numbers line up perfectly with mid-sections of the platforms. 600 or trasitionPlatform.size().height * 7.5 is perfectly in the middle between two platforms.
        
        // transitionPlatform.size().height * 3/6/9/... (240/480/720/...) is perfectly in line with platforms; * 1.5/4.5/7.5/... (120/360/600/...) is perfectly between platforms
        
        visualPlatformTrigger.size = CGSize(width: frame.size.width, height: 10)
        visualPlatformTrigger.position = CGPoint(x: frame.midX, y: (platformArray.last?.position.y)! + 480)
        
        if (platformArray.last?.position.y)! + 480 > plane.position.y {
            self.createPlatforms()
        }
        
        if (backgroundArray.last?.position.y)! + 480 > plane.position.y {
            self.createBackground()
        }
        
        if isPlaneDestroyed == false {
            if plane.position.x <= frame.minX + (plane.size.width / 7) || plane.position.x >= frame.maxX - (plane.size.width / 7) {
                isPlaneDestroyed = true
                destroyPlane()
            }
        }
    }


    func didBegin(_ contact: SKPhysicsContact) {
        //        print("collision")

        if contact.bodyA.node?.name == "scoreDetect" || contact.bodyB.node?.name == "scoreDetect" {
            if contact.bodyA.node == plane {
                guard shouldDetectScore == true else { return }
                positionAtScore = contact.contactPoint.x

                contact.bodyB.node?.removeFromParent()
            } else {
                contact.bodyA.node?.removeFromParent()
            }

            shouldDetectScore = false

//            print("Score Collision Point: \(positionAtScore)")
            score += 1
            
            let wait = SKAction.wait(forDuration: 0.4)
            let toggleCollision = SKAction.run {
                self.shouldDetectScore = true
            }
            let seq = SKAction.sequence([wait, toggleCollision])
            run(seq)

            return
        }

        guard contact.bodyA.node != nil && contact.bodyB.node != nil else {
            return
        }

        guard noClip == false else { return }

        if contact.bodyA.node == plane || contact.bodyB.node == plane {
            
            print("contact A: \(contact.bodyA.node), contact B: \(contact.bodyB.node)")
            
            destroyPlane()
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
            let delay = SKAction.wait(forDuration: 0.095)
            let seq = SKAction.sequence([cycle, delay])
            let repeatAction = SKAction.repeatForever(seq)

            if touchedNode.name == "buttonLeft" {
                isButtonTouched = "buttonLeft"

                if gameHasStarted == true {
                    buttonLeft.run(repeatAction, withKey: "cycle")
                    //                isLeftButtonPressed = true
                }
            }

            if touchedNode.name == "buttonRight" {
                isButtonTouched = "buttonRight"

                if gameHasStarted == true {
                    buttonRight.run(repeatAction, withKey: "cycle")
                    //                isRightButtonPressed = true
                }
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

            if touchedNode.name == "levelSelectButton" {
                Animations.shared.shrink(node: levelSelectButton)
                isButtonTouched = "levelSelectButton"
            }

            if touchedNode.name == "noClip" {
                Animations.shared.shrink(node: toggleNoClip)
                isButtonTouched = "noClip"
            }

            if touchedNode.name == "gotIt" {
                Animations.shared.shrink(node: gotIt)
                isButtonTouched = "gotIt"
            }
        }
    }


    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            print("touchedNode: \(touchedNode.name)")

            // logically it can be put as only: else if isButtonIsTouched == "\stringName" rather than including touchedNode.name as well
            if touchedNode.name == "noClip" && isButtonTouched == "noClip" {
                Animations.shared.expand(node: toggleNoClip)
            } else if touchedNode.name != "" && isButtonTouched == "noClip" {
                Animations.shared.expand(node: toggleNoClip)
            }

            if touchedNode.name == "pauseButton" && isButtonTouched == "pauseButton" {
                gameIsPaused.toggle()
                if gameIsPaused == true { pauseGame() } else { closePauseMenu() }
                Animations.shared.expand(node: pauseButton)
            } else if touchedNode.name != "" && isButtonTouched == "pauseButton" {
                Animations.shared.expand(node: pauseButton)
            }

            if touchedNode.name == "homeButton" {
                let expand = SKAction.run { [unowned self] in
                    Animations.shared.expand(node: homeButton)
                }
                let wait = SKAction.wait(forDuration: 0.175)
                let sequence = SKAction.sequence([expand, wait])
                
                run(sequence, completion: { self.backToTitle() })
            } else if touchedNode.name != "" && isButtonTouched == "homeButton" {
                Animations.shared.expand(node: homeButton)
            }

            if touchedNode.name == "restartButton" {
                Animations.shared.expand(node: restartButton)
                restartGame()
            } else if touchedNode.name != "" && isButtonTouched == "restartButton" {
                Animations.shared.expand(node: restartButton)
            }

            if touchedNode.name == "levelSelectButton" {
                Animations.shared.expand(node: levelSelectButton)
                worldSelectMenu()
            } else if touchedNode.name != "" && isButtonTouched == "levelSelectButton" {
                Animations.shared.expand(node: levelSelectButton)
            }

            if touchedNode.name == "noClip" {
                noClip = !noClip
            }

            if touchedNode.name == "gotIt" {
                Animations.shared.expand(node: gotIt)

                let fadeOut = SKAction.run {
                    Animations.shared.fadeAlphaOut(node: self.howToPlay, duration: 0.25, waitTime: 0)
                    Animations.shared.fadeAlphaOut(node: self.gotIt, duration: 0.25, waitTime: 0)
                }

                let wait = SKAction.wait(forDuration: 0.25)

                let remove = SKAction.run {
                    self.childNode(withName: "howToPlay")?.removeFromParent()
                    self.childNode(withName: "gotIt")?.removeFromParent()
                }

                let seq = SKAction.sequence([fadeOut, wait, remove])
                run(seq)

                firstTimePlaying.toggle()
                SavedSettings.shared.setTutorialData()
                countdown()

            } else if touchedNode.name != "" && isButtonTouched == "gotIt" {
                Animations.shared.expand(node: gotIt)
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
