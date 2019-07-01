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
    var isRevealed: Bool?
    
    
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
    
    func printName () {
        print("\(self.cardName) of \(self.suit)")
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
    
    func getCardSprite(revealed: Bool) -> SKSpriteNode {
        let sprite: SKSpriteNode!
        if !revealed {
            sprite = SKSpriteNode(imageNamed: "cardBack_blue3")
            self.isRevealed = false
        } else {
            sprite = SKSpriteNode(imageNamed: self.sprite)
            self.isRevealed = true
        }
        sprite.position = self.getPosition()
        sprite.zPosition = CGFloat(self.numInHand + 4)
        sprite.size = cardSize
        return sprite
    }
    func getTopCardSprite(revealed: Bool) -> SKSpriteNode {
        let sprite: SKSpriteNode!
        if !revealed {
            sprite = SKSpriteNode(imageNamed: "cardBack_blue3")
            self.isRevealed = false
        } else {
            sprite = SKSpriteNode(imageNamed: self.sprite)
            self.isRevealed = true
        }
        sprite.position = CGPoint(x: (JKGame.rect.maxX/8), y: JKGame.rect.midY)
        sprite.zPosition = 11
        sprite.name = "TopCard"
        sprite.size = cardSize
        return sprite
    }
    
    func returnCardToReveal(sprite: SKSpriteNode) -> SKSpriteNode{
        sprite.removeFromParent()
        let newSprite = SKSpriteNode(imageNamed: self.sprite)
        newSprite.position = self.getPosition()
        newSprite.zPosition = CGFloat(self.numInHand + 4)
        newSprite.size = cardSize
        return newSprite
    }
}
extension Card: Equatable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        hasher.combine(suit)
    }
    static func == (Card1: Card, Card2: Card) -> Bool {
        return
            Card1.value == Card2.value &&
                Card1.suit == Card2.suit &&
                Card1.cardName == Card2.cardName
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
