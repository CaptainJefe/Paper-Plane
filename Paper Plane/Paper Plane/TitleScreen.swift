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
import StoreKit

var isFirstLaunch: Bool = true

class TitleScreen: SKScene {
  
  var howToPlay: SKSpriteNode!
  var close: SKSpriteNode!
  
  var logo = SKSpriteNode(imageNamed: "Paper Plane Logo")
  var background: SKSpriteNode!
  
  var playButton = SKSpriteNode(imageNamed: "play_button_1")
  var optionsButton = SKSpriteNode(imageNamed: "options_button_1")
  var highScoresButton = SKSpriteNode(imageNamed: "high_scores_button_1")
  var statsButton = SKSpriteNode(imageNamed: "options_button_1")
  var removeAdsButton = SKSpriteNode(imageNamed: "remove_ads")
  var menuSeparator: SKSpriteNode!
  
  var musicButton = SKSpriteNode(imageNamed: "")
  var soundButton = SKSpriteNode(imageNamed: "")
  var controlsButton = SKSpriteNode(imageNamed: "")
  var tutorialButton: SKSpriteNode!
  var restorePurchases: SKSpriteNode!
  
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
  var separator: SKSpriteNode!
  
  var labelContainer = [SKLabelNode]()
  var mainUIContainer = [SKNode]()
  var highScoresUIContainer = [SKNode]()
  var optionsUIContainer = [SKNode]()
  var statsUIContainer = [SKNode]()
  
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
  
  let scaleFactor = (UIScreen.main.bounds.size.height / 800)
  
  var appVersion: String!
  
  static var shared = TitleScreen()
  
  private var inAppPurchases = InAppPurchases()
  
  
  override func didMove(to view: SKView) {
    
    //        if selectedLanguage == nil {
    //            languageMenu()
    //        } else {
    //            createMainMenu()
    //            createButtons()
    //            startUp()
    //        }
    
    createMainMenu()
    createButtons()
    startUp()
    
    appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    TitleScreen.shared = self
    
    print("\(SavedData.shared.getTotalScore())")
  }
  
  
  // ------------------------------------------------------------------------------------------------------------------------------------------
  //   MAIN MENU
  // ------------------------------------------------------------------------------------------------------------------------------------------
  
  
  func startUp() {
    
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
      
      let wait = SKAction.wait(forDuration: 0.35)
      let showBanner = SKAction.run {
        GameViewController.shared.showBannerAds()
      }
      let seq = SKAction.sequence([wait, showBanner])
      
      run(seq)
      
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
    background = SKSpriteNode(imageNamed: "title_screen_background")
    background.size = CGSize(width: frame.size.width, height: frame.size.width * 2.5)
    background.position = CGPoint(x: view!.center.x, y: view!.frame.maxY - background.frame.maxY)
    background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    background.zPosition = -10
    background.alpha = 1
    addChild(background)
    mainUIContainer.append(logo)
    
    logo.size = CGSize(width: logo.size.width * 0.75, height: logo.size.height * 0.75) // was (logo.size._ * 0.8)
    logo.position = CGPoint(x: frame.midX, y: frame.maxY / 1.4)
    logo.alpha = 0
    addChild(logo)
    
    //        print("center \(view!.center.y)")
    //        print("view diff \(view!.frame.maxY - background.frame.maxY)") // values change if written above background.position
    //        print("background.frame.maxY\(background.frame.maxY)")
    //        print("view.frame.maxY \(view!.frame.maxY)")
  }
  
  
  func createButtons() {
    let UIButtonSize = CGSize(width: playButton.size.width * 1.5, height: playButton.size.height * 1.5)
    
    playButton.size = UIButtonSize // non number size is CGSize(width: frame.size.width / 2, height: frame.size.width / 4)
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
    
    
    statsButton.size = UIButtonSize
    statsButton.position = CGPoint(x: playButton.position.x, y: optionsButton.position.y - 70)
    statsButton.colorBlendFactor = 0
    statsButton.zPosition = 10
    statsButton.alpha = 0
    statsButton.name = "Stats"
    addChild(statsButton)
    mainUIContainer.append(statsButton)
    
    
    removeAdsButton.size = CGSize(width: removeAdsButton.size.width * 1.5, height: removeAdsButton.size.height * 1.5)
    removeAdsButton.position = CGPoint(x: playButton.position.x, y: statsButton.position.y - 70)
    removeAdsButton.colorBlendFactor = 0
    removeAdsButton.zPosition = 10
    removeAdsButton.alpha = 0
    removeAdsButton.name = "remove_ads"
    mainUIContainer.append(removeAdsButton)
    
    if adsRemoved == false {
      addChild(removeAdsButton)
    }
    
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

  
  // ------------------------------------------------------------------------------------------------------------------------------------------
  //   OTHER MENUS
  // ------------------------------------------------------------------------------------------------------------------------------------------
  
  
  func createHighScores() {
      highScoresLabel = SKSpriteNode(imageNamed: "high_scores_label")
      highScoresLabel.position = CGPoint(x: frame.midX, y: frame.maxY * 0.88)
      highScoresLabel.size = CGSize(width: highScoresLabel.size.width * 1.2,
                                    height: highScoresLabel.size.height * 1.2)
      highScoresLabel.zPosition = 80
      highScoresLabel.alpha = 0
      addChild(highScoresLabel)
      highScoresUIContainer.append(highScoresLabel)
      
      
      // --- SCORE PREP ---
      let sortedScores = SavedData.shared.getScore() ?? []
      
      // Deduplicate, remove 0, and sort high → low
      let uniqueScores = Array(Set(sortedScores)).filter { $0 != 0 }.sorted(by: >)
      
      // Grab top 10
      var displayScores = uniqueScores.prefix(10).map(String.init)
      
      // Pad with "..." if fewer than 10
      if displayScores.count < 10 {
          displayScores.append(contentsOf: repeatElement("...", count: 10 - displayScores.count))
      }
      
      print("Raw scores:", sortedScores)
      print("Unique scores:", uniqueScores)
      print("Display scores:", displayScores)
      
      
      // --- UI RENDERING ---
      var counter: CGFloat = 0
      var counter2: Int = 0
      
      let colorArray: [UIColor] = [
          SKColor(hex: 0xFFD700),
          SKColor(hex: 0xEBECEB),
          SKColor(hex: 0xCE8946),
          .white, .white, .white, .white, .white, .white, .white
      ]
      
      for (index, highscore) in displayScores.enumerated() {
          let hsLabel = createLabelWithShadow(
              text: highscore,
              fontName: "Paper Plane Font",
              fontSize: 40 * scaleFactor,
              fontColor: .white,
              shadowColor: .black,
              position: CGPoint(x: self.frame.maxX * 0.8,
                                y: ((frame.maxY) + (counter * -75 * scaleFactor)) / 1.25),
              zPosiion: 160,
              alpha: 0,
              name: "highScoreLabel"
          )
        
          addChild(hsLabel.main)
          addChild(hsLabel.shadow)
        
          highScoresUIContainer.append(hsLabel.main)
          highScoresUIContainer.append(hsLabel.shadow)
          
          let hsNumberLabel = createLabelWithShadow(
              text: "\(index + 1).",
              fontName: "Paper Plane Font",
              fontSize: 40 * scaleFactor,
              fontColor: colorArray[index],
              shadowColor: .black,
              position: CGPoint(x: self.frame.maxX * 0.2,
                                y: hsLabel.main.position.y),
              zPosiion: 160,
              alpha: 0,
              name: "highScoresNumberLabel"
          )
        
          addChild(hsNumberLabel.main)
          addChild(hsNumberLabel.shadow)
        
          highScoresUIContainer.append(hsNumberLabel.main)
          highScoresUIContainer.append(hsNumberLabel.shadow)
        
        
          
          separator = SKSpriteNode(imageNamed: "separator")
          separator.position = CGPoint(x: self.frame.midX,
                                       y: hsLabel.main.position.y - 40 * scaleFactor)
          separator.size = CGSize(width: frame.width / 1.2,
                                  height: separator.size.height * scaleFactor)
          separator.alpha = 0
          separator.colorBlendFactor = 0.25
          addChild(separator)
          highScoresUIContainer.append(separator)
          
          counter += 1
          counter2 += 1
      }
      
      showHighScoresMenu()
  }
  
  
  // The first time the high scores are spawned, they spawn and are timed fine, but each time after the first time, the labels and the seperators are staggered in timing from the top high scores label and increases time you call high scores menu back. It's like timeIncrease is not clearing and compounding on it's previous value.
  // It looks like the time increase was from an ever increasing in size of the array, which in turn likely was iterating over elements (that were no longer being used, but was at the first listing of the index), so each time the active elements needed be called, all of the old entries were before it. .removeAll() on the array has fixed the issue, however the close button is not timing like it used to.
  
  func showHighScoresMenu() {
    
    lastMenuOpened = "HighScores"
    
    closeButton.size = CGSize(width: 48, height: 48)
    closeButton.alpha = 0
    closeButton.position = CGPoint(x: frame.maxX * 0.9, y: frame.maxY * 0.95)
    closeButton.zPosition = 80
    closeButton.name = "Close Button"
    addChild(closeButton)
    highScoresUIContainer.append(closeButton)
    
    var timeIncrease: TimeInterval = 0.0
    
    let fadeOutMainUI = SKAction.run { [unowned self] in
      for node in self.mainUIContainer { Animations.shared.fadeAlphaOut(node: node, duration: 0.25, waitTime: 0) }
    }
    
    let wait = SKAction.wait(forDuration: 0.3)
    
    let fadeInScores = SKAction.run { [unowned self] in
      for node in self.highScoresUIContainer {
        Animations.shared.fadeAlphaIn(node: node, duration: 0.4, waitTime: 0.15 + timeIncrease)
        timeIncrease += 0.0075 // original is 0.025
      }
    }
    
    let sequence = SKAction.sequence([fadeOutMainUI, wait, fadeInScores])
    
    run(sequence)
    Animations.shared.colorize(node: background, color: .darkGray, colorBlendFactor: 0.75, duration: 0.6)
    
    GameViewController.shared.hideBannerAds()
  }
  
  
  func createOptions() {
    
    var soundButtonTexture: String
    
    if UserDefaults.standard.bool(forKey: "isSoundMuted") == false {
      soundButtonTexture = "sound_button_on"
    } else {
      soundButtonTexture = "sound_button_off"
    }
    
    //        CGPoint(x: frame.midX, y: musicButton.position.y + (musicButton.size.height / 6))
    
    soundButton = SKSpriteNode(imageNamed: soundButtonTexture)
    soundButton.size = CGSize(width: soundButton.size.width * 1.5, height: soundButton.size.height * 1.5)
    soundButton.alpha = 0
    soundButton.position = CGPoint(x: frame.midX, y: frame.maxY * 0.6)
    soundButton.zPosition = 55
    soundButton.name = "sound_button"
    addChild(soundButton)
    optionsUIContainer.append(soundButton)
    
    tutorialButton = SKSpriteNode(imageNamed: "tutorial_button")
    tutorialButton.size = CGSize(width: tutorialButton.size.width * 1.5, height: tutorialButton.size.height * 1.5)
    tutorialButton.alpha = 0
    tutorialButton.position = CGPoint(x: frame.midX, y: soundButton.position.y - 90)
    tutorialButton.zPosition = 55
    tutorialButton.name = "tutorial_button"
    addChild(tutorialButton)
    optionsUIContainer.append(tutorialButton)
    
    restorePurchases = SKSpriteNode(imageNamed: "restore_purchases")
    restorePurchases.size = CGSize(width: restorePurchases.size.width * 1.5, height: restorePurchases.size.height * 1.5)
    restorePurchases.alpha = 0
    restorePurchases.position = CGPoint(x: frame.midX, y: tutorialButton.position.y - 90)
    restorePurchases.zPosition = 55
    restorePurchases.name = "restore_purchases"
    addChild(restorePurchases)
    optionsUIContainer.append(restorePurchases)
    
    for i in 0...2 {
      
      separator = SKSpriteNode(imageNamed: "separator")
      separator.position = CGPoint(x: self.frame.midX, y: (soundButton.position.y - 45) - CGFloat((i * 90)))
      separator.size = CGSize(width: frame.width / 1.5, height: separator.size.height)
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
    
    GameViewController.shared.hideBannerAds()
  }
  
  
  func createStats() {
    if let scores = SavedData.shared.getScore(), !scores.isEmpty {
      let highScoresCount = scores.count
      let highScoresTotals = scores.reduce(0, +)
      let averageScore = highScoresTotals / highScoresCount

      print("games played \(highScoresCount)")
      print("hstotals \(highScoresTotals)")
      print ("average score \(averageScore)")
    } else {
      print("No scores found")
    }
    
    // I might need to double the labels. Where constant label suffixes change there text labels to just labels, and the original ones get created alongside for values themselves. Check with AI to see if there is a more elegant/succinct way to handle this, but this is the simple way.
    
    let totalGamesPlayed = UserDefaults.standard.integer(forKey: "gamesPlayed")
    let highestScore = SavedData.shared.getScore()?.max() ?? 0
    let averageScoreLast20 = ""
    let gamesPlayedCastle = "" // add a counter to level selected to track this / double check, didn't see it at first when I looked on worldselect, gamescene, or saveddata
    let gamesPlayedChasm = ""
    let gamesPlayedSilo = ""
    let favoriteLevel = ""
    let totalPlatformsPassed = ""
    
    let statsData: [(title: String, value: String)] = [
      ("Total Games", "\(totalGamesPlayed)"),
      ("Highest Score", "\(highestScore)"),
      ("Avg Score (Last 20)", "\(averageScoreLast20)"),
      ("Games (Castle)", "\(gamesPlayedCastle)"),
      ("Games (Chasm)", "\(gamesPlayedChasm)"),
      ("Games (Silo)", "\(gamesPlayedSilo)"),
      ("Favorite Level", "\(favoriteLevel)"),
      ("Platforms Passed", "\(totalPlatformsPassed)")
    ]
    
    
    let startY = frame.maxY * 0.75
    let rowHeight: CGFloat = 50 * scaleFactor
    let leftMargin = frame.midX - (160 * scaleFactor)
    let rightMargin = frame.midX + (160 * scaleFactor)
    
    for (index, data) in statsData.enumerated() {
        let yPosition = startY - (CGFloat(index) * rowHeight)
        
        let titleLabel = createLabelWithShadow(
            text: data.title,
            fontName: "Paper Plane Font",
            fontSize: 24 * scaleFactor,
            fontColor: .white,
            shadowColor: .black,
            position: CGPoint(x: leftMargin, y: yPosition),
            zPosiion: 160,
            alpha: 0,
            name: "stat_title_\(index)"
        )
      
        titleLabel.main.horizontalAlignmentMode = .left
        titleLabel.shadow.horizontalAlignmentMode = .left
        
        addChild(titleLabel.main)
        addChild(titleLabel.shadow)
        statsUIContainer.append(titleLabel.main)
        statsUIContainer.append(titleLabel.shadow)
        
        let valueLabel = createLabelWithShadow(
            text: data.value,
            fontName: "Paper Plane Font",
            fontSize: 24 * scaleFactor, // Values often look better slightly distinct
            fontColor: .yellow,         // Optional: Make values pop with color
            shadowColor: .black,
            position: CGPoint(x: rightMargin, y: yPosition),
            zPosiion: 160,
            alpha: 0,
            name: "stat_value_\(index)"
        )
      
        valueLabel.main.horizontalAlignmentMode = .right
        valueLabel.shadow.horizontalAlignmentMode = .right
        
        addChild(valueLabel.main)
        addChild(valueLabel.shadow)
        statsUIContainer.append(valueLabel.main)
        statsUIContainer.append(valueLabel.shadow)
        
        if index < statsData.count - 1 {
            let separator = SKSpriteNode(imageNamed: "separator")
          separator.position = CGPoint(x: frame.midX, y: yPosition - (rowHeight / 1.5))
            separator.size = CGSize(width: frame.width * 0.9, height: 2) // Adjust height as needed
            separator.alpha = 0
            separator.zPosition = 160
            addChild(separator)
            statsUIContainer.append(separator)
        }
    }
    
    print("highestScore \(highestScore)")
    
    showStatsMenu()
  }
  
  
  func showStatsMenu() {
    lastMenuOpened = "Stats"
    
    closeButton.size = CGSize(width: 48, height: 48)
    closeButton.alpha = 0
    closeButton.position = CGPoint(x: frame.maxX * 0.90, y: frame.maxY * 0.95)
    closeButton.zPosition = 80
    closeButton.name = "Close Button"
    addChild(closeButton)
    statsUIContainer.append(closeButton)
    
    let fadeOutMainUI = SKAction.run { [unowned self] in
      for node in self.mainUIContainer { Animations.shared.fadeAlphaOut(node: node, duration: 0.25, waitTime: 0) }
    }
    
    let wait = SKAction.wait(forDuration: 0.3)
    
    let fadeInStats = SKAction.run { [unowned self] in
      for node in self.statsUIContainer {
        Animations.shared.fadeAlphaIn(node: node, duration: 0.4, waitTime: 0)
      }
    }
    
    let sequence = SKAction.sequence([fadeOutMainUI, wait, fadeInStats])
    let dimBG = SKAction.colorize(with: .darkGray, colorBlendFactor: 0.75, duration: 0.6)
    
    run(sequence)
    background.run(dimBG)
    
    GameViewController.shared.hideBannerAds()
  }
  
  
  func instructionsMenu() {
    
    howToPlay = SKSpriteNode(imageNamed: "how_to0")
    howToPlay.size = CGSize(width: howToPlay.size.width * 0.65, height: howToPlay.size.height * 0.65)
    howToPlay.position = CGPoint(x: frame.midX, y: frame.midY)
    howToPlay.alpha = 0
    howToPlay.zPosition = 800
    howToPlay.name = "howToPlay"
    addChild(howToPlay)
    
    close = SKSpriteNode(imageNamed: "close")
    close.size = CGSize(width: close.size.width * 1.25, height: close.size.height * 1.25)
    close.position = CGPoint(x: howToPlay.frame.midX, y: howToPlay.position.y - (howToPlay.size.height * 0.31))
    close.alpha = 0
    close.zPosition = 810
    close.name = "close"
    addChild(close)
    
    
    let fadeOutOptions = SKAction.run { [unowned self] in
      for node in optionsUIContainer {
        Animations.shared.fadeAlphaOut(node: node, duration: 0.25, waitTime: 0)
      }
    }
    
    let wait = SKAction.wait(forDuration: 0.3)
    
    let fadeInIntructions = SKAction.run { [unowned self] in
      Animations.shared.fadeAlphaIn(node: self.howToPlay, duration: 0.4, waitTime: 0)
      Animations.shared.fadeAlphaIn(node: self.close, duration: 0.4, waitTime: 0)
      Animations.shared.animateIntructions(node: self.howToPlay)
    }
    
    let sequence = SKAction.sequence([fadeOutOptions, wait, fadeInIntructions])
    
    run(sequence)
  }
  
  
  func closeMenu() {
    
    switch lastMenuOpened {
    case "HighScores":
      
      let fadeOutScores = SKAction.run { [unowned self] in
        for nodes in highScoresUIContainer { Animations.shared.fadeAlphaOut(node: nodes, duration: 0.25, waitTime: 0) }
      }
      
      let wait = SKAction.wait(forDuration: 0.4)
      
      let fadeInMainMenu = SKAction.run { [unowned self] in
        for node in mainUIContainer { Animations.shared.fadeAlphaIn(node: node, duration: 0.35, waitTime: 0) }
      }
      
      let remove = SKAction.run { [unowned self] in
        for node in self.highScoresUIContainer {
          node.removeAllActions()
          node.removeFromParent()
        }
        
        closeButton.removeFromParent()
        highScoresUIContainer.removeAll()
      }
      
      let sequence = SKAction.sequence([fadeOutScores, wait, fadeInMainMenu, remove])
      let undimBG = SKAction.colorize(with: .darkGray, colorBlendFactor: 0.0, duration: 0.6)
      
      run(sequence)
      background.run(undimBG)
      
    case "Options":
      
      let fadeOutOptions = SKAction.run { [unowned self] in
        for nodes in optionsUIContainer { Animations.shared.fadeAlphaOut(node: nodes, duration: 0.25, waitTime: 0) }
      }
      
      let wait = SKAction.wait(forDuration: 0.4)
      
      let fadeInMainMenu = SKAction.run { [unowned self] in
        for node in mainUIContainer { Animations.shared.fadeAlphaIn(node: node, duration: 0.35, waitTime: 0) }
      }
      
      let remove = SKAction.run { [unowned self] in
        for node in self.optionsUIContainer {
          node.removeAllActions()
          node.removeFromParent()
        }
        
        closeButton.removeFromParent()
        optionsUIContainer.removeAll()
      }
      
      let sequence = SKAction.sequence([fadeOutOptions, wait, fadeInMainMenu, remove])
      let undimBG = SKAction.colorize(with: .darkGray, colorBlendFactor: 0.0, duration: 0.6)
      
      run(sequence)
      background.run(undimBG)
      
      //            Animations.shared.rotateCCW(node: optionsButton)
      
    case "Stats":
      
      let fadeOutStats = SKAction.run { [unowned self] in
        for nodes in statsUIContainer { Animations.shared.fadeAlphaOut(node: nodes, duration: 0.25, waitTime: 0) }
      }
      
      let wait = SKAction.wait(forDuration: 0.4)
      
      let fadeInMainMenu = SKAction.run { [unowned self] in
        for node in mainUIContainer { Animations.shared.fadeAlphaIn(node: node, duration: 0.35, waitTime: 0) }
      }
      
      let remove = SKAction.run { [unowned self] in
        for node in self.statsUIContainer {
          node.removeAllActions()
          node.removeFromParent()
        }
        
        closeButton.removeFromParent()
        statsUIContainer.removeAll()
      }
      
      let sequence = SKAction.sequence([fadeOutStats, wait, fadeInMainMenu, remove])
      let undimBG = SKAction.colorize(with: .darkGray, colorBlendFactor: 0.0, duration: 0.6)
      
      run(sequence)
      background.run(undimBG)
      
    default:
      break
    }
    
    GameViewController.shared.showBannerAds()
  }
  
  
  // ------------------------------------------------------------------------------------------------------------------------------------------
  //   TOUCHES HANDLING
  // ------------------------------------------------------------------------------------------------------------------------------------------
  
  
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
        Audio.shared.playSFX(sound: "button_click")
        Animations.shared.shrink(node: playButton)
        //                Animations.shared.animateTexture(node: playButton, texture: [playButtonTexture2, playButtonTexture3])
        isButtonTouched = "Play"
      }
      
      if touchedNode.name == "High Scores" {
        Audio.shared.playSFX(sound: "button_click")
        Animations.shared.shrink(node: highScoresButton)
        //                Animations.shared.animateTexture(node: highScoresButton, texture: [highScoresTexture2, highScoresTexture3])
        isButtonTouched = "High Scores"
      }
      
      if touchedNode.name == "Options" {
        Audio.shared.playSFX(sound: "button_click")
        Animations.shared.shrink(node: optionsButton)
        //                Animations.shared.animateTexture(node: optionsButton, texture: [optionsTexture2, optionsTexture3])
        isButtonTouched = "Options"
      }
      
      if touchedNode.name == "Stats" {
        Audio.shared.playSFX(sound: "button_click")
        Animations.shared.shrink(node: statsButton)
        isButtonTouched = "Stats"
      }
      
      if touchedNode.name == "remove_ads" {
        Audio.shared.playSFX(sound: "button_click")
        Animations.shared.shrink(node: removeAdsButton)
        isButtonTouched = "remove_ads"
      }
      
      if touchedNode.name == "Music Button" {
        Audio.shared.playSFX(sound: "button_click")
        Animations.shared.shrink(node: musicButton)
        isButtonTouched = "Music Button"
      }
      
      if touchedNode.name == "sound_button" {
        Audio.shared.playSFX(sound: "button_click")
        Animations.shared.shrink(node: soundButton)
        isButtonTouched = "sound_button"
      }
      
      if touchedNode.name == "Controls Button" {
        //                Audio.shared.soundPlayer(soundName: "Button Click")
        Audio.shared.playSFX(sound: "button_click")
        Animations.shared.shrink(node: controlsButton)
        isButtonTouched = "Controls Button"
      }
      
      if touchedNode.name == "tutorial_button" {
        Audio.shared.playSFX(sound: "button_click")
        Animations.shared.shrink(node: tutorialButton)
        isButtonTouched = "tutorial_button"
      }
      
      if touchedNode.name == "restore_purchases" {
        Audio.shared.playSFX(sound: "button_click")
        Animations.shared.shrink(node: restorePurchases)
        isButtonTouched = "restore_purchases"
      }
      
      if touchedNode.name == "close" {
        Audio.shared.playSFX(sound: "button_click")
        Animations.shared.shrink(node: close)
        isButtonTouched = "close"
      }
      
      if touchedNode.name == "Close Button" {
        Audio.shared.playSFX(sound: "button_click")
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
        
        let expand = SKAction.run {
          Animations.shared.expand(node: self.playButton)
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
      
      
      if touchedNode.name == "Stats" && isButtonTouched == "Stats" {
        
        Animations.shared.expand(node: statsButton)
        createStats()
        //                Animations.shared.animateTexture(node: optionsButton, texture: [optionsTexture2, optionsTexture1])
        
        lastMenuOpened = "Stats"
        for node in mainUIContainer { node.isUserInteractionEnabled = true }
        
      } else if touchedNode.name != "Stats" && isButtonTouched == "Stats" {
        //                Animations.shared.animateTexture(node: optionsButton, texture: [optionsTexture2, optionsTexture1])
        Animations.shared.expand(node: statsButton)
      }
      
      
      if touchedNode.name == "remove_ads" && isButtonTouched == "remove_ads" {
        Animations.shared.expand(node: removeAdsButton)
        
        inAppPurchases.requestProduct(productName: "remove_ads")
        
      } else if touchedNode.name != "remove_ads" && isButtonTouched == "remove_ads" {
        Animations.shared.expand(node: removeAdsButton)
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
      
      
      if touchedNode.name == "sound_button" && isButtonTouched == "sound_button" {
        isSoundMuted.toggle() // toggles bool for sounds
        SavedSettings.shared.setSoundSettings() // saves isSoundMuted boolean in UserDefaults
        Animations.shared.expand(node: soundButton)
        
        if UserDefaults.standard.bool(forKey: "isSoundMuted") == false {
          soundButton.texture = SKTexture(imageNamed: "sound_button_on")
        } else if UserDefaults.standard.bool(forKey: "isSoundMuted") {
          soundButton.texture = SKTexture(imageNamed: "sound_button_off")
        }
        
      } else if touchedNode.name != "sound_button" && isButtonTouched == "sound_button" {
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
      
      
      if touchedNode.name == "tutorial_button" && isButtonTouched == "tutorial_button" {
        Animations.shared.expand(node: tutorialButton)
        instructionsMenu()
        
      } else if touchedNode.name != "tutorial_button" && isButtonTouched == "tutorial_button" {
        Animations.shared.expand(node: tutorialButton)
      }
      
      
      if touchedNode.name == "restore_purchases" && isButtonTouched == "restore_purchases" {
        Animations.shared.expand(node: restorePurchases)
        
        inAppPurchases.restorePurchases()
        
      } else if touchedNode.name != "restore_purchases" && isButtonTouched == "restore_purchases" {
        Animations.shared.expand(node: restorePurchases)
      }
      
      
      if touchedNode.name == "close" && isButtonTouched == "close" {
        
        Animations.shared.expand(node: close)
        
        let fadeOut = SKAction.run {
          Animations.shared.fadeAlphaOut(node: self.howToPlay, duration: 0.25, waitTime: 0)
          Animations.shared.fadeAlphaOut(node: self.close, duration: 0.25, waitTime: 0)
        }
        
        let wait = SKAction.wait(forDuration: 0.3)
        
        let fadeOptionsIn = SKAction.run {
          for node in self.optionsUIContainer {
            Animations.shared.fadeAlphaIn(node: node, duration: 0.4, waitTime: 0)
          }
        }
        
        
        let remove = SKAction.run {
          self.close.removeFromParent()
          self.howToPlay.removeFromParent()
        }
        
        let seq = SKAction.sequence([fadeOut, wait, fadeOptionsIn, remove])
        
        run(seq)
        
      } else if touchedNode.name != "close" && isButtonTouched == "close" {
        Animations.shared.expand(node: close)
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
  
  
  deinit {
    //        print("All Good")
  }
}
