import SwiftUI

struct LandingLoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoginSuccessful = false
    @Binding var isLoggedin: Bool
    
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
                    // Perform login authentication here
                    // Replace with actual authentication process
                    if username == "Jade" && password == "Jade" {
                        isLoginSuccessful = true
                        isLoggedin = true
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
                            NavigationLink(destination: NavigationPage2()) {
                                                   EmptyView()
                            }
                        )
                } else if username != "" || password != "" {
                    Text("Invalid Username or Password")
                        .foregroundColor(.red)
                        .padding(.top, 20)
                }
                
                Spacer()
                NavigationLink(destination: CreateUserView()) {
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
            // Perform creation authentication here
            // Replace with actual authentication process
          
        }) {
            Text("SIGN UP")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(25)
                .padding(.horizontal)
        }
    }
}

struct LandingLoginView_Previews: PreviewProvider {
    static var previews: some View {
        LandingLoginView(isLoggedin: .constant(false))
    }
}
