//
//  GameViewController.swift
//  PlaneTest
//
//  Created by Cade Williams on 8/21/20.
//  Copyright © 2020 Cade Williams. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

var admobDelegate = AdMobDelegate()
var currentViewController: UIViewController!

class GameViewController: UIViewController {
    static var shared = GameViewController()
    
    var bannerView: GADBannerView!
    private var interstitial: GADInterstitialAd?

//    override var prefersHomeIndicatorAutoHidden: Bool {
//        return true
//    }
//    
//    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
//        return .bottom
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        SavedSettings.shared.setTutorialData() // Resets saved tutorial setting so it shows tutorial again
                
        areControlsHidden = SavedSettings.shared.getControlsSettings()
        isMusicMuted = SavedSettings.shared.getMusicSettings() // retrieves and sets value that was last saved
        isSoundMuted = SavedSettings.shared.getSoundSettings() //
        gamesPlayed = SavedData.shared.getGamesPlayed()
        firstTimePlaying = SavedSettings.shared.getTutorialData()
        adsRemoved = SavedSettings.shared.getAdsSettings()
        
        
        GameViewController.shared = self
        
        Assets.sharedInstance.preloadUIAssets()
        
        currentViewController = self
        
        createBanner()
        admobDelegate.createInterstitial()
        
        InAppPurchaseManager.shared.fetchProducts()
        
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = TitleScreen(fileNamed: "TitleScreen") {
                scene.size = view.frame.size
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
            view.showsPhysics = false
        }
    }
    
    
    func createBanner() {
        let viewWidth = view.frame.inset(by: view.safeAreaInsets).width
        
        let adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView = GADBannerView(adSize: adaptiveSize)

        addBannerViewToView(bannerView)
        
        // Set the ad unit ID
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2435281174"
        
        let adRemovalPurchased = UserDefaults.standard
        
        // Checks to see if the ad removal in-app purchase has been purchased
        
        if !adRemovalPurchased.bool(forKey: "adsRemoved") {
            bannerView.rootViewController = self // Sets the view controller that contains the GADBannerView
            bannerView.load(GADRequest())
            print("There is a banner")
        } else {
            bannerView.isHidden = true
            print("There is no banner")
        }
    }
    
    // Change to two functions for extra safety
    
    func hideBannerAds() {
        guard UserDefaults.standard.bool(forKey: "adsRemoved") == false else { return }
        
        if let bannerView = bannerView {
            bannerView.isHidden = true
        } else {
            print("bannerView is nil")
        }
    }
    
    func showBannerAds() {
        guard UserDefaults.standard.bool(forKey: "adsRemoved") == false else { return }
        
        if let bannerView = bannerView {
            bannerView.isHidden = false
        } else {
            print("bannerView is nil")
        }
    }


    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                 attribute: .centerX,
                                 relatedBy: .equal,
                                 toItem: view,
                                 attribute: .centerX,
                                 multiplier: 1,
                                 constant: 0),
            ])
        
    }
    

    override var shouldAutorotate: Bool {
        return true
    }
    

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
