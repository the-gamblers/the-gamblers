//
//  ProfileView.swift
//  ChessMaster
//
//  Created by Jade Davis on 3/22/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var origPassword: String = ""
    @State private var showChangeAlert = false
    @State private var showDeleteAlert = false
    @State private var isEditing: Bool = false
    @State private var showPassword: Bool = false
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
                TextField("Email Address", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                
                ZStack(alignment: .trailing) {
                        if showPassword {
                            TextField("Password", text: $password)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(20)
                                    .padding(.horizontal)
                                    .autocapitalization(.none)
                            } else {
                                SecureField("Password", text: $password)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(20)
                                    .padding(.horizontal)
                                    .autocapitalization(.none)
                            }
                            
                            Button(action: {
                                self.showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .padding(.trailing, 30)
                            }
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical)
            
                Button(action: {
                               // Display change password alert
                               showChangeAlert = true
                           }) {
                               Text("Change Password")
                                   .padding()
                                   .frame(maxWidth: .infinity)
                                   .background(Color.blue)
                                   .foregroundColor(.white)
                                   .cornerRadius(25)
                                   .padding(.horizontal)
                                   .alert(isPresented: $showChangeAlert) {
                                       Alert(title: Text("Change Password"), message: Text("Are you sure you want to change your password?"),
                                               primaryButton: .default(Text("Yes")) {
                                               wrapperItem?.checkUser(username, password: origPassword)
                                               wrapperItem?.changePassword(password)
                                    
                                               },
                                               secondaryButton: .cancel(Text("No")))
                                       }
                           }
    
                Button(action: {
                    // Perform logout action
                    print("Logout button pressed")
                    isLoggedin = false
                    UserDefaults.standard.removeObject(forKey: "username")
                    UserDefaults.standard.removeObject(forKey: "password")
                }) {
                    Text("Logout")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .padding(.horizontal)
                    
                }
                Spacer()
                Button(action: {
                    // Perform delete action
                    showDeleteAlert = true
                    print("delete button pressed")
                }) {
                    Text("Delete Account")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .padding(.horizontal) 
                        .alert(isPresented: $showDeleteAlert) {
                            Alert(title: Text("Delete Account"), message: Text("Are you sure you want to delete your account? This cannot be undone."),
                                    primaryButton: .default(Text("Yes")) {
                                    wrapperItem?.checkUser(username, password: origPassword)
                                    wrapperItem?.deleteUser()
                                    isLoggedin = false
                                    UserDefaults.standard.removeObject(forKey: "username")
                                    UserDefaults.standard.removeObject(forKey: "password")
                                
                                    },
                                    secondaryButton: .cancel(Text("No")))
                            }
                }
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
                origPassword = UserDefaults.standard.string(forKey: "password") ?? ""
                password = origPassword
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLoggedin: .constant(false))
    }
}
