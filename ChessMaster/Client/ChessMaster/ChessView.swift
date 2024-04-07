import SwiftUI
import Chess
import ChessKit
import Foundation

/// View for displaying chess moves with animations.
struct SquareTargetedPreview: View {
    var replay: Replays?
    
    // State variables
    @State private var fenIndex = 0 // Index to track the current FEN string
    @StateObject private var store: ChessStore
    @State private var isPlaying = false // State variable to track play/pause
    @State var isTrue = false
    @State private var isTimerRunning = false
    @State private var timer: Timer? = nil
    
 
    // Arrays to store UCI moves and corresponding best move
    private var bestMoves = [String]()
    private var uciPlays = [String]()
    
    // get fen strings from replay game
    private var fenStrings: [String] {
        guard let replay = replay else { return [] }
        var fenStrings1: [String] = [] // starting postion
        let fens = getFENStringFromDB(gameID: replay.gameID)
        for move in fens{
            fenStrings1.append(move)
        }
        //print(fenStrings1)
        return fenStrings1
    }
    
    // get best move for each fen str and convert to fen to display
    var bestFenStrings = [String]()
    
    // get uci str from replay and parse into play-by-play ucis
    private var uciStrings: [String] {
        guard let replay = replay else { return [] }
            
            var uciStrings = makeUCIStrings(originalUCI: getUCIStringFromDB(gameID: replay.gameID))
            // Insert an empty string at the beginning
            uciStrings.insert("", at: 0)
            
            return uciStrings
    }
    
    init(replay: Replays?) {
        self.replay = replay
        // Initialize ChessStore with a sample game
        let game = Chess.Game.sampleGame()
        self._store = StateObject(wrappedValue: ChessStore(game: game))
        
        //print(getGamesFromDB())
        print("UCI strings: ", uciStrings)
        print("FEN strings: ", fenStrings)
        // Parse Best move UCI strings and generate FEN strings
        for (fen, uci) in zip(fenStrings, uciStrings) {
            // Get best move for each FEN string
            let bestMove = getBestMove(fen: fen)
            bestMoves.append(bestMove)
            //print("Best move from stock", bestMove)
        
            //print("Orginal UCI", uci)
            let bestMoveUCIString = changeMoveToBestMove(originalMove: uci, bestMove: bestMove)
            //print("best move ucis", bestMoveUCIString)
            let bestMoveFEN = uciToFEN(uciMoves: bestMoveUCIString)
            bestFenStrings.append(bestMoveFEN)
            //print("Best FEN: " bestMoveFEN)
            
            if let gameID = replay?.gameID {
                       self.uciPlays = getUCIStringFromDB(gameID: gameID)
                }
            
        }
        bestFenStrings.insert("", at: 0)
        bestMoves.insert("press the thumbs up button to see the what the best move wouldve been at that position", at: 0)
        uciPlays.insert("your moves will appear here", at: 0)
        print("Best fen str:", bestFenStrings)
        
       
    }
    
    var body: some View {
        
        VStack {
            BoardView()
                .environmentObject(store)
            if fenIndex == 0 {
                Text("Click through to see your moves! ")
                    .font(.headline)
            }
            else if isPlaying{
                Text("\(fenIndex). This would've been the best move...")
                    .font(.headline)
                
            }
            else{
                Text("\(fenIndex). This is the move that was made.")
                    .font(.headline)
            }
            
            // Displaying FEN String for now
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(hex: 0xF3F3F3))
                .frame(height: 100)
                .overlay(
                    Text(isPlaying ? bestMoves[fenIndex] : uciPlays[fenIndex])
                    .padding()
                )
                .padding()
            
            // Instructions and control buttons
            Text("Toggle \(Image(systemName: "hand.thumbsup")) to see the best move")
                .padding(.vertical)
                .font(.subheadline)
           
            
            // Control buttons
            HStack {
                Button(action: {
                    // Handle back button action
                    timer?.invalidate() // Stops the timer if running
                    isPlaying = false
                    if fenIndex > 0 {
                        fenIndex -= 1
                        self.store.game.board.resetBoard(FEN:fenStrings[fenIndex])}
                    if fenIndex == 0 {
                        self.store.game.board.resetBoard()
                    }
                }) {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                }
                Spacer()
                Button(action: {
                    timer?.invalidate() // Stops the timer if running
                    // Handle reset button action
                    fenIndex = 0
                    isPlaying = false
                    store.gameAction(.resetBoard)
                    store.environmentChange(.boardColor(newColor: .blue))
                     
                }) {
                    Image(systemName: "memories")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                }
                .disabled(true)
                
                Spacer()
                Button(action: {
                    // Handle pause/play best move button action
                    if fenIndex > 0 {
                        self.store.game.board.resetBoard(FEN: fenStrings[fenIndex - 1])
                        timer?.invalidate()
                        isPlaying.toggle() // Toggle play/pause state
                        if isPlaying {
                            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                               // Toggle the value of 'isTrue'
                               isTrue.toggle()
                               if isTrue{
                                   self.store.game.board.resetBoard(FEN: fenStrings[fenIndex - 1])
                               }
                               else{
                                   self.store.game.board.resetBoard(FEN: bestFenStrings[fenIndex])
                               }
                           }
                           DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                               timer?.invalidate() // Stops the timer after 10 seconds
                               self.store.game.board.resetBoard(FEN: bestFenStrings[fenIndex])
                           }
                        
                        } else {
                            self.store.game.board.resetBoard(FEN:fenStrings[fenIndex])
                            store.environmentChange(.boardColor(newColor: .blue))
                        }
                    }
                   
                }) {
                    Image(systemName: isPlaying ? "pause" : "hand.thumbsup") // Toggle play/pause icon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                }
                Spacer()
                Button(action: {
                    // Handle forward button action
                    isPlaying = false
                   
                    timer?.invalidate() // Stops the timer if running
                        
                    if fenIndex < fenStrings.count - 1 {
                            fenIndex += 1
                            // Create a timer that fires every 1 second
                        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                                // Toggle the value of 'isTrue'
                                isTrue.toggle()
                                if isTrue{
                                    self.store.game.board.resetBoard(FEN: fenStrings[fenIndex - 1])
                                }
                                else{
                                    self.store.game.board.resetBoard(FEN: fenStrings[fenIndex])
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                timer?.invalidate() // Stops the timer after 10 seconds
                                self.store.game.board.resetBoard(FEN: fenStrings[fenIndex])
                            }
                           
                        }
                            
                }) {
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                }
            }
            .padding()
        }
    }
}


/// View for displaying the SquareTargetedPreview.
struct SquareTargetedPreviewView: View {
    let replay: Replays // Define a property to hold the replay object
        
        var body: some View {
            SquareTargetedPreview(replay: replay) // Pass the replay object to SquareTargetedPreview
        }
}

/// Main ChessView containing other views.
struct ChessView: View {
    let replay: Replays
    var body: some View {
        VStack {
            SquareTargetedPreviewView(replay: replay)
        }
    }
}

/// Preview provider for ChessView.
struct ChessView_Previews: PreviewProvider {
    static var replay: Replays = Replays(gameID: "1", user: "jade", date: "Feb 20, 2024 11:45 PM", title: "Feb 20, 20", notes: "Notes", uci:  "b2b3d7d5f2f3h7h5d2d3a7a6", fen: "rnbqkbnpppppppp RNBQKBNR")
    static var previews: some View {
        ChessView(replay: replay)
    }
}
