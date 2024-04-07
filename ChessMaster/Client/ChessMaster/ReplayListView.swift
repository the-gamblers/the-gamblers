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
    let gameID: String
    let user: String
    let date: String
    let title: String
    let notes: String
    let uci: String
    let fen: String
}
// read from database, get list of games with (user,title,etc) in form of Replay
//private var replay = parseReplays(data: getGamesFromDB(username: userName, password: passWord))

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
    @State private var passWord: String = ""
    @State private var userName: String = ""
    @State private var replay: [Replays] = []
    @Binding var isLoggedin: Bool

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
                                        NavigationLink(destination: ReplayTableView(replay: replayItem, isLoggedin: $isLoggedin)) {}
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
                ProfileView(isLoggedin: $isLoggedin)
            }
        }
        .onAppear {
            // Retrieve saved credentials
            userName = UserDefaults.standard.string(forKey: "username") ?? ""
            // Password retrieval can be insecure; use a secure storage option for sensitive data
            passWord = UserDefaults.standard.string(forKey: "password") ?? ""
            // Initialize replay using the retrieved username and password
            replay = parseReplays(data: getGamesFromDB())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ReplayListView(isLoggedin: .constant(true))
    }
}

