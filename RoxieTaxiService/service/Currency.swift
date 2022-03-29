//
//  Currency.swift
//  RoxieTaxiService
//
//  Created by Eugene Krapivenko on 29.03.2022.
//

import Foundation

final class Currency {
    
    static public func convert(from name: String) -> String {
        switch(name){
        case "RUB": return "руб"
        default: return "у.е."
        }
    }
}
