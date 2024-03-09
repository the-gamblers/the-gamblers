//
//  ReplayListView.swift
//  ChessMaster
//
//  Created by Jade Davis on 2/21/24.
//

import SwiftUI

private var URL = "http://localhost:5211"
private var replay = []

// TODO: match to database schema
struct Replays: Identifiable {
    let title: String
    // let id = UUID()
    let subtitle: String
    let notes: String
    let link: String
}


// fetch all games and return them as an array
func getGames() {
    List<Replays> ret = new List<Replays>()
    fetchData(from: URL+"/api/games") { result in
        switch result {
            case .success(let data, let response):
                guard let httpResponse = response as? HTTPURLResponse, 
                httpResponse.statusCode == 200 else {
                    print("Error fetching games")
                    return
                }
            
                do {
                    let decode = JSONDecoder()
                    let games - try decoder.decode([Game].self, from: data)
                    for game in games {
                        ret.Add(Replays(title: game.title, subtitle: game.subtitle, notes: game.notes, link: game.link))
                    }
                } catch {
                    print("Error decoding games: \(error)")
                }
            
            case .failure(let error):
                print("Error fetching games: \(error)")
        }
    }  

    return ret.ToArray()
}

// TODO: need to read from database
replay = getGames()
// private var replay = [
//     Replays(title: "Game #49", subtitle: "Feb 20, 2024 11:45 PM", notes: "Notes", link: "fjvonevkjwno"),
//     Replays(title: "Game #48", subtitle: "Feb 15, 2024 10:23 PM", notes: "Notes", link: "fjvonevkjwno"),
//     Replays(title: "Game #47", subtitle: "Feb 14, 2024 10:12 PM", notes: "Notes", link: "fjvonevkjwno"),
//     Replays(title: "Game #46", subtitle: "Feb 11, 2024 11:10 PM", notes: "Notes", link: "fjvonevkjwno"),
//     Replays(title: "Game #45", subtitle: "Feb 06, 2024 11:57 PM", notes: "Notes", link: "fjvonevkjwno"),
//     Replays(title: "Game #49", subtitle: "Feb 20, 2024 11:45 PM", notes: "Notes", link: "fjvonevkjwno"),
//     Replays(title: "Game #48", subtitle: "Feb 15, 2024 10:23 PM", notes: "Notes", link: "fjvonevkjwno"),
//     Replays(title: "Game #47", subtitle: "Feb 14, 2024 10:12 PM", notes: "Notes", link: "fjvonevkjwno"),
//     Replays(title: "Game #46", subtitle: "Feb 11, 2024 11:10 PM", notes: "Notes", link: "fjvonevkjwno"),
//     Replays(title: "Game #45", subtitle: "Feb 06, 2024 11:57 PM", notes: "Notes", link: "fjvonevkjwno")
// ]

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
    
    var body: some View {
        NavigationView {
            ZStack{
//                Image("background-pic")
//                    .resizable()
//                    .scaledToFit()
//                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
//                    .opacity(0.5)
                
                Color(red: 238/255, green: 238/255, blue: 238/255)
                    .opacity(0.2)
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
                            .shadow(color: Color.gray, radius: 7, x: -0, y: 5)
                            //.frame(height: 500)
                        })
                }
                // title
                .navigationTitle("REPLAYS")
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button {
                            print("slide up user profile...")
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ReplayListView()
    }
}

