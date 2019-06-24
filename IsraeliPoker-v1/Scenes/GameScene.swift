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
    
    var model: GameModel
    var cardsInPlay: [Card]!
    var deck: Deck!
    var topCardSprite: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        //z=positions: Cards: 5-9, TopCard: 11
        //Given that GameModel has loaded all the data, I need to display it all
        cardsInPlay = model.CardsInPlay
        deck = model.deck
        
        for card in cardsInPlay {
            addChild(card.getCardSprite())
        }
        topCardSprite = model.topCard.getTopCardSprite()
        addChild(topCardSprite)
        
      
        backgroundColor = .red
        
    }
    
     init(model: GameModel) {
        self.model = model
        
        super.init(size: .zero)
        
        scaleMode = .resizeFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("required Init didn't work")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            for node in nodesArray {
                if node.name == "TopCard" {
                    node.position = location
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            // Put the topCard into the hand its hovering over and update model and top Card
            let handNum = findHand(at: location)
            if handIsValid(hand: handNum) {
                model.topCard.addToHand(handNum: handNum, player: model.playerTurn, numInHand: model.roundNum)
                addChild(model.topCard.getCardSprite())
                model.CardsInPlay.append(model.topCard)
                nextTurn()
            } else {
                return
            }
        }
    }
    
    func deckTapped() {
        
    }
   
    func newTopCard() {
        topCardSprite.removeFromParent()
        model.topCard = model.deck.drawCard()
        topCardSprite = model.topCard.getTopCardSprite()
        addChild(topCardSprite)
        
    }
    func findHand(at location: CGPoint) -> Int {
        for i in 1...5 {
            if Int(location.x) >= (i * 170) + 30  && Int(location.x) <= ((i + 1) * 170) + 100 {
                return i
            }
        }
        return 6
        
    }
    func nextTurn() {
        newTopCard()
        model.turnNum += 1
        if model.playerTurn == 1 {
            model.playerTurn = 2
        } else {
            model.playerTurn = 1
        }
        if model.turnNum % 10 == 0 {
            model.roundNum += 1
        }
        if model.roundNum == 6 {
            roundEnd()
        }
    }
    
    func roundEnd() {
        
    }
    func handIsValid(hand: Int) -> Bool {
        let playerTurn = model.playerTurn
        let cardsInPlay = model.CardsInPlay
        let roundNum = model.roundNum
        if hand == 6 { return false }
        for card in cardsInPlay {
            if card.numInHand == roundNum && card.player == playerTurn && card.hand == hand {
                return false
            }
        }
        return true
    }
}
