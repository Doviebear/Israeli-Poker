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
    var cardSize: CGSize!
    
    
    init(value: Int, cardName: String, suit: String, sprite: String) {
        self.value = value
        self.cardName = cardName
        self.suit = suit
        self.sprite = sprite
        if JKGame.size.width < 1250 {
            cardSize = CGSize(width: 84, height: 114)
        } else if JKGame.size.width < 2000 {
            cardSize = CGSize(width: 140, height: 190)
        } else {
            cardSize = CGSize(width: 182, height: 247)
        }
    }
    
    func addToHand(handNum:Int, player: Int,numInHand:Int){
        self.hand = handNum
        self.player = player
        self.numInHand = numInHand
        
    }
    func getPosition() -> CGPoint {
        // 170 pixels between each card and between edges
        let x = Int(JKGame.rect.maxX/8) * (self.hand + 1)
        // 75 pixles between each card vertically, 120 pixels between the top and bottom
        let y: Int
        let handMultiplier = (self.numInHand - 1) * 60
        if self.player == 1 {
            
            y = Int((JKGame.rect.midY - cardSize.height/2)) - (handMultiplier)
        } else {
            y = Int((JKGame.rect.midY + cardSize.height/2)) + (handMultiplier)
        }
        return CGPoint(x:x, y:y)
    }
    
    func getCardSprite() -> SKSpriteNode {
        let sprite = SKSpriteNode(imageNamed: self.sprite)
        sprite.position = self.getPosition()
        sprite.zPosition = CGFloat(self.numInHand + 4)
        sprite.size = cardSize
        return sprite
    }
    func getTopCardSprite() -> SKSpriteNode {
        let sprite = SKSpriteNode(imageNamed: self.sprite)
        sprite.position = CGPoint(x: (JKGame.rect.maxX/8), y: JKGame.rect.midY)
        sprite.zPosition = 11
        sprite.name = "TopCard"
        sprite.size = cardSize
        return sprite
    }
}

class HistogramElement {
    var value: Int
    var freq: Int
    
    init(value: Int, freq: Int){
        self.value = value
        self.freq = freq
    }
}
