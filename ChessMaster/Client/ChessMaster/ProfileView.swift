//
//  ProfileView.swift
//  ChessMaster
//
//  Created by Jade Davis on 3/22/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var email: String = "Jade@example.com"
    @State private var firstname: String = "Jade"
    @State private var lastname: String = "Davis"
    @State private var isEditing: Bool = false
    @Binding var isLoggedin: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 20)
                
                TextField("First Name", text: $firstname)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                TextField("Last Name", text: $lastname)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                TextField("Email Address", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                Button(action: {
                    // TODO: Perform logout action
                    isLoggedin = false
                }) {
                    Text("Logout")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .padding(.horizontal)
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLoggedin: .constant(true))
    }
}
