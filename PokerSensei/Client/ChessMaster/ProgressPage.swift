//
//  NavigationPage.swift
//  PokerSen
//
//  Created by Sadokat Khakimova on 2/23/24.
//

import SwiftUI

struct ProgressPage: View {
    @State private var selectedTimeFrame: TimeFrame = .sevenDays

    enum TimeFrame: String, CaseIterable {
        case sevenDays = "7 days"
        case thirtyDays = "30 days"
        case allTime = "All Time"
    }

    var body: some View {
        NavigationView {
            
            ZStack {
                // Background image
                //Image("background-pic")
                 //   .resizable()
                   // .scaledToFill()
                    //.edgesIgnoringSafeArea(.all)
                    //.opacity(0.5)
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
                                    Text("username00")
                                        .font(.title2)
                                    Spacer()
                                    Image(systemName: "flame.fill")
                                    Text("6")
                                }
                                .padding(.horizontal)
                                .padding(.top, 20)

                                Picker("Timeframe", selection: $selectedTimeFrame) {
                                    ForEach(TimeFrame.allCases, id: \.self) { timeframe in
                                        Text(timeframe.rawValue).tag(timeframe)
                                    }
                                }
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
                                            Text("38")
                                                .font(.headline)
                                            Text("Losses")
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
                                            Text("67")
                                                .font(.headline)
                                            Text("Wins")
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
                                            Text("4")
                                                .font(.headline)
                                            Text("Ties")
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
                                            VStack {
                                                Image(systemName: "star.fill")
                                                Text("Best Game")
                                                    .font(.headline)
                                                Text("Match XYZ")
                                                    .font(.subheadline)
                                            }
                                            .padding(20)
                                            .frame(width:155, height: 90)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                            )
                                            
                                            // Total Games
                                            VStack {
                                                Image(systemName: "number")
                                                Text("Total Games")
                                                    .font(.headline)
                                                Text("109")
                                                    .font(.subheadline)
                                            }
                                            .padding(20)
                                            .frame(width:155, height: 90)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                            )
                                            
                                            // Favorite Move
                                        VStack(alignment: .center) {
                                                Image(systemName: "heart.fill")
                                                Text("Favorite Move")
                                                    .font(.headline)
                                                Text("Queen's Gambit")
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
                                .padding(.leading)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)
//                        .padding(.bottom, 20)
                        
                    }
                    
                    .navigationTitle("PROGRESS")
                }
                
           ) }
            
            
        }
    }
}

struct ProgressPage_Previews: PreviewProvider {
    static var previews: some View {
        ProgressPage()
    }
}
