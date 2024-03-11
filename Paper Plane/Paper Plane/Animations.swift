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
    
    
    // Colorizes a SKNode -- Primarily used to darken/dim
    func colorize(node: SKNode, color: UIColor, colorBlendFactor: CGFloat, duration: TimeInterval) {
        let colorize = SKAction.colorize(with: color, colorBlendFactor: colorBlendFactor, duration: duration)
        node.run(colorize)
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
        
//        let wait = SKAction.wait(forDuration: 0.11)
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
    
    // Fades a nodes alpha value to 0 over a duration
    func fadeAlphaOut(node: SKNode, duration: Double, waitTime: Double) {
        let wait = SKAction.wait(forDuration: waitTime)
        let fadeOut = SKAction.fadeOut(withDuration: duration)
        let seq = SKAction.sequence([wait, fadeOut])
        
        node.run(seq)
    }
    
    // Fades a nodes alpha value to 1 over a duration
    func fadeAlphaIn(node: SKNode, duration: Double, waitTime: Double) {
        let wait = SKAction.wait(forDuration: waitTime)
        let fadeIn = SKAction.fadeIn(withDuration: duration)
            
        let seq = SKAction.sequence([wait, fadeIn])
        node.run(seq)
    }
    
    
    func scaleUp(node: SKSpriteNode) {
        let scalePrelim = SKAction.scale(to: CGSize(width: 1, height: 1), duration: 0)
        let scaleMenuUp = SKAction.scale(to: CGSize(width: node.size.width, height: node.size.height), duration: 0.065) // Consider changing this duration to a function parameter
        let menuSequence = SKAction.sequence([scalePrelim, scaleMenuUp])
        
        node.run(menuSequence)
    }
    
    func animateTexture(node: SKSpriteNode, texture: [SKTexture]) {
        let animate = SKAction.animate(with: texture, timePerFrame: 0.05)
        node.run(animate)
    }
    
    func animateIntructions(node: SKSpriteNode) {
        
        let animate1 = SKAction.animate(with: howToSeq1, timePerFrame: 0.1)
        let animateBridge1 = SKAction.animate(with: howToBridge1, timePerFrame: 0.1)
        let animate2 = SKAction.animate(with: howToSeq2, timePerFrame: 0.1)
        let animateBridge2 = SKAction.animate(with: howToBridge2, timePerFrame: 0.1)
        
        let waitOneSec = SKAction.wait(forDuration: 1)
        let waitQuarterSec = SKAction.wait(forDuration: 0.25)
        
        let seq = SKAction.sequence([waitQuarterSec, animate1, waitOneSec, animateBridge1, waitQuarterSec, animate2, waitOneSec, animateBridge2])
        
        let repeatForever = SKAction.repeatForever(seq)
        
        node.run(repeatForever)
        
    }
}
