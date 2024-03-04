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

struct Game: Decodable {
    var success: Bool?
    var data: String?
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

// POST user info to database
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

// PUT updated email in database
func updateUserData(id: String, email: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
    let json: [String: Any] = ["id": id, "email": email]
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: json) // Serialize JSON data
        
        // Create put request
        let url = URL(string: "http://localhost:5211/api/users/\(id)?email=\(email)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT" // Use PUT method for update
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

// delete user in database
func deleteUserData(id: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
    let json: [String: Any] = ["id": id]
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: json) // Serialize JSON data
        
        // Create DELETE request
        let url = URL(string: "http://localhost:5211/api/users/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE" // Use DELETE method
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


struct ContentView: View {
    
    // variables
    @State private var message = "" // dynamic message
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
                
                TextField("Enter ID", text: $userID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                               
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
                        
                        //let userID = "65d621d1eb548c6cd15d6a46" // for testing since I have to type ID on preview (can't copy & paste)
                        self.message = ("PUTing (updating email) -> ID: \(userID), Email: \(String(describing: userEmail))")
                        
                        updateUserData(id: userID, email: userEmail) { (result, error) in
                                if let result = result {
                                    print("success: \(result)")
                                }
                            }
                        
                        // message dissappears after 5 sec
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { self.message = ""}
                    }
                    Button("D"){
                        //let userID = "65d621d1eb548c6cd15d6a46" // for testing since I have to type ID on preview (can't copy & paste)
                        self.message = ("DELETEing -> ID: \(userID)")
                        
                        deleteUserData(id: userID) { (result, error) in
                                if let result = result {
                                    print("success: \(result)")
                                }
                            }
                        
                        // message dissappears after 5 sec
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { self.message = ""}
                        
                    }
                    Button("Stockfish"){
                    
                        /*
                        fetchData(from: "https://stockfish.online/api/stockfish.php?fen=r2q1rk1/ppp2ppp/3bbn2/3p4/8/1B1P4/PPP2PPP/RNB1QRK1 w - - 5 11&depth=13&mode=eval") { result in
                            switch result {
                            case .success((let data, let response)):
                                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                                    print("Invalid response")
                                    return
                                }

                                if let responseString = String(data: da, encoding: .utf8) {
                                    // Print or process the response string as needed
                                    print("Response: \(responseString)")
                                } else {
                                    print("Error: Could not convert data to string")
                                }
                                
                                do {
                                    print(httpResponse)
                                    print("this is after response\n\n\n\n")
                                    print(response.suggestedFilename)
                                    print(response.textEncodingName)
                                    print(response.expectedContentLength)
                                    print(response.mimeType)
                                    print(response.url)
                                    let decoder = JSONDecoder()
                                    let games = try decoder.decode([Game].self, from: data)
                                    for game in games {
                                        self.message = "Success? \(game.success), Data: \(game.data)"
                                        print(game.data)
                                    }
                                    
                                } catch {
                                    print("Error decoding JSON: \(error)")
                                }
                                
                            case .failure(let error):
                                print("Error fetching data: \(error)")
                            }
                        }
                        */
                        print("pre url")
                        let apiUrl = URL(string: "https://stockfish.online/api/stockfish.php?fen=r2q1rk1/ppp2ppp/3bbn2/3p4/8/1B1P4/PPP2PPP/RNB1QRK1 w - - 5 11&depth=5&mode=bestmove")!

                        // Create a URLSession instance
                        let session = URLSession.shared
                        print("post session")

                        // Create a data task to fetch the data
                        let task = session.dataTask(with: apiUrl) { data, response, error in
                        // Check for errors

                            print("post task")
                            if let error = error {
                                print("Error: \(error.localizedDescription)")
                                return
                            }

                            // Check if a response was received
                            guard let httpResponse = response as? HTTPURLResponse else {
                                print("Error: No HTTP response")
                                return
                            }

                            // Check if the response status code indicates success
                            guard (200...299).contains(httpResponse.statusCode) else {
                                print("Error: HTTP status code \(httpResponse.statusCode)")
                                return
                            }

                            // Check if data was returned
                            guard let responseData = data else {
                                print("Error: No data received")
                                return
                            }

                            print("pre response string")
                            // Convert the data to a string
                            // if let responseString = String(data: responseData, encoding: .utf8) {
                            //     // Print or process the response string as needed
                            //     print(type(of: responseString))
                            //     print("Response: \(responseString)")
                            // } else {
                            //     print("Error: Could not convert data to string")
                            // }
                            do {
                                let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                                
                                // Check if parsing succeeded and "data" key exists
                                if let jsonData = json?["data"] as? String {
                                    // Now you have the string "bestmove b1c3 ponder h7h6" in jsonData
                                    print("Best move: \(jsonData)")
                                    self.message = jsonData
                                } else {
                                    print("Data key not found in JSON response")
                                }
                        } catch {
                            // Handle error thrown by JSONSerialization.jsonObject
                            print("Error parsing JSON: \(error)")
                        }
                        
}
                        task.resume()
                        
                        // message dissappears after 5 sec
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { self.message = ""}
                        
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
