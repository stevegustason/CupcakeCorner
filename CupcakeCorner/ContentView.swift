//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Steven Gustason on 4/18/23.
//

import SwiftUI

struct ContentView: View {
    // Create an instance of our Order class
    @StateObject var order = Order()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    // Picker with our different types. We're storing the user's selection as an integer, but the topping list is an array of strings. Because this array is not mutable, we can use the array's index to match these up.
                    Picker("Select your cake type", selection: $order.type) {
                        ForEach(Order.types.indices) {
                            Text(Order.types[$0])
                        }
                    }

                    // Stepper to choose quantity of cakes to purchase
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                Section {
                    // Toggle for special order modifications
                    Toggle("Any special requests?", isOn: $order.specialRequestEnabled.animation())

                    // If our specialRequestEnabled toggle is true, then
                    if order.specialRequestEnabled {
                        // Toggle for extra frosting
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)

                        // Toggle for extra sprinkles
                        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                }
                Section {
                    // Navigation link to bring us to the address entry screen, passing our order object on to the next screen
                    NavigationLink {
                        AddressView(order: order)
                    } label: {
                        Text("Delivery details")
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
