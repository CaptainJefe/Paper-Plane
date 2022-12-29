//
//  Instructions.swift
//  PlaneTest
//
//  Created by Cade Williams on 12/1/22.
//  Copyright © 2022 Cade Williams. All rights reserved.
//

import Foundation
import SpriteKit

let howTo = SKTextureAtlas(named: "Instructions")
let howTo0 = howTo.textureNamed("how_to0")
let howTo1 = howTo.textureNamed("how_to1")
let howTo2 = howTo.textureNamed("how_to2")
let howTo3 = howTo.textureNamed("how_to3")
let howTo4 = howTo.textureNamed("how_to4")
let howTo5 = howTo.textureNamed("how_to5")
let howTo6 = howTo.textureNamed("how_to6")
let howTo7 = howTo.textureNamed("how_to7")
let howTo8 = howTo.textureNamed("how_to8")
let howTo9 = howTo.textureNamed("how_to9")
let howTo10 = howTo.textureNamed("how_to10")
let howTo11 = howTo.textureNamed("how_to11")
let howTo12 = howTo.textureNamed("how_to12")
let howTo13 = howTo.textureNamed("how_to13")
let howTo14 = howTo.textureNamed("how_to14")
let howTo15 = howTo.textureNamed("how_to15")
let howTo16 = howTo.textureNamed("how_to16")
let howTo17 = howTo.textureNamed("how_to17")
let howTo18 = howTo.textureNamed("how_to18")
let howTo19 = howTo.textureNamed("how_to19")
let howTo20 = howTo.textureNamed("how_to20")
let howTo21 = howTo.textureNamed("how_to21")
let howTo22 = howTo.textureNamed("how_to22")
let howTo23 = howTo.textureNamed("how_to23")
let howTo24 = howTo.textureNamed("how_to24")
let howTo25 = howTo.textureNamed("how_to25")
let howTo26 = howTo.textureNamed("how_to26")
let howTo27 = howTo.textureNamed("how_to27")
let howTo28 = howTo.textureNamed("how_to28")

let howToSeq1 = [howTo1, howTo2, howTo3, howTo4, howTo5, howTo6, howTo7, howTo8, howTo9]
let howToBridge1 = [howTo10, howTo11, howTo12, howTo13 ,howTo14]
let howToSeq2 = [howTo15, howTo16, howTo17, howTo18, howTo19, howTo20, howTo21, howTo22, howTo23]
let howToBridge2 = [howTo24, howTo25, howTo26, howTo27, howTo28]

class Instructions: SKNode {
    var howToPlay: SKSpriteNode!
    
    static let shared = Instructions()
    
    
}
