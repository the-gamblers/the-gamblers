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
            .background(Color(red: 0.00, green: 0.38, blue: 0.94).opacity(0.8))
            .font(.caption)
            .foregroundStyle(Color.white).opacity(1)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

// main view
struct ReplayListView: View {
    @State private var showTableView = false
    
    var body: some View {
        NavigationView {
            Color(red: 238/255, green: 238/255, blue: 238/255)
                .ignoresSafeArea()
                .overlay(
                    VStack(alignment: .leading) {
                        
                        // list of replays
                        List {
                            ForEach(replay) { replayItem in
                                HStack {
                                    Button("Image"){ /*TODO: Add img of game*/ }
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
                            
                                    // when replay is pressed, navigate to Table View & see data
                                    NavigationLink(destination: ReplayTableView(replay: replayItem)) {}
                                }
                                .padding(.vertical, 8)
                                .buttonStyle(ListButton())
                            }
                        }
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden)
                        .padding(.top, -75)
                        .shadow(color: Color.gray, radius: 7, x: -0, y: 5)
                        .frame(height: 500)
                })
            
                // title
                .navigationTitle("REPLAYS")
            
                // profile placeholder
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .padding(.horizontal, 15)
                                .padding(.bottom, 20)
                                .padding(.top, 108)
                        }
                    }
                }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ReplayListView()
    }
}

