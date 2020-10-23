### I think this is a route that you should test. Essentially what I did was kill the for loop in your platform function,
### make the background and single Platform physics bodys, make the Platform one SkNode that houses the left, right,
### and scorer since so much of that code was repeated, then attach the Platform as a fixed pin joint to the background.
### If you want the parallax to persist create a SkNode Platform Parent that moves faster than the background but is positioned
### and instantiates its movement in the same way that your background does.  


class Platform: SKNode {
    var platformLeft: SKSpriteNode?
    var platFormRight: SKSpriteNode?
	var scoreNode: SKSpriteNode?
	
    func setup() {
		let max = CGFloat(frame.width / 4)
        let xPosition = CGFloat.random(in: -80...max)
        let gapSize: CGFloat = -50
		
		let platformRight = SKSpriteNode(texture: platformTexture)
        platformRight.scale(to: CGSize(width: platformRight.size.width * 4, height: platformRight.size.height * 4))
		let yPosition = frame.width - platformRight.frame.width
		platformRight.position = CGPoint(x: xPosition + gapSize, y: -yPosition)
        addChild(platformRight!)
		
		let platformLeft = SKSpriteNode(texture: platformTexture)
        platformLeft.scale(to: CGSize(width: platformLeft.size.width * 4, height: platformLeft.size.height * 4))
		platformLeft.position = CGPoint(x: xPosition + platformLeft.size.width - gapSize, y: -yPosition)
        addChild(platformLeft!)

        ### scoreNode doesn't need to be a physics body (they are expensive computationally)
		### In fact I don't think you need it at all you could just write a scoring function that keeps track of
		### the plane's position relative to each instantiated platform's position. (let maxPlatformY = Max([Stored Array of Constantly Updating Min-Y Values of Each Platform])
		### 																		 if plane.yPosition < maxPlatformY --> score+=1 || remove platform from array

		let scoreNode = SKSpriteNode(color: UIColor.clear, size: CGSize(width: frame.width, height: 32))
		scoreNode.position = CGPoint(x: frame.midX, y: yPosition - (scoreNode.size.width / 1.5))
        scoreNode.name = "scoreDetect"
		addChild(scoreNode!)
		
		
		self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "platform"), size: platformTexture.size())
		self.physicsBody?.isDynamic = false
		self.zPosition = 20
		
		
	}
  
  
  func addPlatform() {
  
        ## Only one background should overlay (0,0) at any point out of two right?
		## Whichever background that can be found at (0,0) should be the one we attach the platform to
		## If you go this route maybe grab your timing variable and throw it in here
		var nodes = nodes(at: CGPoint) 
		var platform = Platform()
		
		#Needs a guard maybe? 
		for (index,name) in nodes.enumerated() {
			if name = "background" {
				
				parentBackground = nodes[0]
				break
			}
		}
		
		let pinJoint  = joint(withBodyA: parentBackground.physicsBody!, bodyB: platform.physicsBody!, anchor: CGPoint)
        
        platformCount += 1
        

    }
## Slight transformation into a physics body...
func createBackground() {

		var backgroundPieces: [SKSpriteNode] = [SKSpriteNode(imageNamed: "Background"), SKSpriteNode(imageNamed: "Background")]
		var backgroundSpeed: CGFloat = 1.0 { didSet { for background in backgroundPieces { background.speed = backgroundSpeed } } }
		
        let backgroundTexture = SKTexture(imageNamed: "Background")
            
        for i in 0 ... 1 {
            
            let background = backgroundPieces[i]
            background.texture = backgroundTexture
			backgroundPhysics = SKPhysicsBody(texture: backgroundTexture, size: backgroundTexture.size())
			background.physicsBody?.isDynamic = false
            background.anchorPoint = CGPoint(x: 0, y: 0)
            background.zPosition = -5
            background.position = CGPoint(x: 0, y: backgroundTexture.size().height + (-backgroundTexture.size().height) + (-backgroundTexture.size().height * CGFloat(i)))
            
            self.addChild(background)
            
            let scrollUp = SKAction.moveBy(x: 0, y: backgroundTexture.size().height, duration: 5)
            let scrollReset = SKAction.moveBy(x: 0, y: -backgroundTexture.size().height, duration: 0)
            let scrollLoop = SKAction.sequence([scrollUp, scrollReset])
            let scrollForever = SKAction.repeatForever(scrollLoop)
            
            background.run(scrollForever)
        }
    }