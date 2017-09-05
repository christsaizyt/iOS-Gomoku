//
//  Chess.swift
//  KusoGomoku
//
//  Created by ZONG-YING Tsai on 2017/8/22.
//  Copyright © 2017年 com.kusogomoku. All rights reserved.
//

import SpriteKit


enum ChessType: Int{
    case empty = 0
    case black = 1
    case white = 2
    case stone = 3
    
    func next() -> ChessType{
        return (self == .white) ? .black : (self == .black) ? .white : .empty
    }
//    case red_bomb
//    case black_bomb(3)
}

struct ChessIndex{
    //  chess coordinate
    var x: Int
    var y: Int
}

extension ChessIndex{
    func add(_ idx2: ChessIndex) -> ChessIndex{
        return ChessIndex(x: self.x + idx2.x, y: self.y + idx2.y)
    }
}

class Chess: SKSpriteNode{

    var type: ChessType
    var index: ChessIndex
    
    init(chessType: ChessType, textureSize: CGSize, index: ChessIndex) {
        self.type = chessType
        self.index = index
        
        var sktexture: SKTexture?
        if chessType != ChessType.empty{
            sktexture = SKTexture(imageNamed: "stone_black")
        }
        super.init(texture: sktexture, color: .clear, size: textureSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func flip(with chessType: ChessType){
        self.type = self.type.next()
        
        let newTexture = getTexture(chessType)
        
        let firstHalfFlip = SKAction.scaleX(to: 0.0, duration: 0.4)
        let secondHalfFlip = SKAction.scaleX(to: 1.0, duration: 0.4)
        
        setScale(1.0)
        
        run(firstHalfFlip) {
            self.texture = newTexture
            self.run(secondHalfFlip)
        }
    }
    
    func getTexture(_ curtype: ChessType) -> SKTexture?{
        switch curtype {
        case .empty:
            return nil//SKTexture(imageNamed: "blank.jpg")
        case .white:
            return SKTexture(imageNamed: "stone_white")
        case .black:
            return SKTexture(imageNamed: "stone_black")
        case .stone:
            return nil
        }
    }
}
