//
//  Ground.swift
//  SybilCatcher
//
//  Created by simakonfeta on 28.04.2024.
//

import SpriteKit

class Ground: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "ground")
        super.init(texture: texture, color: .clear, size: texture.size())
        name = "Ground"
        anchorPoint = .zero
        zPosition = 1.0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//extension Ground {
//    
//    func setupGround(_scene: SKScene) {
//        for i in 0...2 {
//            let ground = Ground()
//            ground.position = CGPoint(x: CGFloat(i)*ground.frame.width,
//                                      y: scene.frame.size.height/2.0)
//            scene.addChild(self)
//        }
//    }
//    
//    func moveGround(_scene: GameScene) {
//        scene.enumerateChildNodes(withName: "Ground") { (node, _) in
//            let node = node as! SKSpriteNode
//            node.position.x -= scene.moveSpeed
//            
////            if node.position.x + node.frame.width < scene.cameraRect.origin.x {
////                node.position = CGPoint(x: node.position.x + node.frame.width*2.0,
////                                        y: node.position.y)
////            }
//        }
//    }
//}
