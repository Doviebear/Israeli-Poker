//
//  GameModel.swift
//  IsraeliPoker-v1
//
//  Created by Dovie Shalev on 6/21/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import GameKit


struct GameModel: Codable {
    var deck: Deck
    var CardsInPlay: [Card]
    var roundNum = 2
    var turnNum = 0
    
    
    init(){
        self.deck = Deck()
        self.CardsInPlay = [Card]()
        for player in 1...2 {
            for hand in 1...5 {
                let card = self.deck.drawCard()
                card.addToHand(handNum: hand, player: player, numInHand: 1)
                CardsInPlay.append(card)
            }
        }
    }
    
    
    
}

