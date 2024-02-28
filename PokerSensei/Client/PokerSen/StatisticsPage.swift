//
//  StatisticsPage.swift
//  PokerSen
//
//  Created by Sadokat Khakimova on 2/25/24.
//

import SwiftUI

struct StatisticsPage: View {
    let handHistory = [
        (hand: "Hand 1", winner: "YES"),
        (hand: "Hand 2", winner: "NO"),
        (hand: "Hand 3", winner: "YES")
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Each section header
                    SectionHeader(title: "Hand History")
                    ForEach(handHistory, id: \.hand) { history in
                        HistoryRow(hand: history.hand, winner: history.winner)
                    }

                    Divider()

                    SectionHeader(title: "Recommendations")
                    RecommendationContent()

                    Divider()

                    SectionHeader(title: "Tips & Tricks")
                    TipsTricksContent()
                }
                .padding()
            }
            .navigationTitle("Game # Stats")
            .navigationBarItems(trailing: Button(action: {
            }) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.black)
            })
        }
    }
}

struct HistoryRow: View {
    let hand: String
    let winner: String
    
    var body: some View {
        HStack {
            Text(hand)
            Spacer()
            Text(winner)
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 25).fill(Color.white))
        .shadow(radius: 3)
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title)
            .bold()
            .padding(.bottom, 5)
    }
}

struct RecommendationContent: View {
    var body: some View {
        Text("Watch some tutorials dude!")
            .padding()
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.white))
            .shadow(radius: 3)
    }
}

struct TipsTricksContent: View {
    var body: some View {
        Text("Fold it unsure!")
            .padding()
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.white))
            .shadow(radius: 3)
    }
}

struct StatisticsPage_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsPage()
    }
}

