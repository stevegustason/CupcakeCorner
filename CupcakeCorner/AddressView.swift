//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Steven Gustason on 4/19/23.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: OrderClass

    var body: some View {
        Form {
            Section {
                // Text fields for name, address, city, and zip
                TextField("Name", text: $order.order.name)
                TextField("Street Address", text: $order.order.streetAddress)
                TextField("City", text: $order.order.city)
                TextField("Zip", text: $order.order.zip)
            }

            Section {
                // Navigation link to take us to the checkout page, again continuing to pass our order object on
                NavigationLink {
                    CheckoutView(order: order)
                } label: {
                    Text("Check out")
                }
            }
            // Disable our check out button unless our computed property returns true, indicating all four fields have been filled out
            .disabled(order.order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: OrderClass())
    }
}
