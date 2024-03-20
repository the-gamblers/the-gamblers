import SwiftUI
import Chess

struct TextView: View {
    @State private var fenInput: String = ""
    @EnvironmentObject var store: ChessStore
    
    var body: some View {
        VStack {
            TextField("Enter FEN String", text: $fenInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
        }
    }
}

struct SquareTargetedPreview: PreviewProvider {
    @State private var fen: String = "" // FEN variable
    
    static let targetStore: ChessStore = {
        let FEN = "r4r2/1pp4k/p3P2p/2Pp1p2/bP5Q/P3q3/1B1n4/K6R b - - 1 33"
        let black = Chess.HumanPlayer(side: .black)
        let white = Chess.HumanPlayer(side: .white)
        var game = Chess.Game(white, against: black)
        game.board.resetBoard(FEN: FEN)
        ChessStore.userTappedSquare(.e3, game: &game)
        let store = ChessStore(game: game)
        store.environment.theme.color = .blue
        return store
    }()
    
    static var previews: some View {
        BoardView()
            .environmentObject(targetStore)
    }
}

struct SquareTargetedPreviewView: View {
    @EnvironmentObject var targetStore: ChessStore
    
    var body: some View {
        let targetStore = SquareTargetedPreview.targetStore
        
        return BoardView()
            .environmentObject(targetStore)
    }
}

struct ChessView: View {
    @State private var fenInput: String = ""
    @EnvironmentObject var store: ChessStore
    
    var body: some View {
        VStack {
            TextView()
            BoardView()
        }
    }
}

struct ChessView_Previews: PreviewProvider {
    static var previews: some View {
        let black = Chess.HumanPlayer(side: .black) // Placeholder for black player
        let white = Chess.HumanPlayer(side: .white) // Placeholder for white player
        let store = ChessStore(game: Chess.Game(white, against: black)) // Create ChessStore with the players
        return ChessView()
            .environmentObject(store) // Provide ChessStore as environment object
        
    }
}
