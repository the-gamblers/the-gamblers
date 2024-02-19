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
    @State private var message = ""
        
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
                
                Button("Click me"){
                    // TODO: ADD FUNCTION HERE
                    self.message = "Successfully got users!"
                    
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
                                    print("ID: \(user.id), Name: \(String(describing: user.name)), Email: \(String(describing: user.email)), Password: \(String(describing: user.password))")
                                    print(" ")
                                }
                            } catch {
                                print("Error decoding JSON: \(error)")
                            }
                            
                        case .failure(let error):
                            print("Error fetching data: \(error)")
                        }
                    }
                    
                    // message dissappears after 3 sec
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { self.message = ""}
                    
                }
                Text(message)
                    .foregroundColor(.green)

            }
            .padding(12.0)
            .buttonStyle(BlueButton())
            .imageScale(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
            
        }
    }
       
    
}
   

#Preview {
    ContentView()
}

