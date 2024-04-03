//
//  NavigationPage.swift
//  ChessMaster
//
//  Created by Sadokat Khakimova on 2/23/24.
//

import SwiftUI

struct NavigationPage2: View {
    @State private var selection: Tab = .home
    @Binding var isLoggedin: Bool

    enum Tab {
        case statistics
        case home
        case replay
    }

    var body: some View {
        NavigationView{
            TabView(selection: $selection) {
                ProgressPage()
                    .tabItem {
                        Label("Progress", systemImage: "chart.bar.fill")
                            .font(.title2.bold())
                            .foregroundColor(.accentColor)
                    }
                    .tag(Tab.statistics)
                
                HomePage(isLoggedin: $isLoggedin)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                            .font(.title2.bold())
                            .foregroundColor(.accentColor)
                    }
                    .tag(Tab.home)
                
                ReplayListView()
                    .tabItem {
                        Label("Replay", systemImage: "arrow.triangle.2.circlepath")
                            .font(.title2.bold())
                            .foregroundColor(.accentColor)
                    }
                    .tag(Tab.replay)
            }
            .font(.title2)
            .ignoresSafeArea(.keyboard)
        }
    }
}

// Preview of NavigationView
struct NavigationView_Previews2: PreviewProvider {
    static var previews: some View {
        NavigationPage2(isLoggedin: .constant(true))
    }
}
