//
//  Person.swift
//  SybilCatcher
//
//  Created by simakonfeta on 28.04.2024.
//

import SpriteKit

class Penguin: SKSpriteNode {
   
    init() {
        let texture = SKTexture(imageNamed: "Pelegrino1")
        super.init(texture: texture, color: .clear, size: texture.size())
        name = "Pinguin"
        zPosition = 5.0
        setScale(0.85)
        
        physicsBody = SKPhysicsBody(rectangleOf: size)

        physicsBody!.affectedByGravity = false
        physicsBody!.categoryBitMask = PhysicsCategory.Player
//        physicsBody!.collisionBitMask = PhysicsCategory.Wall
//        physicsBody!.contactTestBitMask = PhysicsCategory.Wall | PhysicsCategory.Score
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Penguin {
    func setupPenguin(_ ground: Ground, scene: SKScene) {
        position = CGPoint(x: frame.width/2.0,
                                              y: ground.frame.height + frame.height/4.2)
        setupAnim()
        scene.addChild(self)
    }
    
    func setupAnim() {
        var textures: [SKTexture] = []
        
        for i in 1...2 {
            textures.append(SKTexture(imageNamed: "Pelegrino\(i)"))
        }
        
        run(.repeatForever((.animate(with: textures, timePerFrame: 0.66))))
    }
}
