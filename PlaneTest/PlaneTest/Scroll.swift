//
//  Scroll.swift
//  PlaneTest
//
//  Created by Cade Williams on 9/13/20.
//  Copyright © 2020 Cade Williams. All rights reserved.
//
import SpriteKit

class Scroll {
    
    // MARK: Enumerations
    
    // MARK: Public Properties
    public var speed : CGFloat {
        get { return getSpeed() }
        set { setSpeed(newValue) }
    }
    
    public var zPosition : CGFloat {
        get { return getZPosition() }
        set { setZPosition(newValue) }
    }
    
    public var alpha : CGFloat {
        get { return getAlpha() }
        set { setAlpha(newValue) }
    }
    
    public var isPaused : Bool {
        get { return getIsPaused() }
        set { setIsPaused(newValue) }
    }
    
    // MARK: Public Properties
    public unowned let scene : SKScene
    public let sprites : [SKSpriteNode]
    public let transitionSpeed : TimeInterval
    
    // MARK: Initialization
    
    init?(images : [UIImage], scene : SKScene, transitionSpeed : Double) {
        
        // handling invalid initializations:
        guard images.count > 1 else {
            Scroll.printInitErrorMessage("You must provide at least 2 images!")
            return nil
        }
        guard (transitionSpeed > 0) && (transitionSpeed <= 100) else {
            Scroll.printInitErrorMessage("The transitionSpeed must be between 0 and 100!")
            return nil
        }
        
        // initiating attributes:
        let spriteSize = Scroll.spriteNodeSize(images[0].size, scene)
        self.sprites = Scroll.createSpriteNodes(from: images, spriteSize)
        self.scene = scene
        self.transitionSpeed = transitionSpeed
        
        // Setup the anchor point for every sprite:
        setSpritesAnchorPoints()
    }
    
    // MARK: Public Methods
    
    /**
     Scrolls the background images indefinitely.
     */
    public func scroll() {
        let numberOfSprites = sprites.count
        let transitionDuration = self.transitionDuration(transitionSpeed: transitionSpeed)
        for index in 0...numberOfSprites - 1 {
            sprites[index].position = CGPoint(x: sceneSize().width/2, y: sprites[index].size.height/2 - (CGFloat(index) * sprites[index].size.height))
            let initialMovementAction = SKAction.moveTo(y: 1.5 * sprites[index].size.height, duration: transitionDuration * Double(index + 1))
            let permanentMovementAction = SKAction.moveTo(y: 1.5 * sprites[index].size.height, duration: transitionDuration * Double(numberOfSprites))
            let putsImageOnBottomAction = SKAction.moveTo(y: sprites[index].size.height/2 - (sprites[index].size.height * CGFloat(numberOfSprites - 1)), duration: 0.0)
            sprites[index].run(SKAction.sequence([initialMovementAction, putsImageOnBottomAction, SKAction.repeatForever(SKAction.sequence([permanentMovementAction, putsImageOnBottomAction]))]))
        }
    }
    
   
    /**
     Converts the transitionSpeed to the transition duration.
     */
    private func transitionDuration(transitionSpeed : Double) -> TimeInterval {
        return 50.0/transitionSpeed
    }
    
    /**
     Returns the scene size.
     */
    private func sceneSize() -> CGSize {
        return scene.size
    }
    
    /**
     Sets the anchor points of every sprite node to match the scene's anchor point.
     */
    private func setSpritesAnchorPoints() {
        for sprite in sprites {
            sprite.anchorPoint.x = scene.anchorPoint.x + 0.5
            sprite.anchorPoint.y = scene.anchorPoint.y + 0.5
        }
    }
    
    /**
     Returns the size the background sprite node objects.
     */
    private static func spriteNodeSize(_ imageSize : CGSize, _ scene : SKScene) -> CGSize {
        var size = CGSize()
        let width = scene.frame.width
        let aspectRatio = imageSize.width/imageSize.height
        size = CGSize(width: width, height: width/aspectRatio)
        return size
    }
    
    /**
     Creates every sprite node from a image array.
     */
    private static func createSpriteNodes(from images : [UIImage], _ size : CGSize) -> [SKSpriteNode] {
        var tempSprites = [SKSpriteNode]()
        for image in images {
            let texture = SKTexture(image: image)
            let sprite = SKSpriteNode(texture: texture, color: .clear, size: size)
            tempSprites.append(sprite)
        }
        return tempSprites
    }
    
    // MARK: Getters and Setters:
    private func getSpeed() -> CGFloat {
        return sprites[0].speed
    }
    
    private func setSpeed(_ value : CGFloat) {
        for sprite in sprites {
            sprite.speed = value
        }
    }
    
    private func getIsPaused() -> Bool {
        return sprites[0].isPaused
    }
    
    private func setIsPaused(_ value : Bool) {
        for sprite in sprites {
            sprite.isPaused = value
        }
    }
    
    private func getAlpha() -> CGFloat {
        return sprites[0].alpha
    }
    
    private func setAlpha(_ value : CGFloat) {
        for sprite in sprites {
            sprite.alpha = value
        }
    }
    
    private func getZPosition() -> CGFloat {
        return sprites[0].zPosition
    }
    
    private func setZPosition(_ value : CGFloat) {
        for sprite in sprites {
            sprite.zPosition = value
        }
    }
    
    // MARK: Static Private Methods
    
    /**
     Prints an initialization error message.
     */
    static private func printInitErrorMessage(_ message : String) {
        print("Scroll Initialization Error - \(message)")
    }
}
