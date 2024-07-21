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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
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
    var dontShowAgain: SKSpriteNode!
    var close: SKSpriteNode!
    var noticeWindow: SKSpriteNode!
    
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
    var wallLeftArray = [SKSpriteNode]()
    var wallRightArray = [SKSpriteNode]()
    
    var lastBackgroundPosition: CGFloat!
    var lastWallPosition: CGFloat!
    
    var backgroundTexture: SKTexture! { didSet { for background in backgroundArray { background.texture = backgroundTexture } } }
    var firstBackground: SKTexture!
    var secondBackground: SKTexture!
    var thirdBackground: SKTexture!
    
    var wallLeftTexture: SKTexture! { didSet { for wallLeft in wallLeftArray { wallLeft.texture = wallLeftTexture } } } // these two might conflict with the background loop
    var firstWallLeft: SKTexture!
    var secondWallLeft: SKTexture!
    var thirdWallLeft: SKTexture!
    
    var wallRightTexture: SKTexture! { didSet { for wallRight in wallRightArray { wallRight.texture = wallRightTexture } } }
    var firstWallRight: SKTexture!
    var secondWallRight: SKTexture!
    var thirdWallRight: SKTexture!
    
    var wallWidth: CGFloat!
    
    var plane: SKSpriteNode!
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   PLATFORMS
    // ------------------------------------------------------------------------------------------------------------------------------------------
    
    var lastPlatformPosition: CGFloat! // Needs to start at y-pos 422, so I made it 662 because of how yPosition is calculated. May be changed.
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
    var scoreLabelShadow: SKLabelNode!
    var score = 0 { didSet { scoreLabel.text = "\(score)"; scoreLabelShadow.text = "\(score)" } }
    var finalScoreLabel: SKLabelNode!
    var bestScore: SKLabelNode!
    var bestScoreShadow: SKLabelNode!
    
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
    
    var planeTurnSoundState: Int = 1
    
    var soundStateLeft: Bool = true
    var soundStateRight: Bool = true
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   MISC NODES & CONTAINERS
    // ------------------------------------------------------------------------------------------------------------------------------------------
    
    var nodeArray = [SKNode]()
    
    var UINode: SKNode!
    
    var gameOverUIContainer = [SKNode]()

    var countdownLabel: SKLabelNode!
    var countdownLabelShadow: SKLabelNode!
    var count = 3 { didSet { countdownLabel.text = "\(count)" ; countdownLabelShadow.text = "\(count)"} }
    
    var planeTexture = SKTexture(imageNamed: "Plane 9")
    var planeSize: CGSize!
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   MISC VARIABLES & CONSTANTS
    // ------------------------------------------------------------------------------------------------------------------------------------------
    
    var shouldDetectScore: Bool = true
    var shouldChangeBackgrounds: Bool = true
    
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
    
    var timesSpawned: Int = 0
    
    var screenBoundsNode: SKSpriteNode! { didSet { screenBoundsNode.position.y = frame.midY } }
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   FUNCTIONS
    // ------------------------------------------------------------------------------------------------------------------------------------------

    
    override func didMove(to view: SKView) {
        
//        print("Total Score: \(SavedData.shared.getTotalScore())")
        
        print("gettutorial \(SavedSettings.shared.getTutorialData())")
        
        gamesUntilAd -= 1
        print("games until ad: \(gamesUntilAd)")
        
//        print("frame middle: \(CGPoint(x: -frame.midX, y: frame.midY))")
        
        visualPlatformTrigger = SKSpriteNode()
        visualPlatformTrigger.color = .clear
        visualPlatformTrigger.alpha = 0.5
//        addChild(visualPlatformTrigger)

//        print("transitionPlat height\(transitionPlatform.size().height)")
        
        UINode = SKNode()
        addChild(UINode)

        let midXNode = SKSpriteNode(color: .clear, size: CGSize(width: 5, height: 2500))
        midXNode.position = CGPoint(x: frame.midX, y: frame.midY)
        midXNode.zPosition = 900
//        addChild(midXNode)

        // add a transparent bar at the top for UI elements
        let topBar = SKSpriteNode()
        topBar.size = CGSize(width: frame.width, height: frame.height / 10)
        topBar.position = CGPoint(x: frame.midX, y: frame.maxY - (topBar.size.height / 2))
        topBar.color = .black
        topBar.alpha = 0.6
        topBar.zPosition = 10
        //        addChild(topBar)

//        print("When lowestPlatform is greater than this point \((self.frame.midY / 2) - self.transitionPlatform.size().height * 3)")
        platformGap = frame.midY - (((transitionPlatform.size().height * 3) * CGFloat(min(platformCount,2))))
//        print ("platformGap \(platformGap)") // 422.0 initially

//        lastPlatformPosition = frame.midY - (((transitionPlatform.size().height * 3) * CGFloat(min(platformCount,2))))
        
        lastBackgroundPosition = view.center.y * 3.5 // 1477.0 -- need to figure maybe a better offset to initalize background spawn position
        lastWallPosition = view.center.y * 3.5
        
        // INITIAL FUNCTIONS
        
//        admobDelegate.createInterstitial()
        
        initiateTextures()
        createLabels()
        createButtons()
        createBackground()
        createBackground()
        createPlane()
        createWalls()
        createWalls()
        createSky()
        createPlatforms()
        createPlatforms()
        createPlatforms()
        createPlatforms()
        planeMode()
        preGame()
//        musicPlayer()
        
        GameViewController.shared.hideBannerAds()

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

//        print("Object Name: \(name)\n Left Min: \(minX)\n MidPoint of Width: \(midX)\n Right Max: \(maxX)\n Node Width: \(nodeFrame.size.width)")

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
        
        for node in wallLeftArray {
            node.color = .darkGray
            node.colorBlendFactor = 0.65
        }
        
        for node in wallRightArray {
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
            UINode.addChild(howToPlay)

            gotIt = SKSpriteNode(imageNamed: "got_it")
            gotIt.size = CGSize(width: gotIt.size.width, height: gotIt.size.height)
            gotIt.position = CGPoint(x: howToPlay.position.x, y: howToPlay.position.y - (howToPlay.size.height * 0.25))
            gotIt.zPosition = 900
            gotIt.name = "gotIt"
            UINode.addChild(gotIt)
            
            dontShowAgain = SKSpriteNode(imageNamed: "dont_show_again")
            dontShowAgain.size = CGSize(width: dontShowAgain.size.width, height: dontShowAgain.size.height)
            dontShowAgain.position = CGPoint(x: howToPlay.position.x, y: gotIt.position.y - gotIt.size.height * 1.75)
            dontShowAgain.zPosition = 900
            dontShowAgain.name = "dontShowAgain"
            UINode.addChild(dontShowAgain)

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
        countdownLabel.position = CGPoint(x: frame.midX, y: plane.position.y)
        countdownLabel.zPosition = 300
        countdownLabel.fontSize = 96
        countdownLabel.text = "\(count)"
        addChild(countdownLabel)
        
        countdownLabelShadow = SKLabelNode(fontNamed: "Paper Plane Font")
        countdownLabelShadow.position = CGPoint(x: countdownLabel.position.x, y: countdownLabel.position.y - 8)
        countdownLabelShadow.zPosition = 295
        countdownLabelShadow.fontSize = 96
        countdownLabelShadow.fontColor = .black
        countdownLabelShadow.text = "\(count)"
        addChild(countdownLabelShadow)

        let decreaseCounter = SKAction.sequence([SKAction.wait(forDuration: 0.75), SKAction.run { [unowned self] in
            self.count -= 1
        }])

        let endCountdown = SKAction.run { [unowned self] in
            self.countdownLabel.removeFromParent()
            self.countdownLabelShadow.removeFromParent()
            childNode(withName: "barrier")?.removeFromParent()

            for node in platformGroup {
                if node.name == "platformLeft" || node.name == "platformRight" {
                    node.colorBlendFactor = 0
                }
            }
            
            for node in backgroundArray {
                node.colorBlendFactor = 0
            }
            
            for node in wallLeftArray {
                node.colorBlendFactor = 0
            }
            
            for node in wallRightArray {
                node.colorBlendFactor = 0
            }

            for node in cloudPieces {
                node.colorBlendFactor = 0
            }

            self.start()
        }

        run(SKAction.sequence([SKAction.repeat(decreaseCounter, count: 3), endCountdown]))
        
        Audio.shared.playWindSound()
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
            
            firstWallLeft = SKTexture(imageNamed: "castle_wall_1")
            secondWallLeft = SKTexture(imageNamed: "castle_wall_2")
            thirdWallLeft = SKTexture(imageNamed: "castle_wall_3")
            
            firstWallRight = SKTexture(imageNamed: "castle_wall_1")
            secondWallRight = SKTexture(imageNamed: "castle_wall_2")
            thirdWallRight = SKTexture(imageNamed: "castle_wall_3")

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
            
            firstWallLeft = SKTexture(imageNamed: "chasm_wall_1")
            secondWallLeft = SKTexture(imageNamed: "chasm_wall_2")
            thirdWallLeft = SKTexture(imageNamed: "chasm_wall_3")
            
            firstWallRight = SKTexture(imageNamed: "chasm_wall_1")
            secondWallRight = SKTexture(imageNamed: "chasm_wall_2")
            thirdWallRight = SKTexture(imageNamed: "chasm_wall_3")

            skyTexture = SKTexture(imageNamed: "sky_background_night")

        case "silo":
            firstBackground = SKTexture(imageNamed: "silo_background_1")
            secondBackground = SKTexture(imageNamed: "silo_background_2")
            thirdBackground = SKTexture(imageNamed: "silo_background_3")

            firstPlatform = SKTexture(imageNamed: "platform_1")
            secondPlatform = SKTexture(imageNamed: "platform_2")
            thirdPlatform = SKTexture(imageNamed: "platform_3")
            transitionPlatform = SKTexture(imageNamed: "transition_platform")
            
            firstWallLeft = SKTexture(imageNamed: "silo_wall_1")
            secondWallLeft = SKTexture(imageNamed: "silo_wall_2")
            thirdWallLeft = SKTexture(imageNamed: "silo_wall_3")
            
            firstWallRight = SKTexture(imageNamed: "silo_wall_1")
            secondWallRight = SKTexture(imageNamed: "silo_wall_2")
            thirdWallRight = SKTexture(imageNamed: "silo_wall_3")

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
            wallLeftTexture = firstWallLeft
            wallRightTexture = firstWallRight
        case 2:
            backgroundTexture = secondBackground
            wallLeftTexture = secondWallLeft
            wallRightTexture = secondWallRight
            //            animateBackground(texture: secondBackground)
        case 3...:
            backgroundTexture = thirdBackground
            wallLeftTexture = thirdWallLeft
            wallRightTexture = thirdWallRight
        default:
            break
        }
        
        currentBG += 1
    }


    func musicPlayer() {
//        Audio.shared.musicPlayer(node: self.scene!)
    }


    @objc func planeMode() {
        
        var planeSize = CGSize(width: planeTexture.size().width * 1.5, height: planeTexture.size().height * 1.5)
        
        // Thought to be considered: Instead of modifying scene.speed in createPlatforms, create a variable instead that modifies modX/modY with a multiplier to prevent controls from feeling too fast. Faster controls may be better though considering the higher speeds.
        
        var modX: CGFloat!
        var modY: CGFloat!
        
        var hitBoxSize = CGSize(width: plane.size.width, height: plane.size.height)
        let hitBoxRotation: CGFloat
        
        // hitBoxRotation is divided by height instead of width due to degree rotation. Looks weird for a vertical hitbox to be divided by the height.
        // .pi / x is calculated as 180 / degrees
    
        switch mode {
        case 0:
            hitBoxSize = CGSize(width: plane.size.width, height: plane.size.height / 2)
            hitBoxRotation = CGFloat.pi
            planeTexture = SKTexture(imageNamed: "Plane 1")
            plane.texture = planeTexture
//            updatePlaneSprite(to: planeTexture, rotationAngle: hitBoxRotation)
            modX = -320
            modY = 40

        case 1:
            hitBoxSize = CGSize(width: plane.size.width, height: plane.size.height / 2)
            hitBoxRotation = CGFloat.pi / 12
            planeTexture = SKTexture(imageNamed: "Plane 2")
            plane.texture = planeTexture
//            updatePlaneSprite(to: planeTexture, rotationAngle: hitBoxRotation)
            modX = -260
            modY = 100

        case 2:
            hitBoxSize = CGSize(width: plane.size.width, height: plane.size.height / 2)
            hitBoxRotation = CGFloat.pi / 6
            planeTexture = SKTexture(imageNamed: "Plane 3")
            plane.texture = planeTexture
//
//            plane.anchorPoint = CGPoint(x: 0.4, y: 0.4)
//            
            
//            plane.size = CGSize(width: planeTexture.size().width * 1.25, height: planeTexture.size().height * 1.25)
//            
//            let path = CGMutablePath()
//            path.move(to: CGPoint(x: -plane.size.width / 2, y: plane.size.height / 2)) // top left
//            path.addLine(to: CGPoint(x: plane.size.width / 2, y: plane.size.height / 2)) // top right
//            path.addLine(to: CGPoint(x: 0, y: -plane.size.height / 2)) // bottom center
//            
//            path.closeSubpath()
//            var transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
//            let rotatedPath = path.copy(using: &transform)!
//            
//            plane.physicsBody = SKPhysicsBody(polygonFrom: rotatedPath)
//            
//            updatePlaneSprite(to: planeTexture, rotationAngle: hitBoxRotation)
            modX = -160
            modY = 160

        case 3:
            hitBoxSize = CGSize(width: plane.size.width, height: plane.size.height / 2)
            hitBoxRotation = CGFloat.pi / 4
            planeTexture = SKTexture(imageNamed: "Plane 4")
            plane.texture = planeTexture
//            updatePlaneSprite(to: planeTexture, rotationAngle: hitBoxRotation)
            modX = -80
            modY = 280

        case 4:
            plane.physicsBody = nil
            hitBoxSize = CGSize(width: plane.size.width, height: plane.size.height / 2)
            hitBoxRotation = CGFloat.pi / 2
            
            plane.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            planeTexture = SKTexture(imageNamed: "Plane 5")
            plane.texture = planeTexture
            plane.size = CGSize(width: planeTexture.size().width * 1.25, height: planeTexture.size().height * 1.25)
            
            
            let path = CGMutablePath()
            path.move(to: CGPoint(x: -plane.size.width / 4, y: plane.size.height / 2))
            path.addLine(to: CGPoint(x: plane.size.width / 4, y: plane.size.height / 2))
            path.addLine(to: CGPoint(x: plane.size.width / 4, y: 0))
            path.addLine(to: CGPoint(x: 0, y: -plane.size.height / 2))
            path.addLine(to: CGPoint(x: -plane.size.width / 4, y: 0))
            
            path.closeSubpath()
            
            plane.physicsBody = SKPhysicsBody(polygonFrom: path)
//            updatePlaneSprite(to: planeTexture, rotationAngle: hitBoxRotation)
            modX = 0
            modY = 360

        case 5:
            
            planeTexture = SKTexture(imageNamed: "Plane 6")
            hitBoxSize = CGSize(width: plane.size.width, height: plane.size.height / 2)
            hitBoxRotation = CGFloat.pi / 1.34
            plane.texture = planeTexture
//            updatePlaneSprite(to: planeTexture, rotationAngle: hitBoxRotation)
            modX = 80
            modY = 280 // 260 may be a better value, but hard to tell. 260 is the value between the previous and next value

        case 6:
            hitBoxSize = CGSize(width: plane.size.width, height: plane.size.height / 2)
            hitBoxRotation = CGFloat.pi / 1.2
            planeTexture = SKTexture(imageNamed: "Plane 7")
            
//            plane.anchorPoint = CGPoint(x: 0.6, y: 0.4)
            
            plane.texture = planeTexture
//            plane.size = CGSize(width: planeTexture.size().width * 1.25, height: planeTexture.size().height * 1.25)
//            
//            let path = CGMutablePath()
//            path.move(to: CGPoint(x: -plane.size.width / 3, y: plane.size.height / 2))
//            path.addLine(to: CGPoint(x: plane.size.width / 3, y: plane.size.height / 2))
//            path.addLine(to: CGPoint(x: 0, y: -plane.size.height / 2))
//            
//            path.closeSubpath()
//            var transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
//            let rotatedPath = path.copy(using: &transform)!
//            
//            plane.physicsBody = SKPhysicsBody(polygonFrom: rotatedPath)
            
//            updatePlaneSprite(to: planeTexture, rotationAngle: hitBoxRotation)
            modX = 160
            modY = 160

        case 7:
            hitBoxRotation = CGFloat.pi / 1.09
            planeTexture = SKTexture(imageNamed: "Plane 8")
            plane.texture = planeTexture
//            updatePlaneSprite(to: planeTexture, rotationAngle: hitBoxRotation)
            modX = 260
            modY = 100

        case 8:
            hitBoxSize = CGSize(width: plane.size.width, height: plane.size.height / 2)
            hitBoxRotation = 0
            planeTexture = SKTexture(imageNamed: "Plane 9")
            plane.texture = planeTexture
//            updatePlaneSprite(to: planeTexture, rotationAngle: hitBoxRotation)
            modX = 320
            modY = 40

        default:
            break
        }
        
        plane.removeAllActions()
        
        let moveByXY = SKAction.moveBy(x: modX, y: -modY, duration: 1.25) // would like duration to be 1, but 1.25 feels pretty good in terms of movement speed
        let repeatMove = SKAction.repeatForever(moveByXY)
        
        
        
        if mode != 4 {
            plane.physicsBody = nil
            plane.size = CGSize(width: planeTexture.size().width * 1.25, height: planeTexture.size().height * 1.25)
            plane.physicsBody = SKPhysicsBody(texture: planeTexture, size: planeTexture.size())
        }
        
        
        plane.run(repeatMove)
        
        plane.physicsBody!.contactTestBitMask = plane.physicsBody!.collisionBitMask
        plane.physicsBody?.categoryBitMask = planeCategory
        plane.physicsBody?.collisionBitMask = 0
        plane.physicsBody?.isDynamic = true
    }
    
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   NODE AND OBJECT CREATION
    // ------------------------------------------------------------------------------------------------------------------------------------------


    func createPlane() {
        
        plane = SKSpriteNode()
        plane.texture = planeTexture
        plane.position = CGPoint(x: frame.midX / 2, y: (backgroundArray.first?.position.y)! + ((backgroundArray.first?.size.height)! * 0.145))
        plane.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        plane.zPosition = 5
        plane.alpha = 1
        plane.size = CGSize(width: planeTexture.size().width * 1.3, height: planeTexture.size().height * 1.3)
        plane.name = "plane"
        addChild(plane)
        nodeArray.append(plane)

        plane.physicsBody = createPhysicsBody(for: plane)
        plane.physicsBody!.contactTestBitMask = plane.physicsBody!.collisionBitMask
        plane.physicsBody?.categoryBitMask = planeCategory
        plane.physicsBody?.collisionBitMask = 0
        plane.physicsBody?.isDynamic = true
        
        lastPlatformPosition = plane.position.y + (distanceBetweenPlatforms / 4)
    }
    
    
    func updatePlaneSprite(to newSprite: SKTexture, rotationAngle: CGFloat) {
        guard mode != 4 else { return }
        
        plane.physicsBody = nil
        // Update the sprite's image
        plane.texture = newSprite
        plane.size = CGSize(width: planeTexture.size().width * 1.25, height: planeTexture.size().height * 1.25)
        
        var hitBox = CGSize()
        
        switch mode {
        case 3:
            plane.anchorPoint = CGPoint(x: 0.4, y: 0.6)
            hitBox = CGSize(width: plane.size.width * 1.1, height: plane.size.height / 2.5)
        case 5:
            plane.anchorPoint = CGPoint(x: 0.6, y: 0.6)
            hitBox = CGSize(width: plane.size.width * 1.1, height: plane.size.height / 2.5)
        default:
            plane.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            hitBox = CGSize(width: plane.size.width, height: plane.size.height / 2.5)
        }

        // Create a path for the rotated rectangle
        let path = CGMutablePath()
        path.addRect(CGRect(origin: CGPoint(x: -hitBox.width / 2, y: -hitBox.height / 2), size: hitBox))
        path.closeSubpath()

        // Rotate the path
        var transform = CGAffineTransform(rotationAngle: rotationAngle)
        let rotatedPath = path.copy(using: &transform)!

        // Update the physics body with the new hitbox
        plane.physicsBody = SKPhysicsBody(polygonFrom: rotatedPath)
    }

    
    // Create a triangle. Consider original-inspired rectangle hitbox where wings are invunerable
    
    func createPhysicsBody(for sprite: SKSpriteNode) -> SKPhysicsBody {
        let insetWidth: CGFloat = 20
        let insetHeight: CGFloat = 20
        
        let adjustedWidth = plane.frame.size.height - 2 * insetWidth
        let adjustedHeight = plane.frame.size.height - 2 * insetHeight
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: (-adjustedWidth) / 3, y: (adjustedHeight) / 2.5))
        path.addLine(to: CGPoint(x: (adjustedWidth) / 3, y: (adjustedHeight) / 2.5))
        path.addLine(to: CGPoint(x: 0, y: (-adjustedHeight) / 2))
        path.closeSubpath()
        
        return SKPhysicsBody(polygonFrom: path)
    }


    func createLabels() {
        
        scoreLabel = SKLabelNode(fontNamed: "Paper Plane Font") // Asai-Analogue
        scoreLabel.text = "\(score)"
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY * 0.93)
        scoreLabel.fontSize = 60
        scoreLabel.zPosition = 220
        UINode.addChild(scoreLabel)
        
        scoreLabelShadow = SKLabelNode(fontNamed: "Paper Plane Font")
        scoreLabelShadow.text = "\(score)"
        scoreLabelShadow.position = CGPoint(x: scoreLabel.position.x, y: scoreLabel.position.y - 5)
        scoreLabelShadow.fontSize = 60
        scoreLabelShadow.fontColor = .black
        scoreLabelShadow.zPosition = 215
        UINode.addChild(scoreLabelShadow)

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
        
//        print("view.center.y \(view!.center.y)")

        addChild(background)
        nodeArray.append(background)
        
        // It works! Only issue is that the background moves by a constant y-amount no matter how fast the plane is moving downward. Might be worth looking into a solution to dynamically change the moveBy-y value in order to match plane speed.
        
        let moveBackground = SKAction.moveBy(x: 0, y: -10, duration: 1)
        let repeatMove = SKAction.repeatForever(moveBackground)
        background.run(repeatMove)
    }
    
    
    func createWalls() {
        
        let wallHeight = (view?.frame.size.width)! * 2.5
        wallWidth = wallHeight / 40
        
        let wallLeft = SKSpriteNode(imageNamed: "chasm_wall_1") // Shouldn't have to declare the texture from here similar to background, but it doesn't show up otherwise
        wallLeft.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        wallLeft.zPosition = 25
        wallLeft.size = CGSize(width: wallWidth, height: wallHeight)
        wallLeft.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: wallLeft.size.width, height: wallLeft.size.height))
        wallLeft.physicsBody?.isDynamic = false
        wallLeft.physicsBody?.affectedByGravity = false
        wallLeft.physicsBody?.contactTestBitMask = planeCategory
        wallLeft.physicsBody?.collisionBitMask = 0
        wallLeft.name = "wallLeft"
        wallLeftArray.append(wallLeft)
        
        let wallRight = SKSpriteNode(imageNamed: "chasm_wall_1")
        wallRight.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        wallRight.zPosition = 25
        wallRight.size = CGSize(width: wallWidth, height: wallHeight)
        wallRight.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: wallRight.size.width, height: wallRight.size.height))
        wallRight.physicsBody?.isDynamic = false
        wallRight.physicsBody?.affectedByGravity = false
        wallRight.physicsBody?.contactTestBitMask = planeCategory
        wallRight.physicsBody?.collisionBitMask = 0
        wallRight.name = "wallRight"
        wallRightArray.append(wallRight)
        
        // Doesn't get called at the same time as setBackground in createPlatforms when target score is reached
        
        for wallLeft in wallLeftArray {
            wallLeft.texture = wallLeftTexture
        }
        
        for wallRight in wallRightArray {
            wallRight.texture = wallRightTexture
        }
        
        var yPositionWalls = lastWallPosition - wallLeft.size.height
        
        wallLeft.position = CGPoint(x: view!.frame.minX, y: yPositionWalls)
        wallRight.position = CGPoint(x: view!.frame.maxX, y: yPositionWalls)
        
//        print("view.center.y \(view!.center.y)")

        addChild(wallLeft)
        addChild(wallRight)
        nodeArray.append(wallLeft)
        nodeArray.append(wallRight)
        
        // It works! Only issue is that the background moves by a constant y-amount no matter how fast the plane is moving downward. Might be worth looking into a solution to dynamically change the moveBy-y value in order to match plane speed.
        
//        let moveBackground = SKAction.moveBy(x: 0, y: -10, duration: 1)
//        let repeatMove = SKAction.repeatForever(moveBackground)
//        wallLeft.run(repeatMove)
//        wallRight.run(repeatMove)
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
        
        var platformWidth = UIScreen.main.bounds.width // making the platform the exact same width as the screen for scaling purposes
        var platformHeight: CGFloat // initial height using platform_1's height to width ratio
        
        distanceBetweenPlatforms = platformWidth * 0.5625 // instead of using static numbers, this is a ratio of transitionPlatform's height to width ratio
        
        var yPosition = lastPlatformPosition - distanceBetweenPlatforms // distanceBetweenPlatforms may need to be size relative like transitionPlatform.size.height
        
        
        
        let newNodes: Set<SKSpriteNode>
        
        if score > 30 { // iPhone SE calls setBackground() twice during the first transition, so this is an extra layer of safety to maintain the sequence
            shouldChangeBackgrounds = true
        }
        
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
            if shouldChangeBackgrounds == true {
                setBackground()
                shouldChangeBackgrounds = false
            }
        }
        
        if transitionCheck == true {
            randMin = 7
            randMax = 7
        }
        
        switch currentStage {
        case 1:
            platformHeight = platformWidth * 0.078125
        case 2:
            platformHeight = platformWidth * 0.171875
        case 3...:
            platformHeight = platformWidth * 0.265625
        case ..<0:
            platformHeight = platformWidth * 0.5625
        default:
            platformHeight = platformWidth * 0.078125
        }
        
        let platformLeft = SKSpriteNode(texture: platformTexture)
        platformLeft.size = CGSize(width: platformWidth, height: platformHeight)
        platformLeft.physicsBody = SKPhysicsBody(rectangleOf: platformLeft.size)
        platformLeft.physicsBody?.isDynamic = false
        platformLeft.physicsBody?.affectedByGravity = false
        platformLeft.physicsBody?.collisionBitMask = planeCategory
        platformLeft.physicsBody?.categoryBitMask = platformCategory
        platformLeft.physicsBody?.contactTestBitMask = planeCategory
        platformLeft.zPosition = 20
        platformLeft.name = "platformLeft"
        platformArray.append(platformLeft)
        
        let platformRight = SKSpriteNode(texture: platformTexture)
        platformRight.size = CGSize(width: platformWidth, height: platformHeight)
        platformRight.physicsBody = SKPhysicsBody(rectangleOf: platformRight.size)
        platformRight.physicsBody?.isDynamic = false
        platformRight.physicsBody?.affectedByGravity = false
        platformRight.physicsBody?.collisionBitMask = planeCategory
        platformRight.physicsBody?.categoryBitMask = platformCategory
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

//        platformRandomizer = 7
        
        switch platformRandomizer {
            
        case 1...6: // A Single Left Platform Spawns
            
//            print("Spawned One Left Platform")
            
            newNodes = [platformLeft, scoreNode]
            
//            xPosRandomizer = CGFloat.random(in: (frame.midX * 0.75) ... (frame.midX * 0.75)) // not sure why this is here
            
            if platformCount == 0 && platformArray.count <= 1 {
                xPosRandomizer = frame.midX * 0.70 - horizontalPlatformGap
            } else {
                xPosRandomizer = CGFloat.random(in: (view?.frame.minX)! ... (view?.frame.midX)! - horizontalPlatformGap) // old value was * frame.midX 0.65 (for right platform as well)
            }

        case 7...12: // A Single Right Platform Spawns
            
//            print("Spawn One Right Platform")
            
            newNodes = [platformRight, scoreNode]
            
            xPosRandomizer = CGFloat.random(in: -((view?.frame.midX)! * 0.5 + horizontalPlatformGap) ... (view?.frame.minX)! - horizontalPlatformGap)
            
        default: // 13...18 | Both Platforms Spawn
            
//            print("Spawned Both Left and Right Platform")
            
            newNodes = [platformLeft, platformRight, scoreNode]
            
            xPosRandomizer = CGFloat.random(in: -(frame.midX * 0.75 - wallWidth) ... (frame.midX * 0.8 - horizontalPlatformGap))
        }
        
//        print("currentStage post: \(currentStage)")
        
        for node in newNodes {
            platformGroup.insert(node)
        }
        
//        print("transitionCheck: \(transitionCheck)")
        
        getSpriteDetails(node: platformLeft)
        getSpriteDetails(node: platformRight)
        
        let minGapSize: CGFloat = (platformLeft.size.width * 0.35) // new correct ratio (from previous value of * 0.5) would be 0.375, however since platforms are now slightly bigger, * 0.35 is more similar to the old version
        
        platformLeft.position = CGPoint(x: xPosRandomizer, y: yPosition)
        platformRight.position = CGPoint(x: xPosRandomizer + platformLeft.size.width + horizontalPlatformGap, y: yPosition)
        
       if transitionCheck == true {
           
           // Calculate the total width of two platforms and the gap
           let totalWidth = platformLeft.size.width * 2 + minGapSize
           
           // Calculate the starting X position for the left platform
           let startX = (frame.width - totalWidth) / 2 + platformLeft.size.width / 2
            
           // Set the positions of the platforms
           platformLeft.position = CGPoint(x: startX, y: yPosition)
           platformRight.position = CGPoint(x: startX + platformLeft.size.width + minGapSize, y: yPosition)
           
//           print("tran height \(platformLeft.size.height)")
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
//                    print("timer ran!")
                }
            }
        }

        
        platformCount += 1

//        print("added platform: \(platformCount)")

        lastRandom = platformRandomizer
        
//        scene!.speed = 0.3
        
        timesSpawned += 1

        if timesSpawned > 3 { // this offsets the inital 3 platform spawns so speed doesn't increase in odd weird intervals
            increaseWorldSpeed += 1
            if increaseWorldSpeed % 10 == 0 {
                if scene!.speed < 1.75 {
                    scene!.speed = scene!.speed + 0.05
                    print("Game Speed: \(scene!.speed)")
                    print("Score \(score)")
                    if scene!.speed > 1.75 { // this doesn't seem to be called immediately but after one more interval
                        scene!.speed = 1.75
                        print("Game Speed - final speed: \(scene!.speed)")
                    }
                }
            }
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
//        UINode.addChild(leftControl)

        rightControl = SKSpriteNode(imageNamed: "right_control_button")
        rightControl.size = CGSize(width: 96, height: 96)
        rightControl.position = CGPoint(x: frame.maxX * 0.8, y: frame.maxY * 0.15)
        rightControl.alpha = 1
        rightControl.zPosition = 190
        rightControl.name = "rightControl"
        rightControl.isHidden = UserDefaults.standard.bool(forKey: "areControlsHidden")
//        UINode.addChild(rightControl)

        pauseButton = SKSpriteNode(imageNamed: "Pause Button")
        pauseButton.size = CGSize(width: 48, height: 48)
        pauseButton.position = CGPoint(x: frame.maxX - 50, y: frame.maxY - 50)
        pauseButton.zPosition = 250
        pauseButton.name = "pauseButton"
//        UINode.addChild(pauseButton)
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
            if gamesUntilAd <= 0 {
                admobDelegate.showInterstitial()
            }
            
            gameOver() // may want to be wary on how this is called because it is dependent on both gameState to == 1 and this call to be present as well
        }
    }
    
    
    func planeSoundRandomizer() {
        var randomNumber: Int
        
        repeat {
            randomNumber = Int.random(in: 1...5)
        } while randomNumber == planeTurnSoundState
        
        planeTurnSoundState = randomNumber
        
        let soundName = "plane_turn_\(planeTurnSoundState)"
        Audio.shared.playSFX(sound: soundName)
    }
    
    
    func showNotice() {
        
        noticeWindow = SKSpriteNode(imageNamed: "notice")
        noticeWindow.size = CGSize(width: noticeWindow.size.width * 0.65, height: noticeWindow.size.height * 0.65)
        noticeWindow.position = CGPoint(x: frame.midX, y: UINode.position.y + (frame.midY))
        noticeWindow.alpha = 0
        noticeWindow.zPosition = 800
        noticeWindow.name = "noticeWindow"
        addChild(noticeWindow)
        
        close = SKSpriteNode(imageNamed: "close")
        close.size = CGSize(width: close.size.width, height: close.size.height)
        close.position = CGPoint(x: noticeWindow.position.x, y: noticeWindow.position.y - (noticeWindow.size.height * 0.3))
        close.alpha = 0
        close.zPosition = 900
        close.name = "close"
        addChild(close)
        
        noticeWindow.setScale(0.25)
        
        let wait = SKAction.wait(forDuration: 0.35)
        let scaleUp = SKAction.scale(by: 4, duration: 0.2)
        let fadeAlphaIn = SKAction.fadeAlpha(to: 1, duration: 0.2)
        
        run(wait, completion: {
            self.noticeWindow.run(scaleUp)
            self.noticeWindow.run(fadeAlphaIn)
            
            self.close.run(SKAction.sequence([
                SKAction.wait(forDuration: 1.5),
                SKAction.fadeAlpha(to: 1, duration: 1.0)
            ]))
        })
        
        
        
    }
    
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   SCENE CHANGING METHODS
    // ------------------------------------------------------------------------------------------------------------------------------------------


    func restartGame() {
        
        Audio.shared.stopAllSounds()
        
        if let skView = self.view {

            guard let scene = GameScene(fileNamed: "GameScene") else { return }
            let transition = SKTransition.fade(withDuration: 1.5)
            scene.size = skView.frame.size

            scene.scaleMode = .aspectFill

            skView.presentScene(scene, transition: transition)
            pauseButton.removeFromParent()
            buttonLeft.removeFromParent()
            buttonRight.removeFromParent()
        }
    }


    func backToTitle() {
        
        Audio.shared.stopAllSounds()
        
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
        
        Audio.shared.stopAllSounds()
        
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
        scoreLabelShadow.alpha = 0

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
        
        Audio.shared.playSFX(sound: "plane_crash")
        
        print("plane destroyed")

        if let particles = SKEmitterNode(fileNamed: "DestroyPlane") {
            particles.position = plane.position
            particles.zPosition = 50
            addChild(particles)
        }

        leftControl.removeFromParent()
        rightControl.removeFromParent()

        Animations.shared.fadeAlphaOut(node: scoreLabel, duration: 0.5, waitTime: 0)
        Animations.shared.fadeAlphaOut(node: scoreLabelShadow, duration: 0.4, waitTime: 0)

        // SKAction.colorize doesn't work for some reason
        for node in backgroundArray {
            node.color = .darkGray
            node.colorBlendFactor = 0.65
        }
        
        for node in wallLeftArray {
            node.color = .darkGray
            node.colorBlendFactor = 0.65
        }
        
        for node in wallRightArray {
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
        continueLabel.alpha = 0
        continueLabel.zPosition = 70
        continueLabel.name = "continueLabel"
        addChild(continueLabel)
        
        let continueLabelShadow = SKLabelNode(fontNamed: "Paper Plane Font")
        continueLabelShadow.position = CGPoint(x: frame.midX, y: continueLabel.position.y - 4)
        continueLabelShadow.fontSize = 45
        continueLabelShadow.text = "Tap to continue"
        continueLabelShadow.fontColor = .black
        continueLabelShadow.alpha = 0
        continueLabelShadow.zPosition = 69
        continueLabelShadow.name = "continueLabelShadow"
        addChild(continueLabelShadow)

        _ = SKAction.fadeAlpha(to: 0.5, duration: 1)
        let fadeIn = SKAction.fadeIn(withDuration: 1.5)
        let wait = SKAction.wait(forDuration: 1.2)
        let fadeOut = SKAction.fadeOut(withDuration: 1.5)
        let fadeInFadeOut = SKAction.sequence([fadeIn, wait, fadeOut])
        let repeatForever = SKAction.repeatForever(fadeInFadeOut)

        continueLabel.run(repeatForever)
        continueLabelShadow.run(repeatForever)

        for node in nodeArray {
            if node.name != "clouds" {
                node.removeAllActions()
            }
        }
        
        plane.removeFromParent()
        gameState = 1

        pauseButton.removeFromParent()
        toggleNoClip.removeFromParent()
        
        isPlaneDestroyed = true
    }


    func gameOver() {
        
        guard gameState == 1 else { return }

        buttonLeft.removeFromParent()
        buttonRight.removeFromParent()
        
        if noClip == false {
            
            SavedData.shared.setScore(score)
            SavedData.shared.setTotalScore(score)
            SavedData.shared.setGamesPlayed()
        }

        let sortedScores = SavedData.shared.getScore()?.sorted(by: >).first
        let scoreAsString = sortedScores.map(String.init)

        childNode(withName: "continueLabel")?.removeFromParent()
        childNode(withName: "continueLabel")?.removeAllActions()
        childNode(withName: "continueLabelShadow")?.removeFromParent()
        childNode(withName: "continueLabelShadow")?.removeAllActions()
        childNode(withName: "gameOverLabel")?.removeFromParent()

        let gameOverLabel = SKSpriteNode(imageNamed: "game_over_label")
        gameOverLabel.size = CGSize(width: gameOverLabel.size.width * 1.5, height: gameOverLabel.size.height * 1.5)
        gameOverLabel.position = CGPoint(x: frame.midX, y: UINode.position.y + frame.maxY * 0.8)
        gameOverLabel.zPosition = 200
        gameOverLabel.alpha = 0
        gameOverLabel.name = "gameOverLabel"
        addChild(gameOverLabel)
        gameOverUIContainer.append(gameOverLabel)

        gameOverWindow = SKSpriteNode(imageNamed: "game_over_window")
        gameOverWindow.size = CGSize(width: view!.frame.size.width * 0.75, height: view!.frame.size.width * 0.75)
        gameOverWindow.position = CGPoint(x: frame.midX, y: gameOverLabel.position.y - (gameOverWindow.size.height / 1.4))
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
        
        homeButton.size = CGSize(width: 80, height: 80)
        homeButton.position = CGPoint(x: gameOverWindow.frame.midX, y: gameOverWindow.frame.minY - 70)
        homeButton.zPosition = 210
        homeButton.alpha = 0
        homeButton.name = "homeButton"
        addChild(homeButton)
        gameOverUIContainer.append(homeButton)

        levelSelectButton.size = CGSize(width: 80, height: 80)
        levelSelectButton.position = CGPoint(x: gameOverWindow.frame.maxX - (levelSelectButton.frame.width / 2), y: gameOverWindow.frame.minY - 70)
        levelSelectButton.alpha = 0
        levelSelectButton.zPosition = 210
        levelSelectButton.name = "levelSelectButton"
        addChild(levelSelectButton)
        gameOverUIContainer.append(levelSelectButton)

        

        bestScore = SKLabelNode(fontNamed: "Paper Plane Font")
        bestScore.text = scoreAsString
        bestScore.alpha = 0
        bestScore.zPosition = 210
        bestScore.fontSize = 60
        bestScore.fontColor = SKColor.white
        bestScore.position = CGPoint(x: gameOverWindow.frame.midX, y: gameOverWindow.position.y - gameOverWindow.size.height * 0.2)
        bestScore.name = "bestScore"
        addChild(bestScore)
        gameOverUIContainer.append(bestScore)
        
        bestScoreShadow = SKLabelNode(fontNamed: "Paper Plane Font")
        bestScoreShadow.text = scoreAsString
        bestScoreShadow.alpha = 0
        bestScoreShadow.zPosition = 205
        bestScoreShadow.fontSize = 60
        bestScoreShadow.fontColor = SKColor.black
        bestScoreShadow.position = CGPoint(x: bestScore.position.x, y: bestScore.position.y - 5)
        bestScoreShadow.name = "bestScoreShadow"
        addChild(bestScoreShadow)
        gameOverUIContainer.append(bestScoreShadow)
        
        let buttonBarrier = SKSpriteNode()
        buttonBarrier.size = CGSize(width: frame.size.width, height: restartButton.size.height * 1.1)
        buttonBarrier.position = CGPoint(x: frame.midX, y: restartButton.position.y)
        buttonBarrier.color = .clear
        buttonBarrier.alpha = 1
        buttonBarrier.zPosition = 250
        buttonBarrier.name = "buttonBarrier"
        addChild(buttonBarrier)

        scene!.speed = 1.00

        scoreLabel.position = CGPoint(x: gameOverWindow.frame.midX, y: (gameOverWindow.position.y + gameOverWindow.size.height * 0.2675) - UINode.position.y)  // the odd repositioning of scoreLabel and why it needs to UINode.position.y needs to be subtracted from it is because scoreLabel is initially added as a child of UINode
        scoreLabelShadow.position = CGPoint(x: scoreLabel.position.x, y: scoreLabel.position.y - 5)
        
//        print("go pos \(gameOverWindow.position.y)")
//        print("best score: \(bestScore.position.y)")
//        print("score score: \(scoreLabel.position.y)")

        for node in gameOverUIContainer {
            Animations.shared.fadeAlphaIn(node: node, duration: 0.75, waitTime: 0)
        }

        Animations.shared.fadeAlphaIn(node: gameOverLabel, duration: 0.75, waitTime: 0)
        Animations.shared.fadeAlphaIn(node: scoreLabel, duration: 0.75, waitTime: 0)
        Animations.shared.fadeAlphaIn(node: scoreLabelShadow, duration: 0.75, waitTime: 0)
        
        let wait = SKAction.wait(forDuration: 1)
        let enableButtons = SKAction.run {
            buttonBarrier.removeFromParent()
        }
        let seq = SKAction.sequence([wait, enableButtons])
        
        run(seq)

        for node in nodeArray {
            if node.name != "clouds" {
                node.isPaused = true
            }
        }
        
        if score >= 30 {
            if adsRemoved == true || !(gamesUntilAd <= 0) {
                StoreKitHelper.displayStoreKit()
            }
        }
    }
    
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    //   UPDATE, COLLISIONS, & TOUCHES HANDLING
    // ------------------------------------------------------------------------------------------------------------------------------------------
    
    
    override func update(_ currentTime: TimeInterval) {

        lastBackgroundPosition = backgroundArray.last?.position.y // Doesn't work when placed in createBackground() for some reason despite the logic feeling right
        lastWallPosition = wallLeftArray.last?.position.y
        
        planeCoords.text = "\((Int)(plane.position.y))"
//        print("Plane PosY \((Int)(plane.position.y))")


        playerCamera.position.y = plane.position.y - (frame.midY / 3)
        UINode.position.y = playerCamera.position.y - (frame.size.height / 2)
        sky.position.y = playerCamera.position.y
        
        for i in cloudPieces {
            i.position.y = playerCamera.position.y - frame.midY
        }
        
//        playerCamera.setScale(2)
        
        
//        print("platformCount \(platformGroup.count)")

        // may want to change the static number to a multiple of transitionPlatform.size().height to avoid potential scaling issues. 480 = transitionPlatform.size().height * 6; 720 = transitionPlatform.size().height. These numbers line up perfectly with mid-sections of the platforms. 600 or trasitionPlatform.size().height * 7.5 is perfectly in the middle between two platforms.
        
        // transitionPlatform.size().height * 3/6/9/... (240/480/720/...) is perfectly in line with platforms; * 1.5/4.5/7.5/... (120/360/600/...) is perfectly between platforms
        
        visualPlatformTrigger.size = CGSize(width: frame.size.width, height: 10)
        visualPlatformTrigger.position = CGPoint(x: frame.midX, y: (platformArray.last?.position.y)! + 480)
        
        if (platformArray.last?.position.y)! + 480 > plane.position.y { // might need to change the static value on this. At slow-mo speeds, you can see transitionPlatform spawn, but at normal speeds, it's nearly unnoticeable
            self.createPlatforms()
        }
        
        if (backgroundArray.last?.position.y)! + 480 > plane.position.y {
            self.createBackground()
        }
        
        if (wallLeftArray.last?.position.y)! + 480 > plane.position.y {
            self.createWalls()
        }
        
        // Without walls or extra safety to prevent plane from going beyong walls, use this. Most like obsolete now that there are physical walls present
        
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
            
//            print("allContactedBodies \([plane.physicsBody?.allContactedBodies()])")

//            print("Score Collision Point: \(positionAtScore)")
            
            if shouldDetectScore == true {
                score += 1
                shouldDetectScore = false
            }
            
            let wait = SKAction.wait(forDuration: 0.35)
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
            
//            print("contact A: \(contact.bodyA.node), contact B: \(contact.bodyB.node)")
            
            guard isPlaneDestroyed == false else { return }
            
            destroyPlane()
        }
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
//            print("touchedNode: \(touchedNode.name)")

            let cycle = SKAction.run {
                self.changeMode(node: touchedNode as! SKSpriteNode)
            }
            let delay = SKAction.wait(forDuration: 0.095)
            let seq = SKAction.sequence([cycle, delay])
            let repeatAction = SKAction.repeatForever(seq)

            
            if gameHasStarted == true {
                if touchedNode.name == "buttonLeft" {
                    isButtonTouched = "buttonLeft"
                    buttonLeft.run(repeatAction, withKey: "cycle")
                    if gameState != 1 {
                        planeSoundRandomizer()
                    }
                }
            }
            
            if gameHasStarted == true {
                if touchedNode.name == "buttonRight" {
                    isButtonTouched = "buttonRight"
                    buttonRight.run(repeatAction, withKey: "cycle")
                    if gameState != 1 {
                        planeSoundRandomizer()
                    }
                }
            }

            if touchedNode.name == "pauseButton" {
                Animations.shared.shrink(node: pauseButton)
                isButtonTouched = "pauseButton"
            }

            if touchedNode.name == "homeButton" {
                Audio.shared.playSFX(sound: "button_click")
                Animations.shared.shrink(node: homeButton)
                isButtonTouched = "homeButton"
            }

            if touchedNode.name == "restartButton" {
                Audio.shared.playSFX(sound: "button_click")
                Animations.shared.shrink(node: restartButton)
                isButtonTouched = "restartButton"
            }

            if touchedNode.name == "levelSelectButton" {
                Audio.shared.playSFX(sound: "button_click")
                Animations.shared.shrink(node: levelSelectButton)
                isButtonTouched = "levelSelectButton"
            }

            if touchedNode.name == "noClip" {
                Animations.shared.shrink(node: toggleNoClip)
                isButtonTouched = "noClip"
            }

            if touchedNode.name == "gotIt" {
                Audio.shared.playSFX(sound: "button_click")
                Animations.shared.shrink(node: gotIt)
                isButtonTouched = "gotIt"
            }
            
            if touchedNode.name == "dontShowAgain" {
                Audio.shared.playSFX(sound: "button_click")
                Animations.shared.shrink(node: dontShowAgain)
                isButtonTouched = "dontShowAgain"
            }
            
            if touchedNode.name == "close" {
                Audio.shared.playSFX(sound: "button_click")
                Animations.shared.shrink(node: close)
                isButtonTouched = "close"
            }
        }
    }


    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
//            print("touchedNode: \(touchedNode.name)")

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
                let expand = SKAction.run {
                    Animations.shared.expand(node: self.homeButton)
                }
                let wait = SKAction.wait(forDuration: 0.175)
                let sequence = SKAction.sequence([expand, wait])
                
                run(sequence, completion: { self.backToTitle() })
                
            } else if touchedNode.name != "" && isButtonTouched == "homeButton" {
                Animations.shared.expand(node: homeButton)
            }
            

            if touchedNode.name == "restartButton" {
                let expand = SKAction.run {
                    Animations.shared.expand(node: self.restartButton)
                }
                let wait = SKAction.wait(forDuration: 0.175)
                let sequence = SKAction.sequence([expand, wait])
                
                run(sequence, completion: { self.restartGame() })
                
            } else if touchedNode.name != "" && isButtonTouched == "restartButton" {
                Animations.shared.expand(node: restartButton)
            }
            

            if touchedNode.name == "levelSelectButton" {
                let expand = SKAction.run {
                    Animations.shared.expand(node: self.levelSelectButton)
                }
                let wait = SKAction.wait(forDuration: 0.175)
                let sequence = SKAction.sequence([expand, wait])
                
                run(sequence, completion: { self.worldSelectMenu() })
                
            } else if touchedNode.name != "" && isButtonTouched == "levelSelectButton" {
                Animations.shared.expand(node: levelSelectButton)
            }
            

            if touchedNode.name == "noClip" {
                noClip = !noClip
            }
            

            // Dismisses tutorial window
            
            if touchedNode.name == "gotIt" || touchedNode.name == "dontShowAgain" {
                if touchedNode.name == "gotIt" {
                    Animations.shared.expand(node: gotIt)
                } else if touchedNode.name == "dontShowAgain" {
                    Animations.shared.expand(node: dontShowAgain)
                }

                let fadeOut = SKAction.run {
                    Animations.shared.fadeAlphaOut(node: self.howToPlay, duration: 0.25, waitTime: 0)
                    Animations.shared.fadeAlphaOut(node: self.gotIt, duration: 0.20, waitTime: 0)
                    Animations.shared.fadeAlphaOut(node: self.dontShowAgain, duration: 0.20, waitTime: 0)
                }

                let wait = SKAction.wait(forDuration: 0.25)

                let remove = SKAction.run {
                    self.childNode(withName: "howToPlay")?.removeFromParent()
                    self.childNode(withName: "gotIt")?.removeFromParent()
                    self.childNode(withName: "dontShowAgain")?.removeFromParent()
                }

                let seq = SKAction.sequence([fadeOut, wait, remove])
                run(seq)

                if touchedNode.name == "gotIt" {
                    gotIt.isUserInteractionEnabled = true
                    run(SKAction.wait(forDuration: 0.75), completion: { self.countdown() })
                } else if touchedNode.name == "dontShowAgain" {
                    dontShowAgain.isUserInteractionEnabled = true
                    showNotice()
                }
                
                

            } else if touchedNode.name != "" && isButtonTouched == "gotIt" || isButtonTouched == "dontShowAgain" {
                if isButtonTouched == "gotIt"{
                    Animations.shared.expand(node: gotIt)
                } else if isButtonTouched == "dontShowAgain" {
                    Animations.shared.expand(node: dontShowAgain)
                }
            }
            
            
            if touchedNode.name == "close" {
                let expand = SKAction.run {
                    Animations.shared.expand(node: self.close)
                }

                let fadeOut = SKAction.run {
                    Animations.shared.fadeAlphaOut(node: self.noticeWindow, duration: 0.25, waitTime: 0)
                    Animations.shared.fadeAlphaOut(node: self.close, duration: 0.20, waitTime: 0)
                }

                let wait = SKAction.wait(forDuration: 0.25)

                let remove = SKAction.run {
                    self.childNode(withName: "noticeWindow")?.removeFromParent()
                    self.childNode(withName: "close")?.removeFromParent()
                }

                let seq = SKAction.sequence([expand, wait, fadeOut, wait, remove])
                run(seq)

                firstTimePlaying = false
                SavedSettings.shared.setTutorialData()
                
                run(SKAction.wait(forDuration: 0.75), completion: { self.countdown() })
                
//                firstTimePlaying = true
//                UserDefaults.standard.set(firstTimePlaying, forKey: "firstTimePlaying")
                
                gotIt.isUserInteractionEnabled = true

            } else if touchedNode.name != "" && isButtonTouched == "close" {
                Animations.shared.expand(node: close)
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
                buttonRight.removeAction(forKey: "cycle")
            }
        }
    }
}
