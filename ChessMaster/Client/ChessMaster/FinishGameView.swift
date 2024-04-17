//
//  FinishGameView.swift
//  ChessMaster
//
//  Created by Sadokat Khakimova on 3/22/24.
//

import SwiftUI
import AVFoundation


struct FinishGameView: View {
//    @State private var cameraSession = AVCaptureSession()
    @State private var navigateToGameSaving = false
//    @Environment(\.presentationMode) var presentationMode
    @Binding var rootPresenting: Bool
    @Binding var gameStartTime: Date?
    
    func endGame() {
        if let startTime = gameStartTime, let gameId = currentGameId {
            let endTime = Date()
            let gameDuration = endTime.timeIntervalSince(startTime)

            let durationString = formatDuration(gameDuration)
            wrapperItem?.updateGameWithDuration(durationString, gameid: gameId)
            gameStartTime = nil

        }
    }
    
    func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: duration) ?? "0:00:00"
    }
    
    var body: some View {
        ZStack {
            Color(red: 238/255, green: 238/255, blue: 238/255)
                .ignoresSafeArea()

            VStack {
                Spacer()


                Button("END GAME") {
                    endGame()
                    navigateToGameSaving = true
                    self.rootPresenting = false
                }
                .font(.headline)
                .foregroundColor(Color.white)
                .padding(.vertical, 15)
                .frame(width: 250)
                .background(RoundedRectangle(cornerRadius: 25).fill(Color(hex: 0x0766AD)))
                .shadow(radius: 5)
                .padding(.bottom, 50)
                
                Spacer()
                
                NavigationLink(destination: GameSavingView(rootPresenting: $rootPresenting), isActive: $navigateToGameSaving) {
                    EmptyView()
//                    self.presentationMode.wrappedValue.dismiss()
                }
                .hidden()
            }
        }
    }

}

struct FinishGameView_Previews: PreviewProvider {
    @State static var rootPresentingPreview = true
    
    static var previews: some View {
        FinishGameView(rootPresenting: $rootPresentingPreview)
    }
}





