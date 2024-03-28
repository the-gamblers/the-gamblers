//
//  UCItoFENfunctions.swift
//  ChessMaster
//
//  Created by Jade Davis on 3/27/24.
//

import Foundation
import Chess
import ChessKit
import ChessKitEngine

// 1. get uci string func from db
func getUCIStringFromDB() -> String {
    // Implementation goes here
    
    // hardcoded for now
    let uci = "b2b3 d7d5 f2f3 h7h5 d2d3 a7a6 b3b4 d5d4"
    return uci
}

// 2. getUCImoves(string UCIs) - parse uci
/* Example usage:
     let uciString = getUCIStringFromDB()
     let uciMoves = getUCIMoves(UCIs: uciString)
     print(uciMoves) // Output: [("e2-e4", "b7-b5"), ("f2-f3", "h7-h5")]
*/
func getUCIMoves(UCIs: String) -> [(String, String)] {
    var uciMoves: [(String, String)] = []
    
    // Split the UCI string into individual moves
    let moves = UCIs.components(separatedBy: " ")
    
    // Group the moves into pairs
    for i in stride(from: 0, to: moves.count, by: 2) {
        if i + 1 < moves.count {
            // Replace spaces with hyphens in each move
            let firstMove = moves[i].replacingOccurrences(of: " ", with: "-")
            let secondMove = moves[i + 1].replacingOccurrences(of: " ", with: "-")
            uciMoves.append((firstMove, secondMove))
        }
    }
    
    return uciMoves
}

// UCI to FEN
func uciToFEN(uciMoves: [(String, String)]) -> String  {
    
    // Initial FEN position
    var board = Board(position: .standard)
    
    // uciMoves [("e2-e4", "b7-b5"), ("f2-f3", "h7-h5")]
    // uciMove ex: ("e2-e4", "b7-b5")
    // loop through and move pieces on board
    for uciMove in uciMoves {
        let move1 = uciMove.0
        let move2 = uciMove.1
        
        // Splitting move strings to get starting and ending positions
        let start1 = String(move1.prefix(2))
        let end1 = String(move1.suffix(2))
        let start2 = String(move2.prefix(2))
        let end2 = String(move2.suffix(2))
        
        // setting to Square notation for CHessKit
        let beginng1 = Square(start1)
        let stop1 = Square(end1)
        let beginng2 = Square(start2)
        let stop2 = Square(end2)
        
        // Making moves on the board
        board.move(pieceAt: beginng1, to: stop1)
        board.move(pieceAt: beginng2, to: stop2)
        
        
    }
    
    // returns FEN conversiion of given uci moves
    return FENParser.convert(position: board.position)
}

// - take last move (your move) and get best move for given UCI
func getBestMoveForUCI(uciMoves: [(String, String)]) -> String{
    
    // ex: original [("e2-e4", "b7-b5"), ("f2-f3", "h7-h5")]
    
    // best move logic goes here... for now hardcoded
    let bestMove = "g2-g3" // instead of f2-f3
    
    return bestMove
}

// - change original move to best move and keep other player's move the same, ret as UCI
func changeMoveToBestMove(originalMove: [(String, String)], bestMove: String) ->  [(String, String)] {
    // Implementation goes here
    // XX: best move
    // [("e2-e4", "b7-b5"), ("f2-f3", "h7-h5")]
    //          ret -> [("e2-e4", "b7-b5"), ("X-X", "h7-h5")]
    return [("e2e4", "b7b5"), (bestMove, "h7h5")]
}




