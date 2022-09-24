//
//  Animations.swift
//  PlaneTest
//
//  Created by Cade Williams on 9/17/22.
//  Copyright © 2022 Cade Williams. All rights reserved.
//

import SpriteKit

class Animations: SKNode {
    
//    private init() {}
    var titleScreen = TitleScreen()
    
    // Call a method using: Animations.shared.<function>
    static let shared = Animations()
    
    
    // Adds a gaussian blur to an existing node
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
        
        blurNode.run(SKAction.customAction(withDuration: 0.10, actionBlock: { (node: SKNode, elapsedTime: CGFloat) in
            blurNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": elapsedTime * 30])
        }))
    }
    
    // Shrinks a node for a short time. Best used alongside the expand() method
    func shrink(node: SKSpriteNode) {
        let shrink = SKAction.scale(to: 0.75, duration: 0.1)
        let fade = SKAction.run {
            node.colorBlendFactor = 0.35
        }
        let sequence = SKAction.sequence([shrink, fade])
        
        node.run(sequence)
    }
    
    // Expands/enlarges a node for short time. Best used alongside the shrink() method
    func expand(node: SKSpriteNode) {
        
        let wait = SKAction.wait(forDuration: 0.11)
        let expand = SKAction.scale(to: 1.1, duration: 0.075)
        let normal = SKAction.scale(to: 1.0, duration: 0.1)
        let defaultColor = SKAction.run {
            node.alpha = 1
            node.colorBlendFactor = 0
        }
        let sequence = SKAction.sequence([expand, defaultColor, normal])
        
        node.run(sequence)
    }
    
    // Rotates a node clockwise
    func rotateCW(node: SKSpriteNode) {
        let rotateCW = SKAction.rotate(byAngle: -.pi, duration: 0.4)
        
        node.run(rotateCW)
    }
    
    // Rotates a node counter-clockwise
    func rotateCCW(node: SKSpriteNode) {
        let rotateCCW = SKAction.rotate(byAngle: .pi, duration: 0.4)
        
        node.run(rotateCCW)
    }
    
    // Moves a node to the inverse value of its current x-position / from positive to negative or from negative to positive
    func moveUIX(node: SKSpriteNode, duration: TimeInterval) {
        let nodePositionX = node.position.x
        
        let moveNode = SKAction.move(to: CGPoint(x: -nodePositionX, y: node.position.y), duration: duration)
        node.run(moveNode)
    }
    
    // Moves a node to the inverse value of its current y-position / from positive to negative or from negative to positive
    func moveUIY(node: SKSpriteNode, duration: TimeInterval) {
        let nodePositionY = node.position.y
        
        let moveNode = SKAction.move(to: CGPoint(x: node.position.x, y: -nodePositionY), duration: duration)
        node.run(moveNode)
    }
}