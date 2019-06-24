//
//  Card.swift
//  Israeli-Poker-v0
//
//  Created by Dovie Shalev on 6/18/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import UIKit
import SpriteKit

class Card: Codable {

    var value: Int
    var cardName: String
    var suit: String
    var sprite: String
    var hand: Int!
    var player: Int!
    var numInHand: Int!
    
    
    init(value: Int, cardName: String, suit: String, sprite: String) {
        self.value = value
        self.cardName = cardName
        self.suit = suit
        self.sprite = sprite
    }
    
    func addToHand(handNum:Int, player: Int,numInHand:Int){
        self.hand = handNum
        self.player = player
        self.numInHand = numInHand
        
    }
    func getPosition() -> CGPoint {
        // 170 pixels between each card and between edges
        let x = (self.hand * 170) + 100
        // 75 pixles between each card vertically, 120 pixels between the top and bottom
        let y: Int
        if self.player == 1 {
             y = 264 - ((self.numInHand - 1) * 75)
        } else {
             y = 504 + ((self.numInHand - 1) * 75)
        }
        return CGPoint(x:x, y:y)
    }
    
    func getCardSprite() -> SKSpriteNode {
        let sprite = SKSpriteNode(imageNamed: self.sprite)
        sprite.position = self.getPosition()
        sprite.zPosition = CGFloat(self.numInHand + 4)
        return sprite
    }
    func getTopCardSprite() -> SKSpriteNode {
        let sprite = SKSpriteNode(imageNamed: self.sprite)
        sprite.position = CGPoint(x: 100, y: 384)
        sprite.zPosition = 11
        sprite.name = "TopCard"
        return sprite
    }
}

