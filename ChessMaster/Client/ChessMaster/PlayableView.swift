//
//  PlayableView.swift
//  ChessMaster
//
//  Created by Jade Davis on 3/21/24.
//

import SwiftUI
import Chess

struct PlayablePreview: View {
   
    @StateObject private var store: ChessStore
    
    init() {
        // Initialize ChessStore with a sample game
        let black = Chess.Robot(side: .black)
        let white = Chess.HumanPlayer(side: .white)
        let game = Chess.Game(white, against: black)
         
        self._store = StateObject(wrappedValue: ChessStore(game: game))
    
    }
    
    var body: some View {
        VStack {
            BoardView()
                .environmentObject(store)
            }
            .padding()
        }
    }

struct PlayablePreviewView: View {
    
    var body: some View {
        PlayablePreview()
    }
}

struct PlayableView: View {
       
    var body: some View {
        VStack {
           
            PlayablePreviewView()
        }
    }
}

struct PlayableView_Previews: PreviewProvider {
    static var previews: some View {
        PlayableView()
    }
}
