//
//  ReplayTableView.swift
//  PokerSen
//
//  Created by Jade Davis on 2/21/24.
//

import SwiftUI

struct ReplayTableView: View {
    let replay: Replays
       
       var body: some View {
           VStack {
               Text("Title: \(replay.title)")
                   .font(.title)
               Text("Subtitle: \(replay.subtitle)")
               Text("Notes: \(replay.notes)")
           }
           .padding()
           .navigationBarTitle("Replay Details", displayMode: .inline)
           .navigationBarBackButtonHidden(false)
       }
}

#Preview {
    ReplayTableView(replay: Replays(title: "Sample Title", subtitle: "Sample Subtitle", notes: "Sample Notes", link: "Sample Link"))
}
