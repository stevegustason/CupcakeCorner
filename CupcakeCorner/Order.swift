//
//  Order.swift
//  CupcakeCorner
//
//  Created by Steven Gustason on 4/19/23.
//

import Foundation

// Order class with only one published variable, which makes codable conformance much easier
class OrderClass: ObservableObject, Codable {
    // Create a published instance of our OrderStruct
    @Published var order = OrderStruct()
    
    // Because we have @Published properties, our class is no longer Codable, so we have to add our own code to make it conform to Codable again. Add our enum that conforms to CodingKey to list all of the properties we want to save (all except the static property)
    enum CodingKeys: CodingKey {
        case order
    }
    
    // Create our encode(to:) method that creates a container using the coding keys enum we just created, then writes out all the properties attached to their respective key. This is just a matter of calling encode(_:forKey:) repeatedly
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(order, forKey: .order)
    }
    
    // Then we add our required initializer to decode an instance of Order from archived data, which basically does the reverse of the encode method.
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        order = try container.decode(OrderStruct.self, forKey: .order)
    }
    
    // Add a second initializer so we can create an order without any prior data
    init() { }
    
    
}

// Order struct to help with the codable conformance for our class
struct OrderStruct: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        // If specialRequestEnabled is set to false, we want to set extraFrosting and addSprinkles to false to prevent our app from saving their settings that they then later disabled.
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var extraFrosting = false
    var addSprinkles = false
    
    // Store delivery details
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    // Computed property to make sure all of our address fields are filled out (and not just whitespace)
    var hasValidAddress: Bool {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
    
    return true
    }
    
    // Track our cupcake cost
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2
        
        // complicated cakes cost more
        cost += (Double(type) / 2)
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        
        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
}

/*
 class Order: ObservableObject, Codable {
 // Store order details
 static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
 
 @Published var type = 0
 @Published var quantity = 3
 
 @Published var specialRequestEnabled = false {
 // If specialRequestEnabled is set to false, we want to set extraFrosting and addSprinkles to false to prevent our app from saving their settings that they then later disabled.
 didSet {
 if specialRequestEnabled == false {
 extraFrosting = false
 addSprinkles = false
 }
 }
 }
 @Published var extraFrosting = false
 @Published var addSprinkles = false
 
 // Store delivery details
 @Published var name = ""
 @Published var streetAddress = ""
 @Published var city = ""
 @Published var zip = ""
 
 // Computed property to make sure all of our address fields are filled out (and not just whitespace)
 var hasValidAddress: Bool {
 if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
 return false
 }
 
 return true
 }
 
 // Track our cupcake cost
 var cost: Double {
 // $2 per cake
 var cost = Double(quantity) * 2
 
 // complicated cakes cost more
 cost += (Double(type) / 2)
 
 // $1/cake for extra frosting
 if extraFrosting {
 cost += Double(quantity)
 }
 
 // $0.50/cake for sprinkles
 if addSprinkles {
 cost += Double(quantity) / 2
 }
 
 return cost
 }
 
 // Because we have @Published properties, our class is no longer Codable, so we have to add our own code to make it conform to Codable again. Add our enum that conforms to CodingKey to list all of the properties we want to save (all except the static property)
 enum CodingKeys: CodingKey {
 case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
 }
 
 // Create our encode(to:) method that creates a container using the coding keys enum we just created, then writes out all the properties attached to their respective key. This is just a matter of calling encode(_:forKey:) repeatedly
 func encode(to encoder: Encoder) throws {
 var container = encoder.container(keyedBy: CodingKeys.self)
 
 try container.encode(type, forKey: .type)
 try container.encode(quantity, forKey: .quantity)
 
 try container.encode(extraFrosting, forKey: .extraFrosting)
 try container.encode(addSprinkles, forKey: .addSprinkles)
 
 try container.encode(name, forKey: .name)
 try container.encode(streetAddress, forKey: .streetAddress)
 try container.encode(city, forKey: .city)
 try container.encode(zip, forKey: .zip)
 }
 
 // Then we add our required initializer to decode an instance of Order from archived data, which basically does the reverse of the encode method.
 required init(from decoder: Decoder) throws {
 let container = try decoder.container(keyedBy: CodingKeys.self)
 
 type = try container.decode(Int.self, forKey: .type)
 quantity = try container.decode(Int.self, forKey: .quantity)
 
 extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
 addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
 
 name = try container.decode(String.self, forKey: .name)
 streetAddress = try container.decode(String.self, forKey: .streetAddress)
 city = try container.decode(String.self, forKey: .city)
 zip = try container.decode(String.self, forKey: .zip)
 }
 
 // Add a second initializer so we can create an order without any prior data
 init() { }
 }
 */
