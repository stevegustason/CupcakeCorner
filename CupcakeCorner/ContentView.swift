//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Steven Gustason on 4/18/23.
//

import SwiftUI

// Published properties are not inherently codable
class User: ObservableObject, Codable {
    @Published var name = "Paul Hudson"
    
    // To make them conform to Codable, first we create a CodingKeys enum listing all of the properties we want to archive and unarchive
    enum CodingKeys: CodingKey {
        case name
    }
    
    // Then we need a custom initializer. It's required so that subclasses are forced to have their own custom implementation. Then we hand it a decoder.
    required init(from decoder: Decoder) throws {
        // Then we create a container matching all the coding keys in our CodingKeys enum.
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Then we read values from the container by referencing cases in our enum.
        name = try container.decode(String.self, forKey: .name)
    }
    
    // Finally, we also need to tell Swift how to encode this type. This basically does the opposite of the initializer. We give it an encoder.
    func encode(to encoder: Encoder) throws {
        // Ask it to make a container using our CodingKeys enum.
        var container = encoder.container(keyedBy: CodingKeys.self)
        // Then write our values attached to each key.
        try container.encode(name, forKey: .name)
    }
}



struct ContentView: View {
    // A struct to store an array of song results
    struct Response: Codable {
        var results: [Result]
    }

    // Simple struct to store a song result - the track ID, the name, and the album
    struct Result: Codable {
        var trackId: Int
        var trackName: String
        var collectionName: String
    }
    
    // Create a variable to store our Result array
    @State private var results = [Result]()

    // Because loading song results is not immediate, we need to use an asynchronous (async) function
    func loadData() async {
        // First, we need to create the URL we want to read from
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        
        do {
            // Then fetch the data from the URL - we need to use both try and await because an error might be thrown and a sleep is possible. The data(from:) method take a URL and returns the Data object at that url. The return value is a tuple containing the data and metadata about how the request went. We create a local constant for the data, and throw the metadata away with the _.
            let (data, _) = try await URLSession.shared.data(from: url)

            // Here we convert the Data object into a Reponse object using JSONDecoder
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                
                // Then assign that array to the results property
                results = decodedResponse.results
            }
        } catch {
            // If our download fails, print this error message.
            print("Invalid data")
        }
    }
    
    @State private var username = ""
    @State private var email = ""
    
    var disableForm: Bool {
        username.count < 5 || email.count < 5
    }

    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Username", text: $username)
                    TextField("Email", text: $email)
                }
                
                Section {
                    Button("Create account") {
                        print("Creating account…")
                    }
                }
                // We can use the disabled modifier to check a condition. If the condition is true, then whatever it's attached to won't respond to user input. In this case, if the user hasn't entered both a username and email, then they can't click the create account button.
                .disabled(username.isEmpty || email.isEmpty)
                
                /*
                // You can also split out your conditions into a computed property and reference that in the modifier
                .disabled(disableForm)
                 */
            }
            
            // List that for each track ID creates a VStack with the song name and album
            List(results, id: \.trackId) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.trackName)
                            .font(.headline)
                        Text(item.collectionName)
                    }
                    
                    Spacer()
                    
                    // AsyncImage allows us to load a remote image from the internet. At its simplest, you just need to provide it with a URL. The problem is that Swift knows nothing about the image so will likely load it in at a size you don't want. If we use this version of AsyncImage, it will pass us the final image view once it's ready, which we can then customize.
                    AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                        // We can also customize the placeholder image that appears while the image is loading
                    } placeholder: {
                        Color.red
                    }
                    .frame(width: 50, height: 50)
                }
            }
            // We use a task modifier to run our asyc function as soon as the list is shown
            .task {
                // We use the await keyword to indicate that a sleep might happen
                await loadData()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
