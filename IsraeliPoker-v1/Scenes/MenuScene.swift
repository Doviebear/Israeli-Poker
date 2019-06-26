//
//  MenuScene.swift
//  IsraeliPoker-v1
//
//  Created by Dovie Shalev on 6/19/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import SpriteKit
import GameKit

class MenuScene: SKScene {
    var localPlayButton: SKSpriteNode!
    var onlinePlayButton: SKSpriteNode!
    var titleNode: SKLabelNode!
    var localButtonEnabled = true
    var onlineButtonEnabled = GameCenterHelper.isAuthenticated
    
    
    override func didMove(to view: SKView) {
        //GameCenterHelper.helper.currentMatch = nil
        backgroundColor = .blue
        localPlayButton = SKSpriteNode(imageNamed: "blue_button04")
        localPlayButton.position = CGPoint(x: (JKGame.rect.midX), y: JKGame.rect.midY)
        localPlayButton.size = CGSize(width: 190, height: 49)
        localPlayButton.name = "localPlayButton"
        addChild(localPlayButton)
       
        
        
        
        titleNode = SKLabelNode(text: "Israeli Poker")
        titleNode.fontName = "kenvector future thin"
        titleNode.position = CGPoint(x: JKGame.rect.midX, y: JKGame.rect.maxY - 200)
        titleNode.fontSize = 72
        titleNode.fontColor = .red
        addChild(titleNode)
        
        
        let localPlayButtonLabel = SKLabelNode(fontNamed: "kenvector future")
        localPlayButtonLabel.text = "Play Local"
        localPlayButtonLabel.position = CGPoint(x: 0, y: -8)
        localPlayButtonLabel.zPosition = 11
        localPlayButtonLabel.fontSize = 24
        localPlayButton.addChild(localPlayButtonLabel)
        
        onlinePlayButton = SKSpriteNode(imageNamed: "blue_button04")
        onlinePlayButton.name = "onlinePlayButton"
        onlinePlayButton.size = CGSize(width: 190, height: 49)
        onlinePlayButton.position = CGPoint(x: JKGame.rect.midX, y: (JKGame.rect.midY) - 150)
        addChild(onlinePlayButton)
        
        
        let onlinePlayButtonLabel = SKLabelNode(fontNamed: "kenvector future")
        onlinePlayButtonLabel.text = "Play Online"
        onlinePlayButtonLabel.position = CGPoint(x: 0, y: -8)
        onlinePlayButtonLabel.zPosition = 11
        onlinePlayButtonLabel.fontSize = 24
        onlinePlayButton.addChild(onlinePlayButtonLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(authenticationChanged(_:)), name: .authenticationChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentGame(_:)), name: .presentGame, object: nil)
        
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
                 
                    let transition = SKTransition.flipVertical(withDuration: 0.5)
                    let gameScene = GameScene(model: GameModel())
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
    
    @objc func presentGame(_ notification: Notification) {
        guard let match = notification.object as? GKTurnBasedMatch else {
            return
        }
        
        loadAndDisplay(match: match)
    }
    
    func loadAndDisplay(match: GKTurnBasedMatch) {
        match.loadMatchData { data, error in
            let model: GameModel
            
            if let data = data {
                do {
                    model = try JSONDecoder().decode(GameModel.self, from: data)
                } catch {
                    model = GameModel()
                }
            } else {
                model = GameModel()
            }
            
           // GameCenterHelper.helper.currentMatch = match
            self.view?.presentScene(GameScene(model: model), transition: .flipHorizontal(withDuration: 0.5))
        }
       
    }
}
