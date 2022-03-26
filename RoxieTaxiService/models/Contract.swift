//
//  Contract.swift
//  RoxieTaxiService
//
//  Created by Eugene Krapivenko on 25.03.2022.
//

import Foundation

// MARK: - protocol
protocol Contract {
    
}

// MARK: - implementation
struct ActiveContract: Contract, Decodable {
    var id: Int
    var startAddress: Address
    var endAddress: Address
    var price: Price
    var orderTime: String
    var vehicle: Vehicle
}

struct Address: Decodable {
    var city: String
    var address: String
}

struct Price: Decodable {
    var amount: Int
    var currency: String
}

struct Vehicle: Decodable {
    var regNumber: String
    var modelName: String
    var photo: String
    var driverName: String
}

