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
    
    @StateObject private var vm = ChessStore()
    var body: some Scene {
        WindowGroup {
            NavigationPage2()
                .environmentObject(vm)
        }
    }
}
