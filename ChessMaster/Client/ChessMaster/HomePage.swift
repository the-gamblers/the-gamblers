//
//  HomePage.swift
//  ChessMaster
//
//  Created by Sadokat Khakimova on 2/28/24.
//


import SwiftUI
import UIKit

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }
}


struct HomePage: View {
    @State private var showProfile = false
    @Binding var isLoggedin: Bool
       
    func showProfileView() {
        showProfile.toggle()
    }
    
    @State private var navigateToFinishGame = false
    
    var body: some View {
        NavigationView {
            ZStack{
                Image("background-pic")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.5)
                
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(hex: 0xF3F3F3))
                    .frame(width: UIScreen.main.bounds.width * 0.85, height: 350)
                    .shadow(radius: 50)
                
                VStack {
                    Spacer(minLength: 100) // Pushes everything down

                    //Text("Home")
                    //.font(.largeTitle)
                    //.fontWeight(.bold)
                    //.padding(.bottom, 30)
                    //
                    VStack{
                        
                        Image("app-icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
//                            .padding(.bottom, 70)
                        
                        Text("ChessVision")
                            .font(.title)
                            .fontWeight(.heavy)
                            .lineLimit(nil)
                            .padding(.bottom, 20)
                    }
//                    .padding()
//                    .background(Circle().fill(Color.white))
//                    .shadow(radius: 10)
                    
                    NavigationLink(destination: ProgressPage()) {
                        OverallStatisticsContent()
                    }
                    .padding(.bottom, 20)
                    
                    NavigationLink(destination: FinishGameView(), isActive: $navigateToFinishGame) { EmptyView() }
                    
//                    NavigationLink(destination: FinishGameView()) {
//                        StartGameContent()
//                    }
                    
                    Button(action: {
                        startNewGame()
                    }) {
                        StartGameContent()
                    }
                    
                    Spacer()
                }
                .background(Color("bkColor").ignoresSafeArea())
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button(action: {showProfile = true}) {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.black)
                                })
                                .sheet(isPresented: $showProfile) {
                                                ProfileView(isLoggedin: $isLoggedin)
                                }
            }
        }
    }
    
    func startNewGame() {
        // Call create_game() to add an empty game entry to the
        wrapperItem?.createGame(withTitle: "", notes: "", uci: "", fen: "")
        
        // Trigger navigation to FinishGameView
        navigateToFinishGame = true
    }
}

struct OverallStatisticsContent: View {
    var body: some View {
        Text("Overall Progress")
            .font(.headline)
            .foregroundColor(Color.white)
            .padding(.vertical, 10)
            .frame(width: 250)
            .background(RoundedRectangle(cornerRadius: 25).fill(Color(hex: 0x0766AD)))
            .shadow(radius: 5)
    }
}

struct StartGameContent: View {
    var body: some View {
        Text("Start Game")
            .font(.headline)
            .foregroundColor(Color.white)
            .padding(.vertical, 10)
            .frame(width: 250)
            .background(RoundedRectangle(cornerRadius: 25).fill(Color(hex: 0x29ADB2)))
            .shadow(radius: 5)
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage(isLoggedin: .constant(true))
    }
}
