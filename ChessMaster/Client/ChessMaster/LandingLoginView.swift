import SwiftUI

struct LandingLoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoginSuccessful = false
    @State private var showPassword: Bool = false
    @State private var showError = false
    @Binding var isLoggedin: Bool
    
    func saveCredentials(username: String, password: String) {
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
    }
    
    var body: some View {
        NavigationView { // Wrap in NavigationView
            VStack {
                Spacer()
                
                Text("ChessMaster")
                    .font(.title)
                    .fontWeight(.heavy)
                    .lineLimit(nil)
                    .padding(.bottom, 10)
                
                Image("app-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 30)
                
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .autocapitalization(.none)
    
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
                    let isValid = wrapperItem?.checkUser(username,password: password)
                    if isValid ?? false {
                               isLoginSuccessful = true
                               isLoggedin = true
                               saveCredentials(username: username, password: password)
                           } else {
                               showError = true
                               DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                   showError = false // Hide the error message after 4 seconds
                               }
                           }
                }) {
                    Text("LOG IN")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(25)
                        .padding(.horizontal)
                }
                
                if showError {
                        Text("Invalid Username or Password")
                            .foregroundColor(.red)
                            .padding(.top, 20)
                    }
                
                if isLoginSuccessful {
                    Text("Login Successful!")
                        .foregroundColor(.green)
                        .padding(.top, 20)
                        .background(
                            NavigationLink(destination: NavigationPage2(isLoggedin: $isLoggedin)) {
                                                   EmptyView()
                            }
                        )
                }
                
                Spacer()
                NavigationLink(destination: CreateUserView(isLoggedin: .constant(false))) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                        .padding(.bottom, 20)
                }
            }
            .padding()
        }
    }
}

struct CreateUserView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var isSignupSuccessful = false
    @State private var showPassword: Bool = false
    @State private var showError = false
    @Binding var isLoggedin: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    func saveCredentials(username: String, password: String) {
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
    }
    
    var body: some View {
        VStack {
            Text("CREATE ACCOUNT")
                .font(.title)
                .lineLimit(nil)
                .padding(.bottom, 10)
            
            TextField("Username", text: $username)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(20)
                .padding(.horizontal)
                .autocapitalization(.none)
            
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
                // Perform creation user process here
                let isMade = wrapperItem?.checkUser(username, password: password)
                wrapperItem?.createUser(username, password: password)
                if wrapperItem != nil && isMade == false {
                    isLoggedin = true
                    isSignupSuccessful = true
                    saveCredentials(username: username, password: password)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    showError = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        showError = false // Hide the error message after 4 seconds
                    }
                }
            }) {
                Text("SIGN UP")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(25)
                    .padding(.horizontal)
            }
            
            // Display error message if sign-up fails
            if showError {
                Text("Username already exists")
                    .foregroundColor(.red)
                    .padding(.top, 20)
            }
            
            if isSignupSuccessful {
                Text("Sign up Successful!")
                    .foregroundColor(.green)
                    .padding(.top, 20)
            }
        }
    }
}


struct LandingLoginView_Previews: PreviewProvider {
    static var previews: some View {
        LandingLoginView(isLoggedin: .constant(false))
    }
}
