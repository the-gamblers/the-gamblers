//
//  ReplayListView.swift
//  ChessMaster
//
//  Created by Jade Davis on 2/21/24.
//

import SwiftUI

// TODO: match to database schema
struct Replays: Identifiable {
    let id = UUID()
    let user: String
    let title: String
    let date: String
    let notes: String
    let uci: String
    let fen: [String]
}

// TODO: need to read from database, get list of games with (user,title,etc) in form of Replay item like below 
private var replay = [
    Replays(user: "jade", title: "Game #49", date: "Feb 20, 2024 11:45 PM", notes: "Notes", uci: "e2e4 b3b5 g7g5 a2a4",fen: ["rnbqkbnr", "pppppppp", "RNBQKBNR" ]),
    Replays(user: "jade", title: "Game #59", date: "Feb 20, 2024 11:45 PM", notes: "Notes", uci:  "b2b3 d7d5 f2f3 h7h5 d2d3 a7a6 b3b4 d5d4", fen: ["rnbqkbnr", "pppppppp", "RNBQKBNR" ]),
    Replays(user: "jade", title: "Game #69", date: "Feb 20, 2024 11:45 PM", notes: "Notes", uci: "e2e4 b3b5",fen: ["rnbqkbnr", "pppppppp", "RNBQKBNR" ]),
    Replays(user: "jade", title: "Game #79", date: "Feb 20, 2024 11:45 PM", notes: "Notes", uci: "e2e4 b3b5 g7g5 a2a4", fen: ["rnbqkbnr", "pppppppp", "RNBQKBNR" ]),
    Replays(user: "jade", title: "Game #49", date: "Feb 20, 2024 11:45 PM", notes: "Notes", uci: "e2e4 b3b5 g7g5 a2a4", fen: ["rnbqkbnr", "pppppppp", "RNBQKBNR" ]),
    Replays(user: "jade", title: "Game #49", date: "Feb 20, 2024 11:45 PM", notes: "Notes", uci: "e2e4 b3b5 g7g5 a2a4", fen: ["rnbqkbnr", "pppppppp", "RNBQKBNR" ]),
    Replays(user: "jade", title: "Game #49", date: "Feb 20, 2024 11:45 PM", notes: "Notes", uci: "e2e4 b3b5 g7g5 a2a4", fen: ["rnbqkbnr", "pppppppp", "RNBQKBNR" ]),
    Replays(user: "jade", title: "Game #49", date: "Feb 20, 2024 11:45 PM", notes: "Notes", uci: "e2e4 b3b5 g7g5 a2a4", fen: ["rnbqkbnr", "pppppppp", "RNBQKBNR" ]),
    Replays(user: "jade", title: "Game #49", date: "Feb 20, 2024 11:45 PM", notes: "Notes", uci: "e2e4 b3b5 g7g5 a2a4", fen: ["rnbqkbnr", "pppppppp", "RNBQKBNR" ]),
    Replays(user: "jade", title: "Game #49", date: "Feb 20, 2024 11:45 PM", notes: "Notes", uci: "e2e4 b3b5 g7g5 a2a4", fen: ["rnbqkbnr", "pppppppp", "RNBQKBNR" ])
]

// button style for the list (for later)
struct ListButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.gray)
            .font(.caption)
            .foregroundStyle(Color.white).opacity(1)
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
    }
}

// main view
struct ReplayListView: View {
    @State private var showTableView = false
    @State private var showProfile = false // Step 1

    // Step 2
    func showProfileView() {
        showProfile.toggle()
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 238/255, green: 238/255, blue: 238/255)
                    .opacity(0.2)
                    .ignoresSafeArea()
                    .overlay(
                        VStack(alignment: .leading) {
                            // list of replays
                            List {
                                ForEach(replay) { replayItem in
                                    HStack {
                                        Button("Image") {
                                            // TODO: Add img of game
                                        }
                                        VStack(alignment: .leading) {
                                            Text(replayItem.title)
                                                .font(.title3)
                                                .bold()
                                            Text(replayItem.date)
                                                .font(.subheadline)
                                            Text(replayItem.notes)
                                                .font(.caption)
                                        }
                                        Spacer()
                                        NavigationLink(destination: ReplayTableView(replay: replayItem)) {}
                                    }
                                    .padding(.vertical, 8)
                                    .buttonStyle(ListButton())
                                }
                            }
                            .listStyle(.insetGrouped)
                            .scrollContentBackground(.hidden)
                            .shadow(color: Color.gray, radius: 7, x: -0, y: 5)
                        })
            }
            .navigationTitle("REPLAYS")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button(action: {showProfile = true}) { // Step 3
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(isPresented: $showProfile) {
                ProfileView(isLoggedin: .constant(true))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ReplayListView()
    }
}

