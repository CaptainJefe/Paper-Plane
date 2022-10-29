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
    let sprites = SKTextureAtlas(named: "Game Sprites")
    
    func preloadAssets() {
        sprites.preload(completionHandler: {
            print("Sprites preloaded")
        })
    }
}
