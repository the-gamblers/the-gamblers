import SwiftUI

struct LandingLoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoginSuccessful = false
    @Binding var isLoggedin: Bool
    
    func saveCredentials(username: String, password: String) {
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
    }
    
    var body: some View {
        NavigationView { // Wrap in NavigationView
            VStack {
                Spacer()
                
                Text("ChessVision")
                    .font(.title)
                    .fontWeight(.heavy)
                    .lineLimit(nil)
                    .padding(.bottom, 10)
                
                Image("app-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 30)
                
                TextField("Email Address", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal)
                
                Button(action: {
                    // TODO: Perform login authentication here
                
                    let wrapperItem = dbWrapper(title: "/Users/roeebelkin/Desktop/School/CSCE 482/the-gamblers/ChessMaster/Client/ChessMaster/test")
                    let isValid = wrapperItem?.checkUser(username,password: password)
                    //print(wrapperItem?.testy())
                    if isValid ?? false {
                        isLoginSuccessful = true
                        isLoggedin = true
                        saveCredentials(username: username, password: password)
                    } else {
                        isLoginSuccessful = false
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
                
                if isLoginSuccessful {
                    Text("Login Successful!")
                        .foregroundColor(.green)
                        .padding(.top, 20)
                    
                        .background(
                            NavigationLink(destination: NavigationPage2(isLoggedin: $isLoggedin)) {
                                                   EmptyView()
                            }
                        )
                } else {
                    Text("Invalid Username or Password")
                        .foregroundColor(.red)
                        .padding(.top, 20)
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
    @State private var isLoginSuccessful = false
    @Binding var isLoggedin: Bool
    
    var body: some View {
        
        Text("CREATE ACCOUNT")
            .font(.title)
            .lineLimit(nil)
            .padding(.bottom, 10)
        
        TextField("First Name", text: $firstname)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
            .padding(.horizontal)
        
        TextField("Last Name", text: $lastname)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
            .padding(.horizontal)
        
        TextField("Email Address", text: $username)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
            .padding(.horizontal)
        
        SecureField("Password", text: $password)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
            .padding(.horizontal)
            .navigationBarTitle("Create an Account")
        
        Button(action: {
            // TODO: Perform creation user process here
            let wrapperItem = dbWrapper(title: "/Users/saddy_khakimova/Documents/CSCE482/the-gamblers/ChessMaster/Client/ChessMaster/test1")
           wrapperItem?.createUser(username, password: password)
            if wrapperItem != nil {
                isLoggedin = true
                isLoginSuccessful = true
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
        
        if isLoginSuccessful {
            Text("You signed up successfully! Now you can Log in.")
                .foregroundColor(.green)
                .padding(.top, 20)
            
                .background(
                    NavigationLink(destination: NavigationPage2(isLoggedin: $isLoggedin)) {
                                           EmptyView()
                    }
                )
        } else {
            Text("Invalid Username or Password")
                .foregroundColor(.red)
                .padding(.top, 20)
        }
        
    }
}

struct LandingLoginView_Previews: PreviewProvider {
    static var previews: some View {
        LandingLoginView(isLoggedin: .constant(false))
    }
}
