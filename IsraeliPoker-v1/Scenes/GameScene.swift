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
    var playerOneScoreNode: SKLabelNode?
    var playerTwoScoreNode: SKLabelNode?
    var playerOneScore: Int! {
        didSet {
            if let node = playerOneScoreNode {
                node.text = "Score: \(playerOneScore!)"
            }
        }
    }
    
    var playerTwoScore : Int! {
        didSet {
            if let node = playerTwoScoreNode {
                node.text = "Score: \(playerTwoScore!)"
            }
        }
    }
    
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
        
        playerOneScore = model.playerOneScore
        playerTwoScore = model.playerTwoScore
        playerOneScoreNode = SKLabelNode(text: "Score: \(playerOneScore!)")
        playerOneScoreNode?.position = CGPoint(x: 100, y: 750)
        addChild(playerOneScoreNode!)
        
        playerTwoScoreNode = SKLabelNode(text: "Score: \(playerTwoScore!)")
        playerTwoScoreNode?.position = CGPoint(x: 100, y: 50)
        addChild(playerTwoScoreNode!)
        
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
        // disable interaction with the screen
        
        
        var results = [Int]()
        for i in 1...5 {
            var hand1 = [Card]()
            var hand2 = [Card]()
            for card in model.CardsInPlay {
                if card.player == 1 && card.hand == i {
                    hand1.append(card)
                } else if card.player == 2 && card.hand == i {
                    hand2.append(card)
                }
            }
            results.append(compareHands(realHand1: hand1, realHand2: hand2))
        }
        for result in results {
            if result == 1 {
                // if player1 won the hand
                model.playerOneScore += 1
                print("P1 Won")
            } else if result == 2 {
                // if player2 won the hand
                print("P2 Won")
                model.playerTwoScore += 1
            } else if result == 3 {
                // if they tied
            } else {
                print("error")
            }
        }
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
    func getHand(Hand: Int, Player: Int) -> [Card] {
        var handArray = [Card]()
        for card in model.CardsInPlay {
            if card.player == Player && card.hand == Hand {
                handArray.append(card)
            }
        }
        return handArray
    }
    func histogram(handArray: [Card]) -> [HistogramElement] {
        var freq = [HistogramElement]()
        var unsortedFreq = [HistogramElement]()
        var inserted = false
        for i in 0...4 {
            inserted = false
            for k in 0...4 {
                if !inserted {
                    let cardToCompare = handArray[i]
                    let val = cardToCompare.value
        
                    if val == handArray[k].value {
                        for element in unsortedFreq {
                            if element.value == val {
                                element.freq += 1
                                inserted = true
                            }
                        }
                        if  !inserted {
                            unsortedFreq.append(HistogramElement(value: val, freq: 1))
                            inserted = true
                        }
                    }
                }
            }
        }
        for i in stride(from: 4, through: 1, by: -1) {
            for element in unsortedFreq {
                if element.freq == i {
                    freq.append(element)
                }
            }
        }
        return freq
        
    }
    
    func sortHand(handArray: [Card]) -> [Card] {
        var sortedHand = [Card]()
        for i in 2...14 {
            for k in 0...4 {
                if handArray[k].value == i {
                    sortedHand.append(handArray[k])
                }
            }
        }
        return sortedHand
    }
    
    func determineHand(handArray: [Card]) -> handType {
        let histo = histogram(handArray: handArray)
        var isFlush = true
        let hand = sortHand(handArray: handArray)
        
        for k in 0...3 {
            if handArray[k].suit != handArray[k + 1].suit {
                isFlush = false
            }
        }
        
        if hand.last!.value - hand.first!.value == 4 && hand.last?.value == 14 && histo.count == 5 && isFlush == true {
            return .RoyalFlush
        } else if hand.last!.value - hand.first!.value == 4  && histo.count == 5 && isFlush == true {
            return .StraightFlush
        } else if hand.last!.value - hand.first!.value == 4 && histo.count == 5 {
            return .Straight
        } else if  isFlush == true {
            return .Flush
        }
        
        if histo.count == 2 && histo.first!.freq == 3 {
            return .FullHouse
        } else if histo.count == 2 && histo.first!.freq == 4 {
            return .FourOfaKind
        } else if histo.count == 3 && histo.first!.freq == 3 {
            return .ThreeOfAKind
        } else if histo.count == 3 && histo.first!.freq == 2 {
            return .TwoPair
        } else if histo.count == 4 && histo.first!.freq == 2 {
            return .OnePair
        } else if histo.count == 5 {
            return .HighCard
        } else {
        return .HighCard
        }
    }
    func isHistogramHigher(hand1: [Card], hand2: [Card], index: Int) -> Int{
        let histogram1 = histogram(handArray: hand1)
        let histogram2 = histogram(handArray: hand2)
        var winner: Int
        if histogram1[index].value > histogram2[index].value {
            winner = 1
            return winner
        } else if histogram1[index].value < histogram2[index].value {
            winner = 2
            return winner
        } else {
            winner = 0
            return winner
        }
    }
    func compareHands(realHand1: [Card], realHand2: [Card]) -> Int{
        let hand1 = sortHand(handArray: realHand1)
        let hand2 = sortHand(handArray: realHand2)
        let hand1Type = determineHand(handArray: hand1)
        let hand2Type = determineHand(handArray: hand2)
        
        
        if hand1Type.rawValue > hand2Type.rawValue {
            return 1
        } else if hand1Type.rawValue < hand2Type.rawValue {
            return 2
        } else if hand1Type.rawValue == hand2Type.rawValue {
            if hand1Type == .RoyalFlush {
                return 3
            } else if hand1Type == .StraightFlush {
                if hand1.last!.value > hand2.last!.value {
                    return 1
                } else if hand1.last!.value < hand2.last!.value {
                    return 2
                } else {
                    return 3
                }
            } else if hand1Type == .FourOfaKind {
                if isHistogramHigher(hand1: realHand1, hand2: realHand2, index: 1) == 1 {
                    return 1
                } else if isHistogramHigher(hand1: realHand1, hand2: realHand2, index: 1) == 2 {
                    return 2
                }
            } else if hand1Type == .FullHouse {
                if isHistogramHigher(hand1: realHand1, hand2: realHand2, index: 1) == 1 {
                    return 1
                } else if isHistogramHigher(hand1: realHand1, hand2: realHand2, index: 1) == 2 {
                    return 2
                }
            } else if hand1Type == .Flush {
                for i in stride(from: 4, through: 0, by: -1) {
                    if hand1[i].value > hand2[i].value {
                        return 1
                    } else if hand1[i].value < hand2[i].value {
                        return 2
                    }
                }
                return 3
            } else if hand1Type == .Straight {
                if hand1.last!.value > hand2.last!.value {
                    return 1
                } else if hand1.last!.value < hand2.last!.value {
                    return 2
                } else {
                    return 3
                }
            } else if hand1Type == .ThreeOfAKind {
                if isHistogramHigher(hand1: realHand1, hand2: realHand2, index: 1) == 1 {
                    return 1
                } else if isHistogramHigher(hand1: realHand1, hand2: realHand2, index: 1) == 2 {
                    return 2
                }
            } else if hand1Type == .TwoPair {
                if isHistogramHigher(hand1: realHand1, hand2: realHand2, index: 1) == 1 {
                    return 1
                } else if isHistogramHigher(hand1: realHand1, hand2: realHand2, index: 1) == 2 {
                    return 2
                } else if isHistogramHigher(hand1: realHand1, hand2: realHand2, index: 1) == 0 {
                    if isHistogramHigher(hand1: realHand1, hand2: realHand2, index: 2) == 1  {
                        return 1
                    } else if isHistogramHigher(hand1: realHand1, hand2: realHand2, index: 2) == 1 {
                        return 2
                    } else if isHistogramHigher(hand1: realHand1, hand2: realHand2, index: 2) == 0 {
                        if isHistogramHigher(hand1: realHand1, hand2: realHand2, index: 3) == 1 {
                            return 1
                        } else if isHistogramHigher(hand1: realHand1, hand2: realHand2, index: 3) == 2 {
                            return 2
                        } else {
                            return 3
                        }
                    }
                }
            } else if hand1Type == .OnePair {
                if isHistogramHigher(hand1: realHand1, hand2: realHand2, index: 1) == 1 {
                    return 1
                } else if isHistogramHigher(hand1: realHand1, hand2: realHand2, index: 1) == 2 {
                    return 2
                } else if isHistogramHigher(hand1: realHand1, hand2: realHand2, index: 1) == 0 {
                    for i in 0...4 {
                        if hand1[i].value > hand2[i].value {
                            return 1
                        } else if hand1[i].value < hand2[i].value {
                            return 2
                        }
                    }
                    return 3
                }
            } else if hand1Type == .HighCard {
                for i in stride(from: 4, through: 0, by: -1) {
                    if hand1[i].value > hand2[i].value {
                        return 1
                    } else if hand1[i].value < hand2[i].value {
                        return 2
                    }
                }
                return 3
            } else {
                return 4
            }
        } else {
            return 4
        }
        return 4
    }
}



enum handType: Int {
    case RoyalFlush = 10
    case StraightFlush = 9
    case FourOfaKind = 8
    case FullHouse = 7
    case Flush = 6
    case Straight = 5
    case ThreeOfAKind = 4
    case TwoPair = 3
    case OnePair = 2
    case HighCard = 1
}
