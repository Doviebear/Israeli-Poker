//
//  MenuScene.swift
//  IsraeliPoker-v1
//
//  Created by Dovie Shalev on 6/19/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    var localPlayButton: SKSpriteNode!
    var onlinePlayButton: SKSpriteNode!
    var localButtonEnabled = true
    var onlineButtonEnabled = GameCenterHelper.isAuthenticated
    
    
    override func didMove(to view: SKView) {
        localPlayButton = (self.childNode(withName: "localPlayButton") as! SKSpriteNode)
        localPlayButton.texture = SKTexture(imageNamed: "blue_button04")
        
        
       
       
        
        
        let localPlayButtonLabel = SKLabelNode(fontNamed: "kenvector future")
        localPlayButtonLabel.text = "Play Local"
        localPlayButtonLabel.position = CGPoint(x: 0, y: -8)
        localPlayButtonLabel.zPosition = 11
        localPlayButtonLabel.fontSize = 24
        localPlayButton.addChild(localPlayButtonLabel)
        
        onlinePlayButton = (self.childNode(withName: "onlinePlayButton") as! SKSpriteNode)
        onlinePlayButton.texture = SKTexture(imageNamed: "blue_button04")
        
        
        let onlinePlayButtonLabel = SKLabelNode(fontNamed: "kenvector future")
        onlinePlayButtonLabel.text = "Play Online"
        onlinePlayButtonLabel.position = CGPoint(x: 0, y: -8)
        onlinePlayButtonLabel.zPosition = 11
        onlinePlayButtonLabel.fontSize = 24
        onlinePlayButton.addChild(onlinePlayButtonLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(authenticationChanged(_:)), name: .authenticationChanged, object: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            for node in nodesArray {
                if (node.name == "localPlayButton" && localButtonEnabled == true) {
                    localPlayButton.texture = SKTexture(imageNamed: "blue_button05")
                    return
                } else if (node.name == "onlinePlayButton" && onlineButtonEnabled == true) {
                    onlinePlayButton.texture = SKTexture(imageNamed: "blue_button05")
                    return
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            for node in nodesArray {
                if (node.name == "localPlayButton" && localButtonEnabled == true) {
                    localPlayButton.texture = SKTexture(imageNamed: "blue_button04")
                    let transition = SKTransition.flipVertical(withDuration: 0.5)
                    let gameScene = GameScene(size: self.size)
                    self.view?.presentScene(gameScene, transition: transition)
                    return
                } else if (node.name == "onlinePlayButton" && onlineButtonEnabled == true) {
                    onlinePlayButton.texture = SKTexture(imageNamed: "blue_button04")
                    print("Online Button Pressed")
                    GameCenterHelper.helper.createMatchmaker()
                    return
                }
            }
        }
    }
    func authenticatePlayer() {
        
    }
    @objc func authenticationChanged(_ notification: Notification) {
        onlineButtonEnabled = notification.object as? Bool ?? false
    }
}
