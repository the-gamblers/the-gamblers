//
//  ChessMasterTests.swift
//  ChessMasterTests
//
//  Created by Jade Davis on 2/19/24.
//

import XCTest
@testable import ChessMaster

final class ChessMasterTests: XCTestCase {

    override func setUpWithError() throws {
        super.setUp()
        wrapperItem = dbWrapper(title: "/Users/jadedavis/Documents/gambs-sprint-4-2/ChessMaster/Client/ChessMaster/test")

    }

    override func tearDownWithError() throws {
        // Clean up resources
        wrapperItem = nil
        super.tearDown()
    }

    func testGetUCIStringFromDB() {
        
        let uciStrings = getUCIStringFromDB(gameID: "1")
        
        XCTAssertEqual(uciStrings, ["e2e4", "d7d5", "d1f3", "e7e5", "f1c4", "a7a5", "c4d5", "h7h5", "f3f7"] )
    }
    
    func testGetUCIStringFromDBFailure() {
        
        let uciStrings = getUCIStringFromDB(gameID: "1.5")
        
        XCTAssertEqual(uciStrings, [])
    }
    
    func testGetUCIStringFromDBFailure2() {
        
        let uciStrings = getUCIStringFromDB(gameID: "a")
        
        XCTAssertEqual(uciStrings, [])
    }
    
    func testgetFENStringFromDB() {
        let fenStrings = getFENStringFromDB(gameID: "1")
        
        XCTAssertEqual(fenStrings, ["rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1", "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1", "rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2", "rnbqkbnr/ppp1pppp/8/3p4/4P3/5Q2/PPPP1PPP/RNB1KBNR b KQkq - 1 2", "rnbqkbnr/ppp2ppp/8/3pp3/4P3/5Q2/PPPP1PPP/RNB1KBNR w KQkq - 0 3", "rnbqkbnr/ppp2ppp/8/3pp3/2B1P3/5Q2/PPPP1PPP/RNB1K1NR b KQkq - 1 3", "rnbqkbnr/1pp2ppp/8/p2pp3/2B1P3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 4", "rnbqkbnr/1pp2ppp/8/p2Bp3/4P3/5Q2/PPPP1PPP/RNB1K1NR b KQkq - 0 4", "rnbqkbnr/1pp2pp1/8/p2Bp2p/4P3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 5"] )
    }
    
    func testGetFENStringFromDBFailure() {
            let result = getFENStringFromDB(gameID: "1.5") // Assuming YourClass is the class containing getFENStringFromDB function
            
            XCTAssertTrue(result.isEmpty)
        }
    
    func testGetFENStringFromDBFailure2() {
            let result = getFENStringFromDB(gameID: "a") // Assuming YourClass is the class containing getFENStringFromDB function
            
            XCTAssertTrue(result.isEmpty)
        }
    
    func testGetGamesFromDB() {
        
    }
    
    func testGetGamesFromDBFailure() {
        
        let result = getGamesFromDB()
        
        XCTAssertEqual(result, [])
    }
    
    func testParseReplays() {
            // Arrange
            let games = [
                "1", "ansley", "2024-04-04", "ansley10ABCs", "NULL",
                "e2e4d7d5d1f3e7e5f1c4a7a5c4d5h7h5f3f7",
                "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1,rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1,rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2,rnbqkbnr/ppp1pppp/8/3p4/4P3/5Q2/PPPP1PPP/RNB1KBNR b KQkq - 1 2,rnbqkbnr/ppp2ppp/8/3pp3/4P3/5Q2/PPPP1PPP/RNB1KBNR w KQkq - 0 3,rnbqkbnr/ppp2ppp/8/3pp3/2B1P3/5Q2/PPPP1PPP/RNB1K1NR b KQkq - 1 3,rnbqkbnr/1pp2ppp/8/p2pp3/2B1P3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 4,rnbqkbnr/1pp2ppp/8/p2Bp3/4P3/5Q2/PPPP1PPP/RNB1K1NR b KQkq - 0 4,rnbqkbnr/1pp2pp1/8/p2Bp2p/4P3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 5,",
                "0:00:03.003423", "2", "ansley", "2024-04-18", "New Game Started", "No notes yet", "", "", "NULL"
            ]
            
            let replays = parseReplays(data: games)
            
            // Assert
            XCTAssertEqual(replays.count, 2) // Check if the correct number of replays were parsed
            
            // Check the content of the first replay
            XCTAssertEqual(replays[0].gameID, "1")
            XCTAssertEqual(replays[0].user, "ansley")
            XCTAssertEqual(replays[0].date, "2024-04-04")
            XCTAssertEqual(replays[0].title, "ansley10ABCs")
            XCTAssertEqual(replays[0].notes, "NULL")
            XCTAssertEqual(replays[0].uci, "e2e4d7d5d1f3e7e5f1c4a7a5c4d5h7h5f3f7")
            XCTAssertEqual(replays[0].fen, "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1,rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1,rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2,rnbqkbnr/ppp1pppp/8/3p4/4P3/5Q2/PPPP1PPP/RNB1KBNR b KQkq - 1 2,rnbqkbnr/ppp2ppp/8/3pp3/4P3/5Q2/PPPP1PPP/RNB1KBNR w KQkq - 0 3,rnbqkbnr/ppp2ppp/8/3pp3/2B1P3/5Q2/PPPP1PPP/RNB1K1NR b KQkq - 1 3,rnbqkbnr/1pp2ppp/8/p2pp3/2B1P3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 4,rnbqkbnr/1pp2ppp/8/p2Bp3/4P3/5Q2/PPPP1PPP/RNB1K1NR b KQkq - 0 4,rnbqkbnr/1pp2pp1/8/p2Bp2p/4P3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 5,")
            
            // Check the content of the second replay
            XCTAssertEqual(replays[1].gameID, "2")
            XCTAssertEqual(replays[1].user, "ansley")
            XCTAssertEqual(replays[1].date, "2024-04-18")
            XCTAssertEqual(replays[1].title, "New Game Started")
            XCTAssertEqual(replays[1].notes, "No notes yet")
            XCTAssertEqual(replays[1].uci, "")
            XCTAssertEqual(replays[1].fen, "")
        }
    
    func testuciToFEN(){
        let uci = "e2e4"
        let fen = uciToFEN(uciMoves: uci)
        XCTAssertEqual(fen, "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e3 0 1")
        
    }
    
    func testgetBestMove(){
        let fen = "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e3 0 1"
        let uci = getBestMove(fen: fen)
        XCTAssertEqual(uci, "d2d4")
    }
    
    func testchangeMoveToBestMove(){
        let uci = "e2e4 d7d5 d1f3 e7e5 f1c4 a7a5 c4d5"
        let bestMove = "g3g4"
        let bestUCI = "e2e4 d7d5 d1f3 e7e5 f1c4 a7a5 c4d5 g3g4"
        
        let result = changeMoveToBestMove(originalMove: uci, bestMove: bestMove)
        XCTAssertEqual(bestUCI, result)
    }
    
    func testmakeUCIStrings(){
        let uci = ["e2e4", "d7d5", "d1f3", "e7e5", "f1c4", "a7a5", "c4d5", "h7h5", "f3f7"]
        let strings = makeUCIStrings(originalUCI: uci)
        XCTAssertEqual(strings, ["e2e4", "e2e4 d7d5", "e2e4 d7d5 d1f3", "e2e4 d7d5 d1f3 e7e5", "e2e4 d7d5 d1f3 e7e5 f1c4", "e2e4 d7d5 d1f3 e7e5 f1c4 a7a5", "e2e4 d7d5 d1f3 e7e5 f1c4 a7a5 c4d5", "e2e4 d7d5 d1f3 e7e5 f1c4 a7a5 c4d5 h7h5", "e2e4 d7d5 d1f3 e7e5 f1c4 a7a5 c4d5 h7h5 f3f7"])
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
