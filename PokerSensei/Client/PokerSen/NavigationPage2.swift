//
//  NavigationPage.swift
//  PokerSen
//
//  Created by Sadokat Khakimova on 2/23/24.
//

import SwiftUI

struct NavigationPage2: View {
    @State private var selection: Tab = .home

    enum Tab {
        case statistics
        case home
        case replay
    }

    var body: some View {
        TabView(selection: $selection) {
            StatisticsPage()
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
                .tag(Tab.statistics)
            
            HomePage()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)
            
            ReplayListView()
                .tabItem {
                    Label("Replay", systemImage: "arrow.triangle.2.circlepath")
                }
                .tag(Tab.replay)
        }
        .font(.title2)
        .ignoresSafeArea(.keyboard)
    }
}

// Preview of NavigationView
struct NavigationView_Previews2: PreviewProvider {
    static var previews: some View {
        NavigationPage2()
    }
}
