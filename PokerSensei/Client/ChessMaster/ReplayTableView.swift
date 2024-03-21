//
//  GameStats.swift
//  PokerSen
//
//  Created by Sadokat Khakimova on 3/2/24.
//

import SwiftUI

struct ReplayTableView: View {
    let replay: Replays
    let moves = ["1. d4 d6", "2. f4 c5", "3. c3 f5", "4. f3 f6"]
    @State private var currentMoveIndex = 0


    var body: some View {
        ZStack{
//            Image("background-pic") // background image
//                .resizable()
//                .scaledToFill()
//                .edgesIgnoringSafeArea(.all)
//                .opacity(0.3)
            
            ScrollView {
                VStack {
                    // Game title and notes
                    Text(replay.title)
                        .font(.title)
                        .bold()
                    Text(replay.subtitle)
                        .font(.subheadline)
                    Text("Notes: \(replay.notes)")
                        .font(.caption)
                        .padding(.bottom)
                    
                    // Analysis section
                    Text("Analysis")
                        .font(.headline)
                        .padding(.bottom, 10)
                    HStack {
                        Text("+7.21").bold()
                        Text("b5 dxe3 fxe5 dxe5 c7+ Qe7 xe5 bd7 xd7 xd7 xa8 Qf6").lineLimit(1)
                    }
                    HStack {
                        Text("-1.51").bold()
                        Text("fxe5 dxe5 Ab5 aa6 Ad2 ee6 Axe5 d8 Ad3 ae3 Af4 a6").lineLimit(1)
                    }
                    .padding(.bottom, 20)
                    
                    // View Chess Board
                    ChessView()
                        .frame(height: 650)
                }
                .padding()
            }
        }
        .navigationBarTitle("\(replay.title) Details", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            // Add your action here
        }) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.black)
        })
    }
}

struct ReplayTableView_Previews: PreviewProvider {
    static var previews: some View {
        ReplayTableView(replay: Replays(title: "Game #13", subtitle: "Feb 14, 2024 10:12 PM", notes: "You are making simple mistakes", link: "Sample Link"))
    }
}
