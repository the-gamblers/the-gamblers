//
//  HomePage.swift
//  PokerSen
//
//  Created by Sadokat Khakimova on 2/28/24.
//


import SwiftUI

struct HomePage: View {

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Each section header
                    Spacer()
                    OverallStatisticsContent()

//                    Divider()

                    StartGameContent()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .navigationTitle("Home Page")
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



struct OverallStatisticsContent: View {
    var body: some View {
        VStack {
            Text("Overall Statistics")
                .font(.headline)
                .foregroundColor(.blue)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 50).fill(Color.blue.opacity(0.1)))
        .shadow(radius: 5)
        .frame(maxWidth: .infinity)
    }
}

struct StartGameContent: View {
    var body: some View {
        VStack {
            Text("Start Game")
                .font(.headline)
                .foregroundColor(.blue)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 50).fill(Color.blue.opacity(0.1)))
        .shadow(radius: 5)
        .frame(maxWidth: .infinity)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}


