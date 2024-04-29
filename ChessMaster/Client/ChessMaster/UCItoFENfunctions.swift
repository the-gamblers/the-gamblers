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
 * Retrieves UCI string in this format "e2e4b2b4c3c4"from database.
 *
 * - Returns: A string representing UCI moves. ex: ["e2e4", "d7d5", "d1f3", "e7e5", "f1c4", "a7a5", "c4d5", "h7h5", "f3f7"]
 */
func getUCIStringFromDB(gameID: String) -> [String] {
    // Convert gameID string to integer
        guard let intValue = Int(gameID) else {
            return []
        }
    
    // TODO: Implementation goes here, get UCI from replay.gameID
        // Retrieve games by user
        if let games = wrapperItem?.getUci(intValue) as? [String] {
            return games
        }
    
    
    // Return an empty array if authentication fails or if games retrieval fails
    return []
}

/**
 * Retrieves FEN string in this format "rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 2/etc..." from database.
 *
 * - Returns: A string representing FEN moves. ex:  ["rnbqkbnr/pppppppp/8/8/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 1 1", "rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 2", "rnbqkbnr/ppp1pppp/8/3P4/8/5Q2/PPPP1PPP/RNB1KBNR w KQkq - 0 2"]
 */
func getFENStringFromDB(gameID: String) -> [String] {
    // Convert gameID string to integer
    guard let intValue = Int(gameID) else {
        return []
    }
    
    // get FEN from replay.gameID
        // Retrieve games by user
        if let games = wrapperItem?.getFen(intValue) as? [String] {
            return games
        }
    
    // Return an empty array if authentication fails or if games retrieval fails
    return []
}

// get all game info from DB in [String] form.
func getGamesFromDB() -> [String] {
        // Retrieve games by user
        if let games = wrapperItem?.retrieveGamesByUser() as? [String] {
            return games
        }
    
    // Return an empty array if authentication fails or if games retrieval fails
    return []
}

// go through DB games and parse in Replay item
func parseReplays(data: [String]) -> [Replays] {
    var replays: [Replays] = []
    var index = 0
    
    while index < data.count {
        let gameID = data[index]
        let user = data[index + 1]
        let date = data[index + 2]
        let title = data[index + 3]
        let notes = data[index + 4]
        let uci = data[index + 5]
        let fen = data[index + 6]
        
        let replay = Replays(gameID: gameID, user: user, date: date, title: title, notes: notes, uci: uci, fen: fen)
        replays.append(replay)
        
        index += 8
    }
    return replays
}

/**
 * Converts UCI moves parsed from `getUCIMoves()` into a FEN string.
 *
 * - Parameter uciMoves: String of UCI moves
 * - Returns: A FEN string of the current UCI string
 */
func uciToFEN(uciMoves: String) -> String  {
    // Initial FEN position
    var board = Board(position: .standard)
    
    let uciMoves = uciMoves.components(separatedBy: " ")
    
    // Loop through each move and move pieces on board
    for uciMove in uciMoves {
        let startSquare = Square(String(uciMove.prefix(2)))
        let endSquare = Square(String(uciMove.suffix(2)))
               
        // Making move on the board
        board.move(pieceAt: startSquare, to: endSquare)
    }
    // Return FEN conversion of given UCI moves
    return FENParser.convert(position: board.position)
}

/**
 * Retrieves the best move for the given UCI moves.
 *
 * - Parameter fen: string of fen
 * - Returns: A string representing the best move. ex "e2e4"
 */
//  inp: fen string of move to show best move for (probably curr_fen -1)
func getBestMove(fen: String) -> String {
    var message = ""
    let semaphore = DispatchSemaphore(value: 0)
    let apiUrlString = "https://stockfish.online/api/stockfish.php?fen=\(fen)&depth=5&mode=bestmove"
    
    if let apiUrl = URL(string: apiUrlString) {
        let session = URLSession.shared
        let task = session.dataTask(with: apiUrl) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                semaphore.signal()
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: No HTTP response")
                semaphore.signal()
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Error: HTTP status code \(httpResponse.statusCode)")
                semaphore.signal()
                return
            }
            
            guard let responseData = data else {
                print("Error: No data received")
                semaphore.signal()
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                
                if let jsonData = json?["data"] as? String {
                    let moves = jsonData.components(separatedBy: " ")
                    
                    if let index = moves.firstIndex(of: "bestmove"), index + 1 < moves.count {
                        let firstMove = moves[index + 1]
                        message = String(firstMove.prefix(2) + firstMove.suffix(2))
                    }
                } else {
                    print("Data key not found in JSON response")
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
            
            semaphore.signal()
        }
        task.resume()
    }
    
    semaphore.wait()
    return message
}


/**
 * Changes the original move to the best move while keeping the other player's move the same.
 *
 * - Parameters:
 *   - originalMove: String representing original moves.
 *   - bestMove: The best move to replace the original move.
 * - Returns: A String representing thhe added move.
 */
func changeMoveToBestMove(originalMove: String, bestMove: String) -> String {
    // TODO: Implementation goes here
    // add best move on the current uci str
    // ex: orginalMove: "e2e4 d7d5 d1f3 e7e5 f1c4 a7a5 c4d5"
    //     bestMove: "g3g4"
    //     -> add best move to end "e2e4 d7d5 d1f3 e7e5 f1c4 a7a5 c4d5 g3g4"
    
    let modifiedMove = originalMove + " " + bestMove
    return modifiedMove
}

// takes individuals UCI move and separates into play-by-play moves to get fens and best moves
func makeUCIStrings(originalUCI: [String]) -> [String] {
    var separatedMoves = [String]()
    var uciStrings = [String]()
    var combinedMoves = ""
    
    for i in stride(from: 0, to: originalUCI.count, by: 1) {
        var uciString = ""
        for j in i..<min(i + 1, originalUCI.count) {
            uciString += originalUCI[j] + " "
        }
        separatedMoves.append(uciString.trimmingCharacters(in: .whitespaces))
    }
    
    for moves in separatedMoves {
        combinedMoves += moves + " "
        uciStrings.append(combinedMoves.trimmingCharacters(in: .whitespaces))
    }
    return uciStrings
}




