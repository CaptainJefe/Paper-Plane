//
//  Language.swift
//  Paper Plane
//
//  Created by Cade Williams on 4/12/25.
//  Copyright © 2025 Cade Williams. All rights reserved.
//

import Foundation


// Create a switch case for each language
// Create variables that corresponds to each UI element that needs its own translation (i.e. playButtonTexture)
// Create a lanaguage selection menu
// Selected langauge correpsonds to switch case which changes the textures of each needed UI node that needs to be translated
// UI nodes that need a translation have their textures defined by the variable that is modified in the switch case rather than a single specific image defined when the node is defined (i.e. var playButton = SkSpriteNode(imageNamed: playButtonTexture) | rather than | SKSpriteNode(imagedNamed: "play_button_1")
// Use UserDefaults to save language selection
// Be sure to have the switch case to be called and have a value before any UI elements are created
