//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Steven Gustason on 4/19/23.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    
    // Method to place our order
    func placeOrder() async {
        // Use JSONEncoder to try to archive our order
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        // Set our URL - here we use https://reqres.in which allows us to send whatever data we want and it will send it back, which is great for prototyping networking code. We force unwrap it because it was hand-typed and will always be correct.
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        // Then we create a URLRequest object using our URL
        var request = URLRequest(url: url)
        // The content type of a request determines what kind of data is being sent, which affects the way the server treats our data. So we configure it here to send JSON data.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // We really only use the GET (“I want to read data”) and POST (“I want to write data”) methods. Here, we're writing data so we use POST.
        request.httpMethod = "POST"
        
        do {
            // We make our network request using URLSession.shared.upload and the url request we just made
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            // Decode the data that came back
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            // Set our confirmation message
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            // And display our alert
            showingConfirmation = true
            
        } catch {
            // If something went wrong, print an error message
            print("Checkout failed.")
        }
    }
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false

    var body: some View {
        ScrollView {
            VStack {
                // Load our cupcake image from a remote server, scaled to fit. We could use an image included in our app, but this allows us to swap out the picture easily for future promotions, etc.
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                        image
                            .resizable()
                            .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)

                // Show the cost of the order formatted for USD
                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)

                // Place order button, which uses a task to allow us to add await so we can use our asynchronous function
                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
