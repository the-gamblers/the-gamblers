//
//  GameSavingView.swift
//  ChessMaster
//
//  Created by Sadokat Khakimova on 3/24/24.
//

import SwiftUI

struct GameSavingView: View {
    @State private var username: String = UserDefaults.standard.string(forKey: "username") ?? "Unknown User"
    @State private var gameTitle: String = "Great Game"
    @State private var notes: String = ""
    @State private var showSaveConfirmation = false
    @State private var shouldNavigateToReplayList = false
    @State private var isSelected = false
    @State private var isSelected2 = false
    @State private var isSelected3 = false
    @State private var isUserLoggedIn = false
    
    var body: some View {
        NavigationView{
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
                
                Text("How did the game end?")
                    .font(.headline)
                    .padding(.top)
                
                HStack {
                    Button(action: {
                        self.isSelected.toggle()
                        if self.isSelected {
                            self.isSelected2 = false
                            self.isSelected3 = false
                        }
                    }) {
                        Text("win")
                            .foregroundColor(isSelected ? .white : .blue)
                            .padding()
                            .background(isSelected ? Color.blue : Color.clear)
                            .cornerRadius(5)
                    }
                    
                    // Button-like toggle for "No"
                    Button(action: {
                        self.isSelected2.toggle()
                        if self.isSelected2 {
                            self.isSelected = false
                            self.isSelected3 = false
                        }
                    }) {
                        Text("loss")
                            .foregroundColor(isSelected2 ? .white : .red)
                            .padding()
                            .background(isSelected2 ? Color.red : Color.clear)
                            .cornerRadius(5)
                    }
                    
                    // Additional button option
                    Button(action: {
                        self.isSelected3.toggle()
                        if self.isSelected3 {
                            self.isSelected = false
                            self.isSelected2 = false
                        }
                    }) {
                        Text("draw")
                            .foregroundColor(isSelected3 ? .white : .green)
                            .padding()
                            .background(isSelected3 ? Color.green : Color.clear)
                            .cornerRadius(5)
                    }
                }
                
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
                    Alert(title: Text("Game Saved"), message: Text("Successfully saved the game and added to the replay page"), dismissButton: .default(Text("OK")){
                        shouldNavigateToReplayList = true
                    }
                          
                    )
                }
                
                NavigationLink(destination: ReplayListView(isLoggedin: $isUserLoggedIn), isActive: $shouldNavigateToReplayList) { EmptyView() }
            }
            .padding()
        }
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
        print("Saving game for user: \(username)")
        wrapperItem?.editTitle(gameTitle)
        wrapperItem?.editNote(notes)
        
        
        let gameResult = isSelected ? "win" : isSelected2 ? "loss" : isSelected3 ? "draw" : ""
        
        print("Game result is: \(gameResult)")
        
        wrapperItem?.recordGameResult(forUser: username, result: gameResult)
    }
}

struct GameSavingView_Previews: PreviewProvider {
    static var previews: some View {
        GameSavingView()
    }
}
