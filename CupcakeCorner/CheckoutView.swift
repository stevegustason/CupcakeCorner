//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Steven Gustason on 4/19/23.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order

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

                // Place order button
                Button("Place Order", action: { })
                    .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
