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
func getUCIStringFromDB(gameID: String) -> [String] {
    // Convert gameID string to integer
        guard let intValue = Int(gameID) else {
            print("Invalid integer string for gameID:", gameID)
            return []
        }
    
    // TODO: Implementation goes here, get UCI from replay.gameID
    if let wrapperItem = wrapperItem, wrapperItem.checkUser("ansley", password: "thompson") {
        // Retrieve games by user
        if let games = wrapperItem.getUci(intValue) as? [String] {
            for game in games {
                //print("UCIs", game)
            }
            return games
        }
    }
    
    // Return an empty array if authentication fails or if games retrieval fails
    return []
}

func UCIFromDBToUCIMoveFormat(databaseUCI: [String]) -> [(String, String)] {
    var result: [(String, String)] = []
    
    for i in stride(from: 0, to: databaseUCI.count - 1, by: 2) {
        let moveTuple = (databaseUCI[i], databaseUCI[i + 1])
        result.append(moveTuple)
    }
    
    return result
}

func getFENStringFromDB(gameID: String) -> [String] {
    // Convert gameID string to integer
    guard let intValue = Int(gameID) else {
        print("Invalid integer string for gameID:", gameID)
        return []
    }
    
    // TODO: Implementation goes here, get FEN from replay.gameID
    if let wrapperItem = wrapperItem, wrapperItem.checkUser("ansley", password: "thompson") {
        // Retrieve games by user
        if let games = wrapperItem.getFen(intValue) as? [String] {
            for game in games {
                //print("FENs:", game)
            }
            return games
        }
    }
    
    // Return an empty array if authentication fails or if games retrieval fails
    return []
}

func getGamesFromDB(username: String, password: String) -> [String] {    
    if let wrapperItem = wrapperItem, wrapperItem.checkUser(username, password: password) {
        // Retrieve games by user
        if let games = wrapperItem.retrieveGamesByUser() as? [String] {
            for game in games {
                //print(game)
            }
            print("Parsed Replays:", parseReplays(data: games))
            print("UCI from DB:", getUCIStringFromDB(gameID: "1"))
            print("FEN from DB:", getFENStringFromDB(gameID: "1"))
            return games
        }
    }
    
    // Return an empty array if authentication fails or if games retrieval fails
    return []
}

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
    //print(replays)
    return replays
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

//  inp: fen string of move to show best move for (probably curr_fen -1)
func getBestMove(fen: String) -> String{
    // TODO: Best move logic goes here... For now hardcoded
    // let bestMove = "g2-g3" // Instead of f2-f3
    print("pre url")
        let apiUrl = URL(string: "https://stockfish.online/api/stockfish.php?fen=r2q1rk1/ppp2ppp/3bbn2/3p4/8/1B1P4/PPP2PPP/RNB1QRK1 w - - 5 11&depth=5&mode=bestmove")!

        // Create a URLSession instance
        var message : String = ""
        let session = URLSession.shared
        print("post session")

        // Create a data task to fetch the data
        let task = session.dataTask(with: apiUrl) { data, response, error in
        // Check for errors

            print("post task")
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            // Check if a response was received
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: No HTTP response")
                return
            }

            // Check if the response status code indicates success
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Error: HTTP status code \(httpResponse.statusCode)")
                return
            }

            // Check if data was returned
            guard let responseData = data else {
                print("Error: No data received")
                return
            }


            do {
                let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                
                // Check if parsing succeeded and "data" key exists
                if let jsonData = json?["data"] as? String {
                    // Now you have the string "bestmove b1c3 ponder h7h6" in jsonData
                    print("Best move: \(jsonData)")
                    
                    // Split the string by whitespace
                    let moves = jsonData.components(separatedBy: " ")
                    
                    // Find the index of "bestmove"
                    if let index = moves.firstIndex(of: "bestmove") {
                        // Check if the move exists after "bestmove"
                        if index + 1 < moves.count {
                            let firstMove = moves[index + 1]
                            
                            // Replace "b1c3" with "b1-c3"
                            message = firstMove.prefix(2) + "-" + firstMove.suffix(2)
                        
                            
                            print("First move after bestmove: \(message)")
                        } else {
                            print("No move found after bestmove")
                        }
                    } else {
                        print("No bestmove found in JSON response")
                    }
                } else {
                    print("Data key not found in JSON response")
                }

        } catch {
            // Handle error thrown by JSONSerialization.jsonObject
            print("Error parsing JSON: \(error)")
        }
        
}
        task.resume()
    return message
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


func makeUCIStrings(originalUCI: [String]) -> [String] {
    var separatedMoves = [String]()
    var uciStrings = [String]()
    var combinedMoves = ""
    
    for i in stride(from: 0, to: originalUCI.count, by: 2) {
        var uciString = ""
        for j in i..<min(i + 2, originalUCI.count) {
            uciString += originalUCI[j] + " "
        }
        separatedMoves.append(uciString.trimmingCharacters(in: .whitespaces))
    }
    
    for moves in separatedMoves {
        combinedMoves += moves + " "
        uciStrings.append(combinedMoves.trimmingCharacters(in: .whitespaces))
    }
    print(uciStrings)
    return uciStrings
}




