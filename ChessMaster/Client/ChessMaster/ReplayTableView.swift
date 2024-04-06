//
//  GameStats.swift
//  ChessMaster
//
//  Created by Sadokat Khakimova on 3/2/24.
//

import SwiftUI

struct ReplayTableView: View {
    let replay: Replays
    @State private var currentMoveIndex = 0
    @State private var showProfile = false
    @Binding var isLoggedin: Bool
        
    func showProfileView() {
            showProfile.toggle()
        }

    var body: some View {
        ZStack{
            ScrollView {
                VStack {
                    // Game title and notes
                    Text(replay.title)
                        .font(.title)
                        .bold()
                    Text(replay.date)
                        .font(.subheadline)
                    Text("Notes: \(replay.notes)")
                        .font(.caption)
                        .padding(.bottom)
                    // Analysis section
                    Text("Analysis")
                        .font(.headline)
                        .padding(.bottom, 10)
                    
                    // View Chess Board
                    ChessView(replay: replay)
                        .frame(height: 650)
                }
                .padding()
            }
        }
        .navigationBarTitle("\(replay.title) Details", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {showProfile = true}) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.black)
        })
        .sheet(isPresented: $showProfile) {
            ProfileView(isLoggedin: $isLoggedin)
        }
    }
}

struct ReplayTableView_Previews: PreviewProvider {
    static var previews: some View {
        ReplayTableView(replay: Replays(gameID: "1", user: "jade", date: "Feb 20, 2024 11:45 PM", title: "Game #49", notes: "Notes", uci:  "b2b3 d7d5 f2f3 h7h5 d2d3 a7a6 b3b4 d5d4", fen: "rnbqkbnr ppppppppRNBQKBNR"), isLoggedin: .constant(true))
    }
}
