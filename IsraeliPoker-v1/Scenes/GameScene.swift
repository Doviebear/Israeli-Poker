//
//  GameScene.swift
//  IsraeliPoker-v1
//
//  Created by Dovie Shalev on 6/19/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit

class GameScene: SKScene {
    
    var model: GameModel
    var gameMode: String
    var cardsInPlay: [Card]!
    var deck: Deck!
    var topCardSprite: SKSpriteNode!
    var playerOneScoreNode: SKLabelNode?
    var playerTwoScoreNode: SKLabelNode?
    var spritesInPlay = [[Any]]()
    var isSendingTurn = false
    var match: GKTurnBasedMatch?
    var backButton: SKSpriteNode?
    var player: Int?
    var nextCardYouCanPlay: SKSpriteNode?
    
    
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
    
    /// Setup
    
    override func didMove(to view: SKView) {
        //z=positions: Cards: 5-9, TopCard: 11
        //Given that GameModel has loaded all the data, I need to display it all
        loadScreen()
        if gameMode == "online" {
            NotificationCenter.default.addObserver(self, selector: #selector(reloadScreen(_:)), name: .presentGame, object: nil)
        }
        
    }
    
    init(model: GameModel, gameMode: String, match: GKTurnBasedMatch?) {
        self.model = model
        self.gameMode = gameMode
        
        if let currentMatch = match {
            self.match = currentMatch
        }
        
        super.init(size: JKGame.size)
        
        scaleMode = .aspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("required Init didn't work")
    }
    
    @objc func reloadScreen(_ notification: Notification) {
        if gameMode == "online" {
            guard let currMatch = notification.object as? GKTurnBasedMatch else {
                return
            }
            match = currMatch
            currMatch.loadMatchData { data, error in
                
                if let data = data {
                    do {
                        self.model = try JSONDecoder().decode(GameModel.self, from: data)
                        print("Decoded the new data")
                        //print("IsLocalPlayersTurn: \(self.match?.isLocalPlayersTurn)")
                        
                        self.removeAllSprites()
                        self.loadScreen()
                        if self.model.turnNum == 0 {
                            self.newRoundVisualChanges()
                        }
                    } catch {
                        self.removeAllSprites()
                        self.loadScreen()
                        return
                    }
                } else {
                    self.removeAllSprites()
                    self.loadScreen()
                    return
                }
            }
        }
    }
    
    func removeAllSprites() {
        for pair in spritesInPlay {
            let sprite = pair[1] as! SKSpriteNode
            sprite.removeFromParent()
        }
        topCardSprite.removeFromParent()
        playerOneScoreNode?.removeFromParent()
        playerTwoScoreNode?.removeFromParent()
        backButton?.removeFromParent()
        
    }
    
    @objc func loadScreen() {
        
        //Online Mode
        if let currMatch = match {
            if currMatch.isLocalPlayersTurn {
                player = currMatch.participants.firstIndex(of: currMatch.currentParticipant!)! + 1
            }
        } else {
            // change player for Local Mode
            
        }
        
        cardsInPlay = model.CardsInPlay
        deck = model.deck
        
        for card in cardsInPlay {
            var revealed = true
            if card.numInHand == 5 {
                revealed = false
            }
            let sprite = card.getCardSprite(revealed: revealed)
            spritesInPlay.append([card,sprite])
            sprite.name = card.sprite
            addChild(sprite)
        }
        
        backgroundColor = UIColor(red: 45.0/255.0, green: 179.0/255.0, blue: 0.0, alpha: 1.0)
        
        // Top Card Sprite
        topCardSprite = model.topCard.getTopCardSprite(revealed: true)
        addChild(topCardSprite)
        
        
        playerOneScore = model.playerOneScore
        playerTwoScore = model.playerTwoScore
        playerOneScoreNode = SKLabelNode(text: "Score: \(playerOneScore!)")
        playerOneScoreNode?.position = CGPoint(x: JKGame.rect.maxX - 150, y: JKGame.rect.minY + 150)
        addChild(playerOneScoreNode!)
        
        playerTwoScoreNode = SKLabelNode(text: "Score: \(playerTwoScore!)")
        playerTwoScoreNode?.position = CGPoint(x: JKGame.rect.maxX - 150, y: JKGame.rect.maxY - 150)
        addChild(playerTwoScoreNode!)
        
        
        
        backButton = SKSpriteNode(imageNamed: "backButton")
        backButton!.position = CGPoint(x: JKGame.rect.minX + 50, y: JKGame.rect.maxY - 50)
        backButton!.size = CGSize(width: 50,height: 50 )
        backButton!.name = "backButton"
        addChild(backButton!)
        //print("IsLocalPlayersTurn: \(match?.isLocalPlayersTurn)")
        
        let nextCardText = SKLabelNode(text: "Next Card")
        nextCardText.position = CGPoint(x: JKGame.rect.maxX/10, y: JKGame.rect.midY - 200)
        addChild(nextCardText)
        
        if let nextCard = nextCardYouCanPlay {
            nextCard.removeFromParent()
        }
        if let currMatch = match {
            if !currMatch.isLocalPlayersTurn {
                nextCardYouCanPlay = SKSpriteNode(imageNamed: model.deck.Cards[1].sprite)
                let nextCardHeight = model.deck.Cards[1].cardSize.height/3
                nextCardYouCanPlay!.position = CGPoint(x: JKGame.rect.maxX/10 , y: (JKGame.rect.midY - 220) - nextCardHeight/2)
                nextCardYouCanPlay!.size = CGSize(width: model.deck.Cards[1].cardSize.width/3, height: nextCardHeight )
                addChild(nextCardYouCanPlay!)
            }
        }
        
        if model.roundNum == 6 {
            endRoundAnimations()
        }
        
    }
    
    func updateOnlineModel() {
        isSendingTurn = true
        GameCenterHelper.helper.endTurn(model: model, currMatch: match) { error in
            defer {
                self.isSendingTurn = false
            }
                
            if let e = error {
                print("Error ending turn: \(e.localizedDescription)")
                return
            }
        }
        
    }
    
    /// Handling Touches
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameMode == "online" {
            guard !isSendingTurn && match?.isLocalPlayersTurn ?? false else {
                return
            }
        }
        
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
        // Check if round is over, if yes then start and new round and exit the function, else contiune
        //print("is Sending Turn: \(isSendingTurn)")
        //print("Game Center can take turn: \(match?.isLocalPlayersTurn)")
        //print("The current Participant is: \(match?.currentParticipant?.player)")
        
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            if let node = nodesArray.first {
                if node.name == "TopCard" {
                    let nextNode = nodesArray[1]
                    handleTouch(at: nextNode)
                } else {
                    handleTouch(at: node)
                }
            }
        }
        
        guard !isSendingTurn && match?.isLocalPlayersTurn ?? false else {
            return
        }
        
        if model.roundNum == 6 {
            newRoundModelChanges()
            newRoundVisualChanges()
            return
        }
        
        // Check for the nodes that were tapped, used to check if any buttons were pressed
      
    }
    
    func handleTouch(at node: SKNode) {
        // Back Button was pressed
        
        if node.name == "backButton" {
            let scene = MenuScene()
            
            // Get the SKScene from the loaded GKScene
            
            scene.scaleMode = .aspectFill
            scene.size = JKGame.size
            view?.presentScene(scene, transition: SKTransition.push(with: .down, duration: 0.3))
            
        }
        guard !isSendingTurn && match?.isLocalPlayersTurn ?? false else {
            return
        }
        
        if let spriteNode = node as? SKSpriteNode {
            
            let hand = findHand(at: spriteNode )
            handTapped(hand: hand)
        }
    }
   
    
    func handTapped(hand: Int) {
        if hand == 6 { return }
        if !handIsValid(hand: hand) { return }
        
        model.topCard.addToHand(handNum: hand, player: (match?.participants.firstIndex(of: (match?.currentParticipant)!))! + 1, numInHand: model.roundNum)
        let card = model.topCard!
        let sprite = card.getCardSprite(revealed: card.numInHand != 5)
        sprite.name = card.sprite
        spritesInPlay.append([card,sprite])
        addChild(sprite)
        model.CardsInPlay.append(model.topCard)
        nextTurn()
        
    }
    
    func handIsValid(hand: Int) -> Bool {
        let cardsInPlay = model.CardsInPlay
        let roundNum = model.roundNum
        if hand == 6 { return false }
        for card in cardsInPlay {
            if card.numInHand == roundNum && card.player == player && card.hand == hand {
                return false
            }
        }
        return true
    }
    
    func findHand(at node: SKSpriteNode) -> Int {
        let spriteName = node.name
        for pair in spritesInPlay {
            if let sprite = pair[1] as? SKSpriteNode {
               if spriteName == sprite.name {
                    let card = pair[0] as! Card
                    return card.hand
                }
            }
        }
        return 6 // there was an error
    }
    
    /// Handles New Turns
    
    func nextTurn() {
        model.turnNum += 1
        if model.turnNum % 10 == 0 {
            model.roundNum += 1
        }
        newTopCardModel()
        if model.roundNum == 6 {
            roundEnd()
            return
        }
        if gameMode == "online" {
            updateOnlineModel()
        }
        newTopCardVisual()
        if nextCardYouCanPlay == nil {
            nextCardYouCanPlay = SKSpriteNode(imageNamed: model.deck.Cards[1].sprite)
            let nextCardHeight = model.deck.Cards[1].cardSize.height/3
            nextCardYouCanPlay!.position = CGPoint(x: JKGame.rect.maxX/10 , y: (JKGame.rect.midY - 220) - nextCardHeight/2)
            nextCardYouCanPlay!.size = CGSize(width: model.deck.Cards[1].cardSize.width/3, height: nextCardHeight )
            addChild(nextCardYouCanPlay!)
        }
    }
    func newTopCardModel() {
        model.topCard = model.deck.drawCard()
    }
    
    func newTopCardVisual() {
        let revealed = (match?.participants.firstIndex(of: (match?.currentParticipant)!))! + 1 == player
        topCardSprite.removeFromParent()
        topCardSprite = model.topCard.getTopCardSprite(revealed:revealed )
        addChild(topCardSprite)
    }
    
    
    
    /// Handles new rounds
    
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
        var count = 0
        for result in results {
            count += 1
            if result == 1 {
                // if player1 won the hand
                model.playerOneScore += 1
                playerOneScore += 1
                print("P1 Won")
            } else if result == 2 {
                // if player2 won the hand
                print("P2 Won")
                model.playerTwoScore += 1
                playerTwoScore += 1
            } else if result == 3 {
                // if they tied
            } else {
                print("error")
            }
        }
       
        checkForWinner()
        endRoundAnimations()
        updateOnlineModel()
    }
    func endRoundAnimations() {
        var count = 0
        for pair in spritesInPlay {
            let card = pair[0] as! Card
            if card.isRevealed == false {
                let oldSprite = pair[1] as! SKSpriteNode
                let newSprite = card.returnCardToReveal(sprite: oldSprite)
                addChild(newSprite)
                spritesInPlay[count] = [card, newSprite]
            }
            count += 1
        }
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
        count = 0
        for result in results {
            count += 1
            if result == 1 {
                // if player1 won the hand
                
                losingHandAnimation(hand: count, player: 2)
                
            } else if result == 2 {
                // if player2 won the hand
                
               
                losingHandAnimation(hand: count, player: 1)
            } else if result == 3 {
                // if they tied
            } else {
                print("error")
            }
        }
    }
    
    func checkForWinner() {
        if playerOneScore > 11 && playerOneScore > playerTwoScore {
            // game ends, player one wins
            endGame(winner: 1)
        } else if playerTwoScore > 11 && playerTwoScore > playerOneScore {
            // game ends, player Two wins
            endGame(winner: 2)
        } else {
            // exit the function
            return
        }

    }
    
    func newRoundModelChanges() {
       
        model.deck.resetDeck()
        newTopCardModel()
        model.roundNum = 2
        model.turnNum = 0
        model.CardsInPlay.removeAll()
        for player in 1...2 {
            for hand in 1...5 {
                let card = model.deck.drawCard()
                card.addToHand(handNum: hand, player: player, numInHand: 1)
                model.CardsInPlay.append(card)
            }
        }
        updateOnlineModel()
    }
    
    func newRoundVisualChanges() {
        for pair in spritesInPlay {
            let sprite = pair[1] as! SKSpriteNode
            sprite.removeFromParent()
        }
        spritesInPlay.removeAll()
        for card in model.CardsInPlay {
            let sprite = card.getCardSprite(revealed: true)
            sprite.name = card.sprite
            spritesInPlay.append([card,sprite])
            addChild(sprite)
        }
        newTopCardVisual()
    }
    
    func losingHandAnimation(hand: Int, player: Int) {
        let handArray = getHand(Hand: hand, Player: player, model: model)
        let sortedHand = sortHandByCard(hand: handArray)
        var count = 0
        let duration = 1
        
        
        for cardIndex in stride(from: 4, through: 1, by: -1) {
            for pair in spritesInPlay {
                let pairedCard = pair[0] as! Card
                if pairedCard == sortedHand[cardIndex] {
                    //print("Found Card")
                    let cardSprite = pair[1] as! SKSpriteNode
                    let waitTime = Double(count) * 0.25
                    let wait = SKAction.wait(forDuration: waitTime)
                    cardSprite.run(wait, completion: {
                        cardSprite.run(SKAction.moveTo(y: sortedHand[0].getPosition().y, duration: Double(duration) - waitTime))
                    })
                    
                }
            }
            count += 1
            //print("incremented Count")
        }
        
    }
    
    func sortHandByCard(hand: [Card]) -> [Card]{
        var sortedHand = [Card]()
        for card in hand {
            let indexInSortedHand = card.numInHand - 1
            sortedHand.insert(card, at: indexInSortedHand)
        }
        return sortedHand
    }
    
    func endGame(winner: Int) {
        
        for pair in spritesInPlay {
            let sprite = pair[1] as! SKSpriteNode
            sprite.removeFromParent()
        }
        topCardSprite.removeFromParent()
        let endGameLabel = SKLabelNode(text: "Player \(winner) Won!")
        endGameLabel.fontSize = 244
        endGameLabel.verticalAlignmentMode = .center
        endGameLabel.position = CGPoint(x: JKGame.rect.midX, y: JKGame.rect.midY)
        endGameLabel.zPosition = 1000
        addChild(endGameLabel)
        if gameMode == "online" {
            GameCenterHelper.helper.win(winner: winner)
        }
    }

}



