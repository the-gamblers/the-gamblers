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

/**
 * Retrieves UCI string from database.
 *
 * - Returns: A string representing UCI moves.
 */
func getUCIStringFromDB() -> String {
    // TODO: Implementation goes here, get UCI from replay.uci
   
    
    // Hardcoded for now
    let uci = "b2b3 d7d5 f2f3 h7h5 d2d3 a7a6 b3b4 d5d4"
    return uci
}

/**
 * Parses UCI string into an array of tuples representing moves.
 *
 * - Parameter UCIs: UCI string to parse.
 * - Returns: An array of tuples representing moves.
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

/**
 * Converts UCI moves parsed from `getUCIMoves()` into a FEN string.
 *
 * - Parameter uciMoves: Array of tuples representing moves.
 * - Returns: A FEN string.
 */
func uciToFEN(uciMoves: [(String, String)]) -> String  {
    // Initial FEN position
    var board = Board(position: .standard)
    
    // Loop through uci and move pieces on board
    for uciMove in uciMoves {
        let move1 = uciMove.0
        let move2 = uciMove.1
        
        // Convert moves to Square notation for ChessKit
        let start1 = Square(String(move1.prefix(2)))
        let end1 = Square(String(move1.suffix(2)))
        let start2 = Square(String(move2.prefix(2)))
        let end2 = Square(String(move2.suffix(2)))
        
        // Making moves on the board
        board.move(pieceAt: start1, to: end1)
        board.move(pieceAt: start2, to: end2)
    }
    // Return FEN conversion of given UCI moves
    return FENParser.convert(position: board.position)
}

/**
 * Retrieves the best move for the given UCI moves.
 *
 * - Parameter uciMoves: Array of tuples representing moves.
 * - Returns: A string representing the best move.
 */
func getBestMoveForUCI(uciMoves: [(String, String)]) -> String{
    // TODO: Best move logic goes here... For now hardcoded
    let bestMove = "g2-g3" // Instead of f2-f3
    
    // create Stockfish engine
   
    
    return bestMove
}

/**
 * Changes the original move to the best move while keeping the other player's move the same.
 *
 * - Parameters:
 *   - originalMove: Array of tuples representing original moves.
 *   - bestMove: The best move to replace the original move.
 * - Returns: An array of tuples representing modified moves.
 */
func changeMoveToBestMove(originalMove: [(String, String)], bestMove: String) -> [(String, String)] {
    // TODO: Implementation goes here
    return [("e2e4", "b7b5"), (bestMove, "h7h5")]
}


func makeUCIStrings(originalUCI: String) -> [String] {
    let moves = originalUCI.components(separatedBy: " ")
    var seperatedMoves = [String]()
    var uciStrings = [String]()
    var combinedMoves = ""
    
    for i in stride(from: 0, to: moves.count, by: 2) {
            var uciString = ""
            for j in i..<min(i + 2, moves.count) {
                uciString += moves[j] + " "
            }
            seperatedMoves.append(uciString.trimmingCharacters(in: .whitespaces))
        }
    
    for moves in seperatedMoves {
        combinedMoves += moves + " "
        uciStrings.append(combinedMoves.trimmingCharacters(in: .whitespaces))
    }
    
    return uciStrings
}



