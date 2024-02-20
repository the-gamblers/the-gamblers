//
//  ContentView.swift
//  PokerSensei
//
//  Created by Jade Davis on 2/12/24.
//

import SwiftUI
import Foundation

struct User: Decodable {
    var id: String
    var name: String?
    var email: String?
    var password: String?
}

// fetch database info
func fetchData(from urlString: String, completion: @escaping (Result<(Data, URLResponse), Error>) -> Void) {
    if let url = URL(string: urlString) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response {
                completion(.success((data, response)))
            } else {
                completion(.failure(NSError(domain: "UnknownError", code: 0, userInfo: nil)))
            }
        }
        task.resume()
    } else {
        completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
    }
}

// POST func
func postData(name: String, email: String, password: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
    
    let json: [String: Any] = ["name": name, "email": email, "password": password]
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: json) // Serialize JSON data
        
        // create post request
        let url = URL(string: "http://localhost:5211/api/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // Set content type
        
        // Set JSON data to request body
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(nil, error)
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                completion(responseJSON, nil) // Pass response JSON and nil error to completion handler
            } else {
                completion(nil, NSError(domain: "InvalidResponse", code: 0, userInfo: nil)) // Provide an error if unable to parse response JSON
            }
        }
        
        task.resume()
    } catch {
        print("Error serializing JSON: \(error)")
        completion(nil, error)
    }
}


// blue button style
struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0.00, green: 0.38, blue: 0.94))
            .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}

//dynamic message
struct ContentView: View {
    @State private var message = ""
    @State private var userID: String = ""
    @State private var userName: String = ""
    @State private var userEmail: String = ""
    @State private var userPassword: String = ""

        
    var body: some View {
        ZStack {
            Color("bkColor")
                .ignoresSafeArea()
            VStack {
                Text("PokerSensei")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .lineLimit(nil)
                    .padding(.bottom, 20)
                    .padding(.top, -150)
                
                Image(systemName: "suit.club.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 70)
                    .padding(.top, -100)
                               
                TextField("Enter Name", text: $userName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                               
                TextField("Enter Email", text: $userEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                               
                SecureField("Enter Password", text: $userPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                HStack{
                    Button("C"){
                        
                        self.message = "POSTed -> Name: \(String(describing: userName)), Email: \(String(describing: userEmail)), Password: \(String(describing: userPassword))"
                        
                        postData(name: userName, email: userEmail, password: userPassword) { (result, error) in
                            if let result = result {
                                print("success: \(result)")
                            }
                            
                        }
                        // message dissappears after 5 sec
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { self.message = ""}
                    }
                    Button("R"){
                    
                        fetchData(from: "http://localhost:5211/api/users") { result in
                            switch result {
                            case .success((let data, let response)):
                                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                                    print("Invalid response")
                                    return
                                }
                                
                                do {
                                    let decoder = JSONDecoder()
                                    let users = try decoder.decode([User].self, from: data)
                                    for user in users {
                                        self.message = "ID: \(user.id), Name: \(String(describing: user.name)), Email: \(String(describing: user.email)), Password: \(String(describing: user.password))"
                                        print("ID: \(user.id), Name: \(String(describing: user.name)), Email: \(String(describing: user.email)), Password: \(String(describing: user.password))")
                                    }
                                } catch {
                                    print("Error decoding JSON: \(error)")
                                }
                                
                            case .failure(let error):
                                print("Error fetching data: \(error)")
                            }
                        }
                        
                        // message dissappears after 5 sec
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { self.message = ""}
                        
                    }
                    Button("U"){
                        
                        
                    }
                    Button("D"){
                        
                        
                    }

                    
                }
                .padding(15.0)
                .buttonStyle(BlueButton())
                .imageScale(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
            }
            
        }
        Text(message)
            .foregroundColor(.green)
    }
       
    
}
   

#Preview {
    ContentView()
}
