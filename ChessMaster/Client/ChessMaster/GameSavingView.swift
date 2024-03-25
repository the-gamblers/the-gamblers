//
//  GameSavingView.swift
//  ChessMaster
//
//  Created by Sadokat Khakimova on 3/24/24.
//

import SwiftUI

struct GameSavingView: View {
    @State private var gameTitle: String = "Great Game"
    @State private var notes: String = ""
    @State private var showSaveConfirmation = false
    
    var body: some View {
        VStack {
            Text(gameTitle)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding()
            
            Text("Finished Game at \(getTimeString())")
//                .padding([.leading, .top])
            Text(getDateString())
                .padding([.leading, .top])
            
            .padding(.bottom, 50)
            
            HStack(alignment: .center, spacing: 5) {
                Text("Change the Title")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .frame(width: 150, alignment: .leading)
                
                TextField("", text: $gameTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.primary)
            }
            .padding(.horizontal)

            HStack(alignment: .top, spacing: 5) {
                Text("Add notes")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .frame(width: 150, alignment: .leading)
                    .padding(.top, 8)
                
                TextEditor(text: $notes)
                    .foregroundColor(.primary)
                    .frame(height: 150)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            }
            .padding(.horizontal)

            Spacer()
            
            Button("FINISH") {
                // save the game and show confirmation
                saveGameDetails()
                showSaveConfirmation = true
            }
            .font(.headline)
            .foregroundColor(Color.white)
            .padding(.vertical, 15)
            .frame(width: 250)
            .background(RoundedRectangle(cornerRadius: 25).fill(Color(hex: 0x0766AD)))
            .shadow(radius: 5)
            .padding(.bottom, 50)
            .alert(isPresented: $showSaveConfirmation) {
                Alert(title: Text("Game Saved"), message: Text("Successfully saved the game and added to the replay page"), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }
    
    func getTimeString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
    
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
    
    func saveGameDetails() {
    }
}

struct GameSavingView_Previews: PreviewProvider {
    static var previews: some View {
        GameSavingView()
    }
}
