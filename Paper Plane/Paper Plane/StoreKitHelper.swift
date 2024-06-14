//
//  StoreKitHelper.swift
//  Paper Plane
//
//  Created by Cade Williams on 6/8/24.
//  Copyright © 2024 Cade Williams. All rights reserved.
//

import Foundation
import StoreKit

struct StoreKitHelper {
    static var shared = StoreKitHelper()
    
    static var gamesRequiredForRequest = UserDefaults.standard.integer(forKey: "gamesRequiredForRequest")
    
    static func displayStoreKit() {
        print("gamesRequiredForRequest: \(gamesRequiredForRequest)")
        
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: "lastVersionPromptedForReview")
        
        guard gamesPlayed >= gamesRequiredForRequest && currentVersion != lastVersionPromptedForReview else { return }
        
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
            UserDefaults.standard.set(currentVersion, forKey: "lastVersionPromptedForReview")
        }
        
        gamesRequiredForRequest = gamesPlayed + 100
        UserDefaults.standard.setValue(gamesRequiredForRequest, forKey: "gamesRequiredForRequest")
    }
}

