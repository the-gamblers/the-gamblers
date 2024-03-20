import SwiftUI
import Chess


struct TextView: View {
    @State private var fenInput: String = ""
    @Binding var fen: String // Binding to pass the FEN string
    
    var body: some View {
        VStack {
            /*TextField("Enter FEN String", text: $fenInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onChange(of: fenInput) { newValue in
                    fen = newValue // Update the FEN variable
                }
             */
        }
    }
}

struct SquareTargetedPreview: View {
    @State private var fen: String = "" // FEN variable
    
    var body: some View {
        let targetStore = ChessStore(game: Chess.Game(white, against: black))
        // comment next two out to get playable
        //  let FEN = fen
        //  targetStore.game.board.resetBoard(FEN: FEN)
        return BoardView()
            .environmentObject(targetStore)
            .onAppear {
                fen = "8/5k2/3p4/1p1Pp2p/pP2Pp1P/P4P1K/8/8 b - - 99 50" // Initialize fen with the default FEN value
            }
    }
    
    private let black = Chess.Robot(side: .black)
    private let white = Chess.HumanPlayer(side: .white)
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
            TextView(fen: $fenInput) // Pass fenInput as a binding
            SquareTargetedPreviewView()
        }
    }
}

struct ChessView_Previews: PreviewProvider {
    static var previews: some View {
        ChessView()
    }
}

