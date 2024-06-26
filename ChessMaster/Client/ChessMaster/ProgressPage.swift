//
//  NavigationPage.swift
//  ChessMaster
//
//  Created by Sadokat Khakimova on 2/23/24.
//

import SwiftUI

struct ProgressPage: View {
//    @State private var selectedTimeFrame: TimeFrame = .allTime
//
//    enum TimeFrame: String, CaseIterable {
////        case sevenDays = "7 days"
////        case thirtyDays = "30 days"
//        case allTime = "All Time"
//    }
    @State private var username: String = ""
    @State private var wins: Int = 0
    @State private var losses: Int = 0
    @State private var draws: Int = 0
    @State private var totalGames: Int = 0


//    func fetchUserStats() {        
//        if let stats = wrapperItem?.getUserStats(username) as? [String: NSNumber] {
//
//            wins = stats["wins"]?.intValue ?? 0
//            losses = stats["losses"]?.intValue ?? 0
//            draws = stats["draws"]?.intValue ?? 0
//        }
//    }
    
    func fetchUserStats() {
        // Check if stats fetching is called
        if let stats = wrapperItem?.getUserStats(username) as? [String: NSNumber] {
        
            // Update the UI
            DispatchQueue.main.async {
                self.wins = stats["wins"]?.intValue ?? 0
                self.losses = stats["losses"]?.intValue ?? 0
                self.draws = stats["draws"]?.intValue ?? 0
            }
        }
    }
    
    func fetchTotalGames(for username: String) -> Int {
        return wrapperItem?.getTotalGames(username) ?? 0
    }


    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 238/255, green: 238/255, blue: 238/255)
                    .opacity(0.2)
                    .ignoresSafeArea()
                    .overlay(
                // rounded rectangle background
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white)
                                .shadow(radius: 5)

                            VStack {
                                HStack {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                    Text(username)
                                        .font(.title2)
                                    Spacer()
//                                    Image(systemName: "flame.fill")
//                                    Text("6")
                                }
                                .padding(.horizontal)
                                .padding(.top, 20)

//                                Picker("Timeframe", selection: $selectedTimeFrame) {
//                                    ForEach(TimeFrame.allCases, id: \.self) { timeframe in
//                                        Text(timeframe.rawValue).tag(timeframe)
//                                    }
//                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding()

                                VStack(alignment: .leading, spacing: 20) {

                                    HStack {
                                        Spacer()
                                        // losses
                                        VStack{
                                            Image(systemName: "hand.thumbsdown.fill")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                            Text("\(losses)")
                                                .font(.headline)
                                            Text("losses")
                                                .font(.subheadline)
                                        }
                                        .padding(20)
                                        .frame(width: 90, height: 100)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1))
                                        Spacer()
                                        // wins
                                        VStack{
                                            Image(systemName: "trophy.fill")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                            Text("\(wins)")
                                                .font(.headline)
                                            Text("wins")
                                                .font(.subheadline)
                                        }
                                        .padding(20)
                                        .frame(width: 90, height: 100)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1))
                                        Spacer()
                                        // ties
                                        VStack{
                                            Image(systemName: "person.line.dotted.person.fill")
                                            Text("\(draws)")
                                                .font(.headline)
                                            Text("draws")
                                                .font(.subheadline)
                                        }
                                        .padding(20)
                                        .frame(width: 90, height: 100)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1))
                                        Spacer()
                                    }
                                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)], spacing: 20) {
                                        
                                        // Avg Time
                                        VStack {
                                            Image(systemName: "clock.fill")
                                            Text("Avg Time")
                                                .font(.headline)
                                            Text("2 hours")
                                                .font(.subheadline)
                                        }
                                        .padding(20)
                                        .frame(width:155, height: 90)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                        )
                                            
                                            // Best Game
//                                            VStack {
//                                                Image(systemName: "star.fill")
//                                                Text("Best Game")
//                                                    .font(.headline)
//                                                Text("Match XYZ")
//                                                    .font(.subheadline)
//                                            }
//                                            .padding(20)
//                                            .frame(width:155, height: 90)
//                                            .overlay(
//                                                RoundedRectangle(cornerRadius: 10)
//                                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
//                                            )
                                            
                                            // Total Games
                                            VStack {
                                                Image(systemName: "number")
                                                Text("Total Games")
                                                    .font(.headline)
                                                Text("\(totalGames)")
                                                    .font(.subheadline)
                                            }
                                            .padding(20)
                                            .frame(width:155, height: 90)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                            )
                                            
                                       
                                        Spacer()
                                    }
                                    .padding(.top, 20)
                                }
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)
                                            
                        NavigationLink(destination: PlayableView()) {
                            VStack {
                                HStack {
                                    Image(systemName: "gamecontroller")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 30)
                                    Text("Play Against a Bot!")
                                        .padding()
                                }
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                            }
                        }
                        .padding()
                        .padding(.leading, 40)
                    }
                    .navigationTitle("PROGRESS")
                }
           ) }
            
            

            .onAppear {
                self.username = UserDefaults.standard.string(forKey: "username") ?? "Default Username"
                fetchUserStats()
                self.totalGames = fetchTotalGames(for: username)
//                wrapperItem?.getUserStats(username)
             }

        }
    }
}

struct ProgressPage_Previews: PreviewProvider {
    static var previews: some View {
        ProgressPage()
    }
}
