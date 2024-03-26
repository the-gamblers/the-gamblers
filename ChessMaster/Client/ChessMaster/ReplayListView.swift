//
//  ReplayListView.swift
//  ChessMaster
//
//  Created by Jade Davis on 2/21/24.
//

import SwiftUI

// TODO: match to database schema
// FIXME: user, date, title, note, uci
struct Replays: Identifiable {
    let title: String
    let id = UUID()
    let subtitle: String
    let notes: String
    let link: String
}

// TODO: need to read from database
private var replay = [
    Replays(title: "Game #49", subtitle: "Feb 20, 2024 11:45 PM", notes: "Notes", link: "fjvonevkjwno"),
    Replays(title: "Game #48", subtitle: "Feb 15, 2024 10:23 PM", notes: "Notes", link: "fjvonevkjwno"),
    Replays(title: "Game #47", subtitle: "Feb 14, 2024 10:12 PM", notes: "Notes", link: "fjvonevkjwno"),
    Replays(title: "Game #46", subtitle: "Feb 11, 2024 11:10 PM", notes: "Notes", link: "fjvonevkjwno"),
    Replays(title: "Game #45", subtitle: "Feb 06, 2024 11:57 PM", notes: "Notes", link: "fjvonevkjwno"),
    Replays(title: "Game #49", subtitle: "Feb 20, 2024 11:45 PM", notes: "Notes", link: "fjvonevkjwno"),
    Replays(title: "Game #48", subtitle: "Feb 15, 2024 10:23 PM", notes: "Notes", link: "fjvonevkjwno"),
    Replays(title: "Game #47", subtitle: "Feb 14, 2024 10:12 PM", notes: "Notes", link: "fjvonevkjwno"),
    Replays(title: "Game #46", subtitle: "Feb 11, 2024 11:10 PM", notes: "Notes", link: "fjvonevkjwno"),
    Replays(title: "Game #45", subtitle: "Feb 06, 2024 11:57 PM", notes: "Notes", link: "fjvonevkjwno")
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
                                            Text(replayItem.subtitle)
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

