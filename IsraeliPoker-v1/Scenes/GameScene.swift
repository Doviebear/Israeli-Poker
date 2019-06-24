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
    
    override func didMove(to view: SKView) {
        //Given that GameModel has loaded all the data, I need to display it all
        cardsInPlay = model.CardsInPlay
        
        for card in cardsInPlay {
            drawCardSprite(Card: card)
        }
      
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
    
    func deckTapped() {
        
    }
    
    func cardPlaced() {
        
        
    }
    func roundEnd() {
        
    }
    func drawCardSprite(Card: Card) {
        let sprite = SKSpriteNode(imageNamed: Card.sprite)
        sprite.position = Card.getPosition()
        addChild(sprite)
    }
    
    
}
