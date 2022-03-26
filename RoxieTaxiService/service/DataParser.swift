//
//  DataParser.swift
//  RoxieTaxiService
//
//  Created by Eugene Krapivenko on 26.03.2022.
//

import Foundation

class DataParser {
    
    static func convert<T: Contract>(data: Data) throws -> [T] where T: Decodable {
        do {
            return try JSONDecoder().decode([T].self, from: data)
        } catch(let error) {
            throw JsonParserError.IncorrectDataFormat(message: error.localizedDescription)
        }
    }
}

enum JsonParserError: Error {
    case IncorrectDataFormat(message: String)
}
