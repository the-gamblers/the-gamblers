//
//  ProfileView.swift
//  ChessMaster
//
//  Created by Jade Davis on 3/22/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var username: String = ""
    @State private var firstname: String = "Jade"
    @State private var lastname: String = "Davis"
    @State private var password: String = ""
    @State private var showAlert = false
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
                
                TextField("Email Address", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                SecureField("New Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Change Password"), message: Text("Are you sure you want to change the password?"),
                                primaryButton: .default(Text("Yes")) {
                                    // TODO: fix password change
                                    print(password)
                                    let wrapperItem = dbWrapper(title: "/Users/jadedavis/Documents/gambs-sprint-4-2/ChessMaster/Client/ChessMaster/test")
                                    wrapperItem?.changePassword(password)
                                    print(wrapperItem?.testy())
                            
                            },
                            secondaryButton: .cancel(Text("No")))
                        }
                Button(action: {
                               // Display alert
                               showAlert = true
                           }) {
                               Text("Change Password")
                                   .padding()
                                   .frame(maxWidth: .infinity)
                                   .background(Color.blue)
                                   .foregroundColor(.white)
                                   .cornerRadius(25)
                                   .padding(.horizontal)
                           }
    
                Button(action: {
                    // TODO: Perform logout action
                    print("Logout button pressed")
                    isLoggedin = false
                    print(isLoggedin)
                    UserDefaults.standard.removeObject(forKey: "username")
                    UserDefaults.standard.removeObject(forKey: "password")
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
                if isLoggedin == false {
                    Text("Logging Out...")
                        .padding(.top, 20)
                        .background(
                            NavigationLink(destination: LandingLoginView(isLoggedin: $isLoggedin)){
                                                   EmptyView()
                        })
                }
            }
            .padding()
            .onAppear {
                // Retrieve saved credentials
                username = UserDefaults.standard.string(forKey: "username") ?? ""
                // Password retrieval can be insecure; use a secure storage option for sensitive data
                password = UserDefaults.standard.string(forKey: "password") ?? ""
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLoggedin: .constant(false))
    }
}
