//
//  GameScene.swift
//  KusoGomoku
//
//  Created by ZONG-YING Tsai on 2017/8/21.
//  Copyright © 2017年 com.kusogomoku. All rights reserved.
//

import SpriteKit
import GameplayKit

enum whoseturn: Int{
    case black = 1
    case white = 2
    func next() -> whoseturn{
        return (self == .white) ? .black : .white
    }
}

class GameScene: SKScene {
    var reset: Bool = true{
        didSet{
            if reset == true{
                blackLabel.run(SKAction.fadeOut(withDuration: 0.0))
                whiteLabel.run(SKAction.fadeOut(withDuration: 0.0))
                
                //  add transparent chess
                resetChesses()
                
                //  initilized chesses 2d array
                chessess = Array(repeatElement(Array(repeatElement(.empty, count: boardSize.width)), count: boardSize.height))
                
                //  set whose turn = .black
                who = .black
                
                winLabel = nil
                reset = false
            }
        }
    }
    
    var who: whoseturn = .black{
        didSet{
            //  prepare label
            if who == .black{
                blackLabel.removeAllActions()
                blackLabel.run(SKAction.fadeIn(withDuration: 0.5), withKey: "fadein")
                whiteLabel.removeAllActions()
                whiteLabel.run(SKAction.fadeOut(withDuration: 0.2), withKey: "fadeout")
            }else{
                blackLabel.removeAllActions()
                blackLabel.run(SKAction.fadeOut(withDuration: 0.2), withKey: "fadeout")
                whiteLabel.removeAllActions()
                whiteLabel.run(SKAction.fadeIn(withDuration: 0.5), withKey: "fadein")
            }
        }
    }
    
    //  background image size = (1229, 1229)
    lazy var boardPosition: (x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) = (
        x: (self.size.width - min(self.size.width, self.size.height)) / 2,
        y: (self.size.height - min(self.size.width, self.size.height)) / 2,
        width: min(self.size.width, self.size.height),
        height: min(self.size.width, self.size.height)
    )
    
    let boardSize = (width: 15, height: 15)
    var chessess: [[ChessType]]!
    
    var background: SKSpriteNode!
    var blackLabel: SKSpriteNode!
    var whiteLabel: SKSpriteNode!
    var winLabel: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        print ("Game Scene didMove")
        print ("#### INFORMATION ####")
        print ("size:", self.size)
        print ("boardPosition",boardPosition)
        
        backgroundColor = SKColor.gray
        
        background = SKSpriteNode(imageNamed: "chessboard")
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.size = CGSize(width: boardPosition.width, height: boardPosition.height)
        addChild(background)
        
        //  prepare black / white label, whose turn
        blackLabel = SKSpriteNode(imageNamed: "stone_black")    //  80*80
        blackLabel.anchorPoint = CGPoint(x: 0.5, y: 0.5)//CGPoint.zero
        blackLabel.position = CGPoint(x: self.size.width * 3/4, y: boardPosition.y / 2)
        addChild(blackLabel)
        blackLabel.run(SKAction.fadeOut(withDuration: 0.0))
        
        whiteLabel = SKSpriteNode(imageNamed: "stone_white")    //  80*80
        whiteLabel.zRotation = CGFloat.pi
        whiteLabel.anchorPoint = CGPoint(x: 0.5, y: 0.5)//CGPoint.zero
        whiteLabel.position = CGPoint(x: self.size.width * 1/4, y: self.size.height - boardPosition.y / 2)
        addChild(whiteLabel)
        whiteLabel.run(SKAction.fadeOut(withDuration: 0.0))
        
        //  reset chess board
        reset = true
        
        //handler_display_winner(who)
    }
    
    func resetChesses(){
        background.removeAllChildren()
        let chessSize: CGFloat = 80 * boardPosition.width / 1229
        let board_step = (boardPosition.width * 1200 / 1229 / 15, boardPosition.height * 1200 / 1229 / 15)
        for y in 0..<boardSize.height{
            for x in 0..<boardSize.width{
                let chess = Chess(chessType: .empty,
                                  textureSize: CGSize(width: chessSize, height: chessSize),
                                  index: ChessIndex(x: x, y: y))
                let position = CGPoint(x: (CGFloat(x) - 7.0) *  board_step.0,
                                       y: (CGFloat(y) - 7.0) *  board_step.1)
                chess.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                chess.position = position
                background.addChild(chess)
            }
        }
    }
    
    private func handler_put_chess(_ chess: Chess){
        chess.flip(with: ChessType(rawValue: who.rawValue)!)
        chessess[chess.index.y][chess.index.x] = ChessType(rawValue: who.rawValue)!
        
        //  check who's win
        if handler_check_winner(chess.index) == true{
            print ("winner is: ", (who == .white) ? "WHITE" : "BLACK")
            
            handler_display_winner(who)
            
        }else{
            who = who.next()
        }
    }
    
    func handler_display_winner(_ who: whoseturn){
        winLabel = SKSpriteNode(imageNamed: "you_win")
        winLabel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        winLabel.position = CGPoint.zero
        
        if who == .white{
            winLabel.zRotation = CGFloat.pi
        }
        background.addChild(winLabel)
        winLabel.run(SKAction.fadeIn(withDuration: 5.0), completion: {self.reset = true})
        //reset = true
    }
    
    private func handler_check_winner(_ pos: ChessIndex) -> Bool{
        let dirs:[ChessIndex] = [ChessIndex(x:0,y:1), ChessIndex(x:-1,y:1), ChessIndex(x:-1,y:0), ChessIndex(x:-1,y:-1),
                                 ChessIndex(x:0,y:-1), ChessIndex(x:1,y:-1), ChessIndex(x:1,y:0), ChessIndex(x:1,y:1)]
        var cnts = [0,0,0,0,0,0,0,0]
        for (i, dir) in dirs.enumerated(){
            var newPos = pos.add(dir)
            while newPos.x >= 0 && newPos.y >= 0 && newPos.x < boardSize.width && newPos.y < boardSize.height && chessess[newPos.y][newPos.x].rawValue == who.rawValue{
                cnts[i] += 1
                newPos = newPos.add(dir)
            }
        }
        
        if (cnts[0] + cnts[4] >= 4) || (cnts[1] + cnts[5] >= 4) || (cnts[2] + cnts[6] >= 4) || (cnts[3] + cnts[7] >= 4){
            return true
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if winLabel != nil{
            return
        }
        for touch in touches {
            let location = touch.location(in: self)
            if let chess = atPoint(location) as? Chess {
                if chessess[chess.index.y][chess.index.x] == ChessType.empty{
                    handler_put_chess(chess)
                }
                else{
                    print ("invalid location", chess.index)
                }
            }
        }
    }
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//
//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//    }
}
