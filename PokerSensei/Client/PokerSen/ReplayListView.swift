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

// button style for the list
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
   
    var body: some View {
        Color(red: 238/255, green: 238/255, blue: 238/255)
            .ignoresSafeArea()
            .overlay(
            
                VStack(alignment: .leading) {
                    
                    HStack{
                        // title
                        Text("REPLAY")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .padding(.horizontal, 25)
                            .padding(.bottom, 20)
                            .padding(.top, 15)
                        
                        Spacer()
                        
                        // profile
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .padding(.horizontal, 25)
                            .padding(.bottom, 20)
                            .padding(.top, 15)
                    }
                    .padding(.top, -130)
                    .padding(.bottom, 5)
                
                    
                    // whole list of replays
                    List {
                        // go through each replay object and render
                        ForEach(replay) { replayItem in
                            HStack{
                                // text on left side (title, date, notes)
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
                                // button on right side
                                Button("Watch Gameplay"){
                                    // TODO: go to replay link
                                }
                                .frame(width: 140, height: 70)
                            }
                            .padding(.vertical, 8)
                            .buttonStyle(ListButton())
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .padding(.top, -70)
                    .shadow(color: Color.gray, radius: 7, x: -0, y: 5)
                    .frame(height: 500)
                }
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ReplayListView()
    }
}

