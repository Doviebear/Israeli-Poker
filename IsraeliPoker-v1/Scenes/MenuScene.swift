//
//  MenuScene.swift
//  IsraeliPoker-v1
//
//  Created by Dovie Shalev on 6/19/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//
// Back Button Icon made by GraphicsBay from flaticon.com



import SpriteKit
import GameKit
import AWSPinpoint
import AWSMobileClient
import Foundation
import AVKit

///Colors
// light blue: 0x00bcd4
//Pink: 0xe91e63
//Purple: 0x673ab7
//Green: 0x4caf50
//background grey: 0x424242


class MenuScene: SKScene {
    var localPlayButton: SKShapeNode!
    var onlinePlayButton: SKShapeNode!
    var titleNode: SKLabelNode!
    var localButtonEnabled = true
    var onlineButtonEnabled = GameCenterHelper.isAuthenticated
    var helpButton: SKShapeNode!
    var helpButtonPressed = false
    var helpButtonNodes = [SKNode]()
    var acknowledgementText = """
    First of all I want to thank Brian Sand for introducing me to this game.
    Also a big thanks to my dad for guiding me through this whole process and giving me advice along the way.
    Back Button Icon made by GraphicsBay from flaticon.com
"""
    
    var youtubeId = "IixajHZ5goA"
    
    override func didMove(to view: SKView) {
        GameCenterHelper.helper.currentMatch = nil
        backgroundColor = UIColor(rgb: 0x424242)
        
        
        //Title Card
        let blueRectY = JKGame.rect.maxY - 200
        let blueRectHeight = JKGame.rect.height/4
        
        
        let titleCardBlueRect = SKShapeNode(rectOf: CGSize(width: JKGame.rect.width, height: blueRectHeight))
        titleCardBlueRect.position = CGPoint(x: JKGame.rect.midX, y: blueRectY)
        titleCardBlueRect.zPosition = 15
        titleCardBlueRect.fillColor = UIColor(rgb: 0x00bcd4)
        titleCardBlueRect.lineWidth = 0
        addChild(titleCardBlueRect)
        
        titleNode = SKLabelNode(text: "Israeli Poker")
        titleNode.fontName = "RussoOne-Regular"
        titleNode.position = CGPoint(x: 0, y: 0)
        titleNode.fontSize = 120
        titleNode.fontColor = UIColor(rgb: 0xffffff)
        titleNode.zPosition = 20
        titleNode.verticalAlignmentMode = .center
        titleNode.horizontalAlignmentMode = .center
        titleCardBlueRect.addChild(titleNode)
        
        let pinkRectHeight = JKGame.rect.height/16
        let pinkRectY = blueRectY - blueRectHeight/2 - pinkRectHeight/2
        let titleCardPinkRect = SKShapeNode(rectOf: CGSize(width:(JKGame.rect.width/10) * 8, height: pinkRectHeight))
        titleCardPinkRect.position = CGPoint(x: JKGame.rect.width/2, y: pinkRectY)
        titleCardPinkRect.zPosition = 14
        titleCardPinkRect.lineWidth = 0
        titleCardPinkRect.fillColor = UIColor(rgb: 0xe91e63)
        addChild(titleCardPinkRect)
        
        
        let purpleRectHeight = JKGame.rect.height/24
        let purpleRectY = pinkRectY - pinkRectHeight/2 - purpleRectHeight/2
        
        
        let titleCardPurpleRect = SKShapeNode(rectOf: CGSize(width:(JKGame.rect.width/10) * 6, height: purpleRectHeight))
        titleCardPurpleRect.position = CGPoint(x: JKGame.rect.width/2, y: purpleRectY )
        titleCardPurpleRect.zPosition = 13
        titleCardPurpleRect.lineWidth = 0
        titleCardPurpleRect.fillColor = UIColor(rgb: 0x673ab7)
        addChild(titleCardPurpleRect)
 
        
        //Local Play Buton
        
        let buttonWidth = JKGame.rect.width/5
        let buttonHeight = JKGame.rect.height/8
        let buttonY = JKGame.rect.maxY/2 + JKGame.rect.height/4
        
        print("MaxY is: \(JKGame.rect.maxY)")
        print("MaxX is: \(JKGame.rect.maxX)")
        print("Width is: \(JKGame.rect.width)")
        print("Height is: \(JKGame.rect.height)")
        
        localPlayButton = SKShapeNode(rectOf: CGSize(width: buttonWidth, height: buttonHeight))
        localPlayButton.position = CGPoint(x: JKGame.rect.maxX/4, y: buttonY)
        localPlayButton.name = "localPlayButton"
        localPlayButton.lineWidth = 0
        localPlayButton.fillColor = UIColor(rgb: 0x4caf50)
        localPlayButton.zPosition = 15
        addChild(localPlayButton)
        
      
        
        
        let localPlayButtonLabel = SKLabelNode(fontNamed: "RussoOne-Regular")
        localPlayButtonLabel.text = "Play Local"
        localPlayButtonLabel.position = CGPoint(x: 0, y: 0)
        localPlayButtonLabel.zPosition = 11
        localPlayButtonLabel.fontSize = 42
        localPlayButtonLabel.verticalAlignmentMode = .center
        localPlayButtonLabel.horizontalAlignmentMode = .center
        localPlayButtonLabel.fontColor = UIColor(rgb: 0xffffff)
        localPlayButton.addChild(localPlayButtonLabel)
        
        //Online Play Button
        
        
        onlinePlayButton = SKShapeNode(rectOf: CGSize(width: buttonWidth, height: buttonHeight))
        onlinePlayButton.name = "onlinePlayButton"
        onlinePlayButton.position = CGPoint(x: (JKGame.rect.maxX/4) * 3, y: buttonY)
        onlinePlayButton.lineWidth = 0
        onlinePlayButton.fillColor = UIColor(rgb: 0x4caf50)
        onlinePlayButton.zPosition = 15
        addChild(onlinePlayButton)
        
        
        let onlinePlayButtonLabel = SKLabelNode(fontNamed: "RussoOne-Regular")
        onlinePlayButtonLabel.text = "Play Online"
        onlinePlayButtonLabel.position = CGPoint(x: 0, y: 0)
        onlinePlayButtonLabel.zPosition = 11
        onlinePlayButtonLabel.fontSize = 42
        onlinePlayButtonLabel.verticalAlignmentMode = .center
        onlinePlayButtonLabel.horizontalAlignmentMode = .center
        onlinePlayButton.addChild(onlinePlayButtonLabel)
        
        //Help Button
        
        helpButton = SKShapeNode(ellipseOf: CGSize(width: 60, height: 60))
        helpButton.position = CGPoint(x: JKGame.rect.width - 50 , y: JKGame.rect.maxY/2 + 30)
        helpButton.fillColor = UIColor(rgb: 0x2196f3)
        helpButton.lineWidth = 0
        helpButton.name = "helpButton"
        addChild(helpButton)
        
        let helpButtonLabel = SKLabelNode(fontNamed: "RussoOne-Regular")
        helpButtonLabel.text = "?"
        helpButtonLabel.position = CGPoint(x: 0, y: 0)
        helpButtonLabel.zPosition = 15
        helpButtonLabel.fontSize = 32
        helpButtonLabel.verticalAlignmentMode = .center
        helpButtonLabel.horizontalAlignmentMode = .center
        helpButton.addChild(helpButtonLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(authenticationChanged(_:)), name: .authenticationChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentGame(_:)), name: .presentGame, object: nil)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            for node in nodesArray {
                if (node.name == "localPlayButton" && localButtonEnabled == true) {
                    localPlayButton.fillColor = UIColor(rgb: 0x418143)
                    return
                } else if (node.name == "onlinePlayButton" && onlineButtonEnabled == true) {
                    onlinePlayButton.fillColor = UIColor(rgb: 0x418143)
                    return
                } else if node.name == "helpButton" {
                    helpButton.fillColor = UIColor(rgb: 0x1e79c1)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            for node in nodesArray {
                if helpButtonPressed {
                    if node.name == "tutorialButton" {
                        tutorialButtonPressed()
                        return
                    } else {
                        undisplayHelpMenu()
                        helpButtonPressed = false
                        return
                    }
                }
                
                if (node.name == "localPlayButton" && localButtonEnabled == true) {
                 
                    let transition = SKTransition.flipVertical(withDuration: 0.5)
                    let gameScene = GameSceneLocal(model: GameModel(), gameMode: "local", match: nil)
                    self.view?.presentScene(gameScene, transition: transition)
                    return
                    
                } else if (node.name == "onlinePlayButton" && onlineButtonEnabled == true) {
                    onlinePlayButton.fillColor = UIColor(rgb: 0x4caf50)
                    print("Online Button Pressed")
                    GameCenterHelper.helper.createMatchmaker()
                    return
                } else if node.name == "helpButton" {
                    helpButton.fillColor = UIColor(rgb: 0x2196f3)
                    displayHelpMenu()
                    return
                }
            }
        }
    }
    @objc func authenticationChanged(_ notification: Notification) {
        onlineButtonEnabled = notification.object as? Bool ?? false
    }
    
    @objc func presentGame(_ notification: Notification) {
        guard let match = notification.object as? GKTurnBasedMatch else {
            return
        }
        loadAndDisplay(match: match)
    }
    
    func loadAndDisplay(match: GKTurnBasedMatch) {
       
        match.loadMatchData { data, error in
            let model: GameModel
            
            if let data = data {
                do {
                    model = try JSONDecoder().decode(GameModel.self, from: data)
                } catch {
                    model = GameModel()
                }
            } else {
                model = GameModel()
            }
 
            GameCenterHelper.helper.currentMatch = match
            self.view?.presentScene(GameScene(model: model, gameMode: "online", match: match), transition: .flipHorizontal(withDuration: 0.5))
        }
       
    }
    
    func displayHelpMenu() {
        helpButtonPressed = true
        
        let screenDimmer = SKSpriteNode(color:SKColor(red:0.0,green:0.0,blue:0.0,alpha:0.5),size:self.size)
        screenDimmer.position = CGPoint(x: JKGame.rect.width/2, y: JKGame.rect.maxY/4 * 3)
        screenDimmer.zPosition = 50
        addChild(screenDimmer)
        helpButtonNodes.append(screenDimmer)
        
        //tutorial Button
        let tutorialButton = SKShapeNode(rectOf: CGSize(width: JKGame.rect.width/2 - 150, height: JKGame.rect.height/4), cornerRadius: 15)
        tutorialButton.position = CGPoint(x: JKGame.rect.maxX/4 * 3, y: JKGame.rect.maxY/4 * 3)
        tutorialButton.fillColor = UIColor(rgb: 0x4caf50)
        tutorialButton.lineWidth = 0
        tutorialButton.zPosition = 51
        tutorialButton.name = "tutorialButton"
        addChild(tutorialButton)
        helpButtonNodes.append(tutorialButton)
        
        let tutorialButtonLabel = SKLabelNode(fontNamed: "RussoOne-Regular")
        tutorialButtonLabel.text = "Tutorial"
        tutorialButtonLabel.fontColor = .white
        tutorialButtonLabel.verticalAlignmentMode = .center
        tutorialButtonLabel.horizontalAlignmentMode = .center
        tutorialButtonLabel.position = CGPoint(x: 0.0, y: 0.0)
        tutorialButtonLabel.fontSize = 72
        tutorialButton.addChild(tutorialButtonLabel)
        helpButtonNodes.append(tutorialButtonLabel)
        
        let acknowledgementsNode = SKShapeNode(rectOf: CGSize(width: JKGame.rect.maxX/2 - 150, height: JKGame.rect.height - 300), cornerRadius: 15)
        acknowledgementsNode.position = CGPoint(x: JKGame.rect.maxX/4, y: JKGame.rect.maxY/4 * 3)
        acknowledgementsNode.fillColor = UIColor(rgb: 0xffffff)
        acknowledgementsNode.lineWidth = 0
        acknowledgementsNode.zPosition = 51
        addChild(acknowledgementsNode)
        helpButtonNodes.append(acknowledgementsNode)
        
        let acknowledgementsTitle = SKLabelNode(fontNamed: "RussoOne-Regular")
        acknowledgementsTitle.position = CGPoint(x: 0, y: 170)
        acknowledgementsTitle.text = "Acknowledgements"
        acknowledgementsTitle.verticalAlignmentMode = .center
        acknowledgementsTitle.horizontalAlignmentMode = .center
        acknowledgementsTitle.fontSize = 52
        acknowledgementsTitle.fontColor = UIColor(rgb: 0x333333)
        acknowledgementsTitle.zPosition = 52
        acknowledgementsNode.addChild(acknowledgementsTitle)
        helpButtonNodes.append(acknowledgementsTitle)
        
        let acknowledgementsBody = SKLabelNode(fontNamed: "Thonburi")
        acknowledgementsBody.position = CGPoint(x: -300, y: 140)
        acknowledgementsBody.verticalAlignmentMode = .top
        acknowledgementsBody.horizontalAlignmentMode = .left
        acknowledgementsBody.text = acknowledgementText
        acknowledgementsBody.fontColor = UIColor(rgb: 0x333333)
        acknowledgementsBody.fontSize = 24
        acknowledgementsBody.zPosition = 52
        acknowledgementsBody.numberOfLines = 0
        acknowledgementsBody.preferredMaxLayoutWidth = JKGame.rect.maxX/2 - 150 - 50
        acknowledgementsNode.addChild(acknowledgementsBody)
        helpButtonNodes.append(acknowledgementsBody)
    }
    
    func undisplayHelpMenu() {
        for node in helpButtonNodes {
            node.removeFromParent()
        }
    }
    
    func tutorialButtonPressed() {
        if let youtubeURL = URL(string: "youtube://\(youtubeId)"),
            UIApplication.shared.canOpenURL(youtubeURL) {
            // redirect to app
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(youtubeId)") {
            // redirect through safari
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        }
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
