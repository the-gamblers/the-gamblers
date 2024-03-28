import SwiftUI
import Chess
import ChessKit

struct TextView: View {
    var body: some View {
        VStack {
            
        }
    }
}

struct SquareTargetedPreview: View {
    @State private var fenIndex = 0 // Index to track the current FEN string
    @StateObject private var store: ChessStore
    @State private var isPlaying = false // State variable to track play/pause
    
    // TODO: get fen strings from game into an array
    var fenStrings: [String] = ["rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR",] // starting postion
    
    // TODO: get best move for each fen str and convert to fen to display
    var bestFenStrings: [String] = ["rnbqkbnr/ppp1pppp/8/3p4/8/1P6/P1PPPPPP/RNBQKBNR w KQkq d6 0 2"] // best move orig (doesnt mean anything)
    
    
    let uciStrings = ["b2b3 d7d5",
        "b2b3 d7d5 f2f3 h7h5",
        "b2b3 d7d5 f2f3 h7h5 d2d3 a7a6 b3b4",
        "b2b3 d7d5 f2f3 h7h5 d2d3 a7a6 b3b4 d5d4"
        ]
   
    
    init() {
        // Initialize ChessStore with a sample game
        // uncomment these to show manual gameplay
        /*let black = Chess.HumanPlayer(side: .black)
        let white = Chess.HumanPlayer(side: .white)
        var game = Chess.Game(white, against: black)
         */
       
        // uncomment these for sample game
        // Initialize ChessStore with a sample game
        let game = Chess.Game.sampleGame()
        //  Initialize ChessStore with the sample game
        self._store = StateObject(wrappedValue: ChessStore(game: game))
        // Set initial properties of the game
        self.store.game.userPaused = true
        self.store.game.setRobotPlaybackSpeed(3.0)
        
        // go through UCI & each play
        for uciString in uciStrings {
            let uciMoves = getUCIMoves(UCIs: uciString)
            print("Parsed UCI Moves", uciMoves)
            let fen = uciToFEN(uciMoves: uciMoves)
            print("UCI converted to fen",fen)
            fenStrings.append(fen)
            print(fenStrings)
            
            // get best move
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
            // Replaying moves
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(hex: 0xF3F3F3))
                .frame(height: 100)
                .overlay(
                    Text(isPlaying ? bestFenStrings[fenIndex] : fenStrings[fenIndex])
                    .padding()
                )
                .padding()
            
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
                    /* TODO: (Jade) Handle pause/play best move button action
                    
                     - get best move FEN at chosen FEN move
                     - when best move button is pressed, display best move on board over and over to mimic aniamtion
                     - when paused/stoped it goes back to original FEN display
                     */
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
                    //self.store.game.board.resetBoard(FEN: "8/5k2/3p4/1p1Pp2p/pP2Pp1P/P4P1K/8/8 b - - 99 50")
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



struct SquareTargetedPreviewView: View {
    
    var body: some View {
        SquareTargetedPreview()
    }
}


struct ChessView: View {
    @State private var fenInput: String = ""
    
    var body: some View {
        VStack {
            TextView()
            SquareTargetedPreviewView()
            
        }
    }
}

struct ChessView_Previews: PreviewProvider {
    static var previews: some View {
        ChessView()
    }
}

