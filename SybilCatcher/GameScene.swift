//
//  GameScene.swift
//  SybilCatcher
//
//  Created by simakonfeta on 28.04.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var ground: SKSpriteNode!
    var player: SKSpriteNode!
    var coin: SKSpriteNode!
    var obstracles: [SKSpriteNode] = []

    var moveSpeed: CGFloat = 8.0
    
    var cameraNode = SKCameraNode()
    
    var cameraMovePointPerSecond: CGFloat = 450.0
    var lastUpdateTime: TimeInterval = 0.0
    var dt: TimeInterval = 0.0
    
    var isTime: CGFloat = 3.0
    var onGround = true
    var velocityY: CGFloat = 0.0
    var gravity: CGFloat = 0.6
    var playerPosY: CGFloat = 0.0
    
    var numScore: Int = 0
    var gameOver = false
    var life: Int = 3
    
    var lifeNodes: [SKSpriteNode] = []
    var scoreLbl = SKLabelNode(fontNamed: "Krungthep")
    var coinIcon: SKSpriteNode!
    
    var pauseNode: SKSpriteNode!
    var containerNode = SKNode()
    
    var playableRect: CGRect {
        let ratio: CGFloat
        switch UIScreen.main.nativeBounds.height{
        case 2688, 1792, 2436:
            ratio = 2.16
        default:
            ratio = 16/9
        }
        let playableHeight = size.width/ratio
        let playableMargine = (size.height - playableHeight) / 2.0
        return CGRect(x: 0.0, y: playableMargine, width: size.width, height: playableHeight)
    }
    
    var cameraRect: CGRect {
        let width = playableRect.width
        let height = playableRect.height
        let x = cameraNode.position.x - size.width/2.0 + (size.width - width)/2.0
        let y = cameraNode.position.y - size.height/2.0 + (size.height - height)/2.0
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func didMove(to view: SKView) {
        setupNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else {return}
        let node =  atPoint(touch.location(in: self))
        
        if node.name == "pause" {
            if isPaused {return}
            createPanel()
            lastUpdateTime = 0.0
            dt = 0.0
            isPaused = true
            
        } else if node.name == "resume" {
            containerNode.removeFromParent()
            isPaused = false
            
        } else if node.name == "quit" {
            
        } else {
            if !isPaused {
                if onGround {
//                    jump()
                    onGround = false
                    velocityY = -25.0
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if velocityY < 12.5 {
            velocityY = -12.5
            
        }
    }
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
            
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        moveCamera()
        movePlayer()
        
        velocityY += gravity
        player.position.y -= velocityY
        
        if player.position.y < playerPosY {
            player.position.y = playerPosY
            velocityY = 0.0
            onGround = true
//            run()
        }
        
        if gameOver {
            let scene = GameOver(size: size)
            scene.scaleMode = scaleMode
            view!.presentScene(scene, transition: .doorsCloseVertical(withDuration: 0.8))
        }
        
        boundCheckPlayer()
    }
}

extension GameScene {
    
    func setupNodes() {
        createBG()
        createGround()
        createPlayer()
        setupObstacles()
        spawnObstacles()
        setupCoin()
        spawnCoin()
        setupPhysics()
        setupLife()
        setupScore()
        setupPause()
        setupCamera()
    
    }
    
    func setupPhysics() {
        physicsWorld.contactDelegate = self
    }
    
    func createBG() {
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: "background")
            bg.name = "BG"
            bg.anchorPoint = .zero
            bg.position = CGPoint(x: CGFloat(i)*bg.frame.width, y: 0.0)
            bg.zPosition = -1.0
            addChild(bg)
        }
    }
    
    func createGround() {
        for i in 0...2 {
            ground = SKSpriteNode(imageNamed: "ground")
            ground.name = "Ground"
            ground.anchorPoint = .zero
            ground.zPosition = 1.0
            ground.position = CGPoint(x: CGFloat(i)*ground.frame.width,
                                      y: 0.0)
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody!.isDynamic = false
            ground.physicsBody!.affectedByGravity = false
            ground.physicsBody!.categoryBitMask = PhysicsCategory.Ground
            addChild(ground)
        }
    }
    
    func jump() {
        self.onGround = false
        var textures: [SKTexture] = []
        textures.append(SKTexture(imageNamed: "Pelegrino1"))
        player.run(.repeatForever(.animate(with: textures, timePerFrame: 0.15)))
    }
    
    func run() {
        var textures: [SKTexture] = []
        for i in 1...2 {
            textures.append(SKTexture(imageNamed: "Pelegrino\(i)"))
        }
        player.run(.repeatForever(.animate(with: textures, timePerFrame: 0.12)))
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "Pelegrino1")
        player.name = "Penguin"
        player.zPosition = 20.0
        player.setScale(0.85)
        player.position = CGPoint(x: frame.width/2.0,
                                  y: ground.frame.height + player.frame.height/2.5)
        

        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/3.0)
//        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        
//        let spaceShipTexture = SKTexture(imageNamed: "penguin")
//        let circularSpaceShip = SKSpriteNode(texture: spaceShipTexture)
//        player.physicsBody = SKPhysicsBody(texture: spaceShipTexture,
//                                                      size: CGSize(width: circularSpaceShip.size.width,
//                                                                   height: circularSpaceShip.size.height))
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.restitution = 0.0
        player.physicsBody!.categoryBitMask = PhysicsCategory.Player
        player.physicsBody!.contactTestBitMask = PhysicsCategory.Block | PhysicsCategory.Obstacle | PhysicsCategory.Coin
        playerPosY = player.position.y
        
        var textures: [SKTexture] = []
        for i in 1...2 {
            textures.append(SKTexture(imageNamed: "Pelegrino\(i)"))
        }
        
        player.run(.repeatForever(.animate(with: textures, timePerFrame: 0.22)))
        addChild(player)
    }
    
    func setupCamera() {
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: frame.midX, y: frame.midY)
    }
    
    func moveCamera() {
        let amountToMove = CGPoint(x: cameraMovePointPerSecond * CGFloat(dt), y: 0.0)
        cameraNode.position += amountToMove
        
        //Background
        enumerateChildNodes(withName: "BG") { (node, _) in
            let node = node as! SKSpriteNode
            
            if node.position.x + node.frame.width < self.cameraRect.origin.x {
                node.position = CGPoint(x: node.position.x + node.frame.width*2.0,
                                        y: node.position.y)
            }
        }
        
//        Ground
        enumerateChildNodes(withName: "Ground") { (node, _) in
            let node = node as! SKSpriteNode

            if node.position.x + node.frame.width < self.cameraRect.origin.x {
                node.position = CGPoint(x: node.position.x + node.frame.width*2.0,
                                        y: node.position.y)
            }
        }
    }
    
    func movePlayer() {
        let amountToMove = cameraMovePointPerSecond * CGFloat(dt)
        let rotate = CGFloat(1).degreesToRadians() * amountToMove/2.5
        player.position.x += amountToMove
        
//        player.zRotation -= rotate
//        foxNode.position.x += amountToMove
    }
    

    func setupObstacles() {
        for i in 1...5 {
            let sprite = SKSpriteNode(imageNamed: "hurdle-\(i)")
            sprite.name = "Block"
            obstracles.append(sprite)
        }
        
        let index = Int(arc4random_uniform(UInt32(obstracles.count - 1)))
        let sprite = obstracles[index].copy() as! SKSpriteNode
        sprite.zPosition = 5.0
        sprite.setScale(0.50)
        sprite.position = CGPoint(x: cameraRect.maxX + sprite.frame.width/2.0,
                                  y: ground.frame.height + sprite.frame.height/2.0)
        
        
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody!.affectedByGravity = false
        sprite.physicsBody!.isDynamic = false
        
        if sprite.name == "Block" {
            sprite.physicsBody!.categoryBitMask = PhysicsCategory.Block
        } else {
            sprite.physicsBody!.categoryBitMask = PhysicsCategory.Obstacle
        }
        
        sprite.physicsBody!.contactTestBitMask = PhysicsCategory.Player
        addChild(sprite)
        sprite.run(.sequence([.wait(forDuration: 10.0), .removeFromParent()]))
    }
    
    func spawnObstacles() {
        let random = Double(CGFloat.random(min: 1.5, max: isTime))
        run(.repeatForever(.sequence([
            .wait(forDuration: random),
            .run { [weak self] in
                self?.setupObstacles()
            }
        ])))
        
        run(.repeatForever(.sequence([
            .wait(forDuration: 5.0),
            .run {
                self.isTime -= 0.01
                if self.isTime <= 1.5 {
                    self.isTime = 1.5
                }
            }
        ])))
    }
    
    func setupCoin() {
        coin = SKSpriteNode(imageNamed: "sybil")
        coin.name = "Coin"
        coin.zPosition = 20.0
        coin.setScale(0.45)
        let coinHeight = coin.frame.height
        let random = CGFloat.random(min: -coinHeight, max: coinHeight*2.0)
        coin.position = CGPoint(x: cameraRect.maxX + coin.frame.width, y: size.height/2.0 + random)
        
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.size.width/2.0)
        coin.physicsBody!.isDynamic = false
        coin.physicsBody!.categoryBitMask = PhysicsCategory.Coin
        coin.physicsBody!.contactTestBitMask = PhysicsCategory.Player
        addChild(coin)
        coin.run(.sequence([
            .wait(forDuration: 15.0),
            .removeFromParent()]))
    }
    
    func spawnCoin() {
        let random = CGFloat.random(min: 2.5, max: 6.0)
        run(.repeatForever(.sequence([
            .wait(forDuration: TimeInterval(random)),
            .run { [weak self] in
                self?.setupCoin()
            }
        ])))
    }
    
    func setupLife() {
        let node1 = SKSpriteNode(imageNamed: "life-on")
        let node2 = SKSpriteNode(imageNamed: "life-on")
        let node3 = SKSpriteNode(imageNamed: "life-on")
        setupLifePos(node1, i: 1.0, j: 0.0)
        setupLifePos(node2, i: 2.0, j: 8.0)
        setupLifePos(node3, i: 3.0, j: 16.0)
        lifeNodes.append(node1)
        lifeNodes.append(node2)
        lifeNodes.append(node3)
    }
    
    func setupLifePos(_ node: SKSpriteNode, i: CGFloat, j: CGFloat) {
        let width = playableRect.width
        let height = playableRect.height
        
        node.setScale(0.5)
        node.zPosition = 50.0
        node.position = CGPoint(x: -width/2.0 + node.frame.width*i + j - 15.0,
                                y: height/2.0 - node.frame.height/2.0)
        cameraNode.addChild(node)
    }
    
    func setupScore() {
        coinIcon = SKSpriteNode(imageNamed: "sybilCount")
        coinIcon.setScale(0.3)
        coinIcon.zPosition = 40.0
        coinIcon.position = CGPoint(x: -playableRect.width/2.0 + coinIcon.frame.width,
                                    y: playableRect.height/1.9 - lifeNodes[0].frame.height - coinIcon.frame.height/1.3)
        cameraNode.addChild(coinIcon)
        
        // Score Label
        scoreLbl.text = "\(numScore)"
        scoreLbl.fontSize = 60.0
        scoreLbl.horizontalAlignmentMode = .left
        scoreLbl.verticalAlignmentMode = .top
        scoreLbl.zPosition = 50.0
        scoreLbl.position = CGPoint(x: -playableRect.width/2.0 + coinIcon.frame.width*2.0 - 10.0,
                                    y: coinIcon.position.y + coinIcon.frame.height/3.0 - 50.0)
        cameraNode.addChild(scoreLbl)
    }
    
    
    func setupPause() {
      pauseNode = SKSpriteNode(imageNamed: "pause")
        pauseNode.setScale(0.5)
        pauseNode.zPosition = 50.0
        pauseNode.name = "pause"
        pauseNode.position = CGPoint(x: playableRect.width/2.0 - 30.0,
                                     y: playableRect.height/2.0 - pauseNode.frame.height/2.0 - 10.0)
        cameraNode.addChild(pauseNode)
    }
    
    func createPanel() {
        cameraNode.addChild(containerNode)
        
        let panel = SKSpriteNode(imageNamed: "panel")
        panel.zPosition = 60.0
        panel.position = .zero
        containerNode.addChild(panel)
        
        let resume = SKSpriteNode(imageNamed: "resume")
        resume.zPosition = 70.0
        resume.name = "resume"
        resume.setScale(0.7)
        resume.position = CGPoint(x: -panel.frame.width/2.0 + resume.frame.width*1.5,
                                  y: 0.0)
        panel.addChild(resume)
        
        let quit = SKSpriteNode(imageNamed: "back")
        quit.zPosition = 70.0
        quit.name = "quit"
        quit.setScale(0.7)
        quit.position = CGPoint(x: panel.frame.width/2.0 - quit.frame.width*1.5,
                                  y: 0.0)
        panel.addChild(quit)
    }
    
    func boundCheckPlayer() {
        let bottomLeft = CGPoint(x: cameraRect.minX, y: cameraRect.minY)
        if player.position.x <= bottomLeft.x {
            player.position.x = bottomLeft.x
            lifeNodes.forEach { $0.texture = SKTexture(imageNamed: "life-off")}
            numScore = 0
            scoreLbl.text = "\(numScore)"
            gameOver = true
        }
    }
    
    func setupGameOver() {
        life -= 1
        if life <= 0 { life = 0 }
        lifeNodes[life].texture = SKTexture(imageNamed: "life-off")
        
        if life <= 0 && !gameOver {
            gameOver = true
        }
    }
}



extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        
        switch other.categoryBitMask {
        case PhysicsCategory.Block:
            cameraMovePointPerSecond += 150.0
            numScore -= 1
            if numScore <= 0 {numScore = 0}
            scoreLbl.text = "\(numScore)"
        case PhysicsCategory.Obstacle:
            setupGameOver()
        case PhysicsCategory.Coin:
            if let node = other.node {
                node.removeFromParent()
                numScore += 1
                scoreLbl.text = "\(numScore)"
                if numScore % 5 == 0 {
                    cameraMovePointPerSecond += 100.0
                }
                
                let highscore = ScoreGenerator.sharedInstance.getHighscore()
                if numScore > highscore {
                    ScoreGenerator.sharedInstance.setHighscore(highscore)
                    ScoreGenerator.sharedInstance.setScore(numScore)
                }
            }
        default:
            break
        }
    }
}
