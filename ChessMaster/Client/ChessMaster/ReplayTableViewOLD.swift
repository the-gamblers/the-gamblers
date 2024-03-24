//
//  ReplayTableView.swift
//  ChessMaster
//
//  Created by Jade Davis on 2/21/24.
//

import SwiftUI

struct ReplayTableViewOLD: View {
    let replay: Replays
    
    var body: some View {
        Color(red: 238/255, green: 238/255, blue: 238/255)
            .ignoresSafeArea()
            .overlay(
                VStack {
                    Text("\(replay.title)")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text("\(replay.subtitle)")
                        .font(.title2)
                    Text("Notes: \(replay.notes)")
                    Image("chess-table")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    HStack{
                       // play/pause/ffward
                    }
                    .background(Color.gray)
                    
                    Spacer()
                }
                    .padding()
                    .navigationBarTitle("\(replay.title) Details", displayMode: .inline)
                    .toolbar {
                        ToolbarItemGroup(placement: .primaryAction) {
                            Button {
                                print("About tapped!")
                            }
                            label: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .navigationBarBackButtonHidden(false)
                
        )
    }
}

#Preview {
    ReplayTableViewOLD(replay: Replays(title: "Game #13", subtitle: "Feb 14, 2024 10:12 PM", notes: "did this, that, and whatnot", link: "Sample Link"))
}
