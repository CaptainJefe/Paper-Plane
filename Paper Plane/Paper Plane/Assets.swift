//
//  Assets.swift
//  PlaneTest
//
//  Created by Cade Williams on 10/29/22.
//  Copyright © 2022 Cade Williams. All rights reserved.
//

import Foundation
import SpriteKit

class Assets {
    static let sharedInstance = Assets()
    let gameSprites = SKTextureAtlas(named: "Game Sprites")
    let uiSprites = SKTextureAtlas(named: "UI Sprites")
    
    func preloadGameAssets() {
        gameSprites.preload(completionHandler: {
            print(" Game Sprites Preloaded")
        })
    }
    
    func preloadUIAssets() {
        uiSprites.preload(completionHandler: {
            print(" UI Sprites Preloaded")
        })
    }
}
