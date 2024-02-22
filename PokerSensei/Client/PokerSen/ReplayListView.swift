//
//  ReplayListView.swift
//  PokerSen
//
//  Created by Jade Davis on 2/21/24.
//

import SwiftUI

// TODO: match to database schema
struct Replays: Identifiable {
    let title: String
    let id = UUID()
    let subtitle: String
    let notes: String
}

// TODO: need to read from database
private var replay = [
    Replays(title: "Game #49", subtitle: "Feb 20, 2024 11:45 PM", notes: "Notes"),
    Replays(title: "Game #48", subtitle: "Feb 15, 2024 10:23 PM", notes: "Notes"),
    Replays(title: "Game #47", subtitle: "Feb 14, 2024 10:12 PM", notes: "Notes"),
    Replays(title: "Game #46", subtitle: "Feb 11, 2024 11:10 PM", notes: "Notes"),
    Replays(title: "Game #45", subtitle: "Feb 06, 2024 11:57 PM", notes: "Notes")
]

struct ReplayListView: View {
    var body: some View {
        VStack(alignment: .leading){
            
            Text("REPLAY")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding()
            
            List {
                ForEach(replay) { replayItem in
                    VStack(alignment: .leading) {
                        Text(replayItem.title)
                            .font(.title3)
                            .bold()
                        Text(replayItem.subtitle)
                            .font(.subheadline)
                        Text(replayItem.notes)
                            .font(.caption)
                    }
                    .padding(.vertical, 8)
                    
                }
            }
        }
    }
}



#Preview {
    ReplayListView()
}
