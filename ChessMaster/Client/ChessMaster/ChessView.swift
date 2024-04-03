import SwiftUI
import Chess
import ChessKit

/// View for displaying chess moves with animations.
struct SquareTargetedPreview: View {
    var replay: Replays?
    // State variables
    @State private var fenIndex = 0 // Index to track the current FEN string
    @StateObject private var store: ChessStore
    @State private var isPlaying = false // State variable to track play/pause
    
    // get fen strings from replay game
    private var fenStrings: [String] {
        guard let replay = replay else { return [] }
        var fenStrings1: [String] = ["rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR",] // starting postion
        let fens = getFENStringFromDB(gameID: replay.gameID)
        for move in fens{
            fenStrings1.append(move)
        }
        print(fenStrings1)
        return fenStrings1
    }
    
    // TODO: get best move for each fen str and convert to fen to display
    var bestFenStrings: [String] = ["rnbqkbnr/ppp1pppp/8/3p4/8/1P6/P1PPPPPP/RNBQKBNR w KQkq d6 0 2"] // best move orig (doesnt mean anything)
    
    // get uci str from replay and parse into play-by-play ucis
    private var uciStrings: [String] {
        guard let replay = replay else { return [] }
        //print(replay)
        return makeUCIStrings(originalUCI: getUCIStringFromDB(gameID: replay.gameID))
    }
    
    init(replay: Replays?) {
        self.replay = replay
        // Initialize ChessStore with a sample game
        let game = Chess.Game.sampleGame()
        self._store = StateObject(wrappedValue: ChessStore(game: game))
        self.store.game.userPaused = true
        self.store.game.setRobotPlaybackSpeed(3.0)
        //print(getGamesFromDB())
        
        // Parse UCI strings and generate FEN strings
        for uciString in uciStrings {
            let uciMoves = getUCIMoves(UCIs: uciString)
            // print("Parsed UCI Moves", uciMoves)
            //let fen = uciToFEN(uciMoves: uciMoves)
            // print("UCI converted to fen",fen)
            //fenStrings.append(fen)
            
            // Get best move for each FEN string
            let bestMove = getBestMoveForUCI(uciMoves: uciMoves)
            let modifiedMoves = changeMoveToBestMove(originalMove: uciMoves, bestMove: bestMove)
            let bestFen = uciToFEN(uciMoves: modifiedMoves)
            bestFenStrings.append(bestFen)
        }
       
        
    }
    
    var body: some View {
        
        VStack {
            BoardView()
                .environmentObject(store)
            
            if isPlaying{
                Text("This would've been the best move...")
                    .font(.headline)
                
            }
            else{
                Text("This was your move")
                    .font(.headline)
            }
            
            // Displaying FEN String for now
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(hex: 0xF3F3F3))
                .frame(height: 100)
                .overlay(
                    Text(isPlaying ? bestFenStrings[fenIndex] : fenStrings[fenIndex])
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
                    // Handle reset button action
                    store.gameAction(.resetBoard)
                    fenIndex = 0
                    isPlaying = false
                }) {
                    Image(systemName: "memories")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                }
                Spacer()
                Button(action: {
                    // Handle pause/play best move button action
                    isPlaying.toggle() // Toggle play/pause state
                    if isPlaying {
                        self.store.game.board.resetBoard(FEN:bestFenStrings[fenIndex])
                    } else {
                        self.store.game.board.resetBoard(FEN:fenStrings[fenIndex])
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
                    if fenIndex < fenStrings.count - 1 {
                        fenIndex += 1
                        self.store.game.board.resetBoard(FEN: fenStrings[fenIndex])}
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
