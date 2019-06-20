//
//  GameScene.swift
//  IsraeliPoker-v1
//
//  Created by Dovie Shalev on 6/19/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var deck = Deck()
    var roundNum = 2
    var turnNum = 0
    
    
    override func didMove(to view: SKView) {
        // lay out 5 cards for each person
        
        deck.createDeck()
        for player in 1...2 {
            for hand in 1...5 {
                let card = deck.drawCard()
                card.addToHand(handNum: hand, player: player, numInHand: 1)
                drawCardSprite(Card: card)
            }
        }
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func deckTapped() {
        
    }
    
    func cardPlaced() {
        
        
        turnNum += 1
        if turnNum % 10 == 0 {
            roundNum += 1
        }
    }
    func roundEnd() {
        
    }
    func drawCardSprite(Card: Card) {
        let sprite = Card.sprite
        sprite.position = Card.getPosition()
        addChild(sprite)
    }
    
    
}
