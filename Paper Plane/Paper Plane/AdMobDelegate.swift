//
//  AdMobDelegate.swift
//  Paper Plane
//
//  Created by Cade Williams on 3/19/24.
//  Copyright © 2024 Cade Williams. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SpriteKit

var gamesUntilAd: Int = 5

protocol uiViewCont: UIViewController {
    
}

var bannerView: GADBannerView!
private var interstitial: GADInterstitialAd?

class AdMobDelegate: SKScene, GADFullScreenContentDelegate {
    static let shared = AdMobDelegate()
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitialAd?
    
    
    func createInterstitial() {
        if interstitial != nil {
            print("Ad already loaded")
        } else {
            let request = GADRequest()
            GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910",
                                   request: request,
                                   completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                interstitial = ad
                interstitial?.fullScreenContentDelegate = self
            })
        }
    }
    
    
    func showInterstitial() {
        guard UserDefaults.standard.bool(forKey: "adsRemoved") == false else { return }
        
        if interstitial != nil {
            interstitial?.present(fromRootViewController: currentViewController)
            interstitial = nil
            createInterstitial()
        } else {
            print("Ad wasn't ready")
            createInterstitial()
        }
        
        gamesUntilAd = 5 // move to adDidDismiss to prevent users from force closing app and reopening to curb advertisements. gameUntilAd need to be registered with UserDefaults for this to work. May not be a big deal.
    }
    
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
    
    
}
