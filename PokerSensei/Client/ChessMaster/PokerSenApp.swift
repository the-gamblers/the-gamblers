//
//  PokerSenApp.swift
//  PokerSen
//
//  Created by Jade Davis on 2/19/24.
//

import SwiftUI
import Chess

@main
struct PokerSenApp: App {
    @State var isLoggedin: Bool = false
    @StateObject private var vm = ChessStore()
    
    var body: some Scene {
        WindowGroup {
            if isLoggedin {
                NavigationPage2()
                    .environmentObject(vm)
            }
            else {
                LandingLoginView(isLoggedin: $isLoggedin)
            }
        }
    }
}
