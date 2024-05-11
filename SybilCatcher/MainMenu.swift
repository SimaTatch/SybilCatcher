//
//  MainMenu.swift
//  SybilCatcher
//
//  Created by simakonfeta on 28.04.2024.
//

import SpriteKit

class MainMenu: SKScene {
    
    var containerNode: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
//        super.didMove(to: view)
        setupBG()
        setupGrounds()
        setupNodes()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {return}
        let node = atPoint(touch.location(in: self))
        
        if node.name == "play" {
            let scene = GameScene(size: size)
            scene.scaleMode = scaleMode
            view!.presentScene(scene, transition: .doorsOpenVertical(withDuration: 0.3))
            
        } else if node.name == "highscore" {
            setupPanel()
            
        } else if node.name == "setting" {
            
            
        } else if node.name == "container" {
            containerNode.removeFromParent()
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        moveGrounds()
        
    }
}

extension MainMenu {
    
    func setupBG() {
        let bgNode = SKSpriteNode(imageNamed: "background22")
        bgNode.anchorPoint = .zero
        bgNode.position = .zero
        bgNode.zPosition = -1.0
        addChild(bgNode)
    }
    
    func setupGrounds() {
        for i in 0...2 {
            let groundNode = SKSpriteNode(imageNamed: "ground")
            groundNode.anchorPoint = .zero
            groundNode.position = CGPoint(x: -CGFloat(i)*groundNode.frame.width, y: 0.0)
            groundNode.zPosition = 1.0
            addChild(groundNode)
        }
    }
    
    func moveGrounds() {
        enumerateChildNodes(withName: "ground") { (node, _) in
            let node = node as! SKSpriteNode
            node.position.x -= 8.0
            
            if node.position.x + node.frame.width < -self.frame.width {
                node.position.x += node.frame.width*2.0
            }
        }
    }
    
    func setupNodes() {
        
        let play = SKSpriteNode(imageNamed: "play")
        play.name = "play"
        play.setScale(0.85)
        play.zPosition = 10.0
        play.position = CGPoint(x: size.width/2.0, y: size.height/2.0 + play.size.height + 50)
        addChild(play)
        
        let highscore = SKSpriteNode(imageNamed: "highscore")
        highscore.name = "highscore"
        highscore.setScale(0.85)
        highscore.zPosition = 10.0
        highscore.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        addChild(highscore)
        
        let setting = SKSpriteNode(imageNamed: "setting")
        setting.name = "setting"
        setting.setScale(0.85)
        setting.zPosition = 10.0
        setting.position = CGPoint(x: size.width/2.0, y: size.height/2.0 - setting.size.height - 50)
        addChild(setting)
    }
    
    func setupPanel() {
        setupContainer()
        
        let panel = SKSpriteNode(imageNamed: "panel")
        panel.setScale(1.5)
        panel.zPosition = 20.0
        panel.position = .zero
        containerNode.addChild(panel)
        
        let x = -panel.frame.width/2.0 + 250.0
        
        let highscoreLbl = SKLabelNode(fontNamed: "Krungthep")
        highscoreLbl.text = "Highscore:\(ScoreGenerator.sharedInstance.getHighscore())"
        highscoreLbl.horizontalAlignmentMode = .left
        highscoreLbl.fontSize = 80.0
        highscoreLbl.zPosition = 25.0
        highscoreLbl.position = CGPoint(x: x, y: highscoreLbl.frame.height/2.0 - 30.0)
        panel.addChild(highscoreLbl)
        
        let scoreLbl = SKLabelNode(fontNamed: "Krungthep")
        scoreLbl.text = "Score:\(ScoreGenerator.sharedInstance.getScore())"
        highscoreLbl.fontSize = 80.0
        highscoreLbl.zPosition = 25.0
        highscoreLbl.position = CGPoint(x: x, y: scoreLbl.frame.height/2.0 - 30.0)
        panel.addChild(scoreLbl)
    }
    
    func setupContainer() {
        containerNode = SKSpriteNode()
        containerNode.name = "container"
        containerNode.zPosition = 15.0
        containerNode.color = .clear
        containerNode.size = size
        containerNode.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        addChild(containerNode)
    }
}
