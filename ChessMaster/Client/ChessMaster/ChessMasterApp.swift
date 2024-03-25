//
//  ChessMasterApp.swift
//  ChessMaster
//
//  Created by Jade Davis on 2/19/24.
//

import SwiftUI
import Chess

@main
struct ChessMasterApp: App {
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
