//
//  Deck.swift
//  Israeli-Poker-v0
//
//  Created by Dovie Shalev on 6/14/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import UIKit
import SpriteKit

class Deck: Codable  {
    var Cards = [Card]()
    var suits = ["Spades", "Hearts","Diamonds","Clubs"]
    var cardNames = ["Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten","Jack","Queen","King","Ace"]
    
    init() {
        for i in 0...3 {
            for k in 2...14 {
                let sprite = "card\(suits[i])\(k)"
                Cards.append(Card(value: k, cardName: cardNames[k - 2] , suit: suits[i], sprite: sprite))
                
            }
        }
        Cards.shuffle()
    }
    
    func resetDeck() {
        Cards.removeAll()
        for i in 0...3 {
            for k in 2...14 {
                let sprite = "card\(suits[i])\(k)"
                Cards.append(Card(value: k, cardName: cardNames[k - 2] , suit: suits[i], sprite: sprite))
                
            }
        }
        Cards.shuffle()
    }
    
    func drawCard() -> Card {
        let chosenCard = Cards[0]
        Cards.remove(at: 0)
        return chosenCard
        
    }
    
}
