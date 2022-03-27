//
//  DateParser.swift
//  RoxieTaxiService
//
//  Created by Eugene Krapivenko on 27.03.2022.
//

import Foundation

final class DateParser {
    
    public static func change(srt stringWithDate: String, inFormat format: DateFormat) -> String {
        
        let dateFormatter = ISO8601DateFormatter()
        let outFormatter = DateFormatter()
        
        outFormatter.dateFormat = format.rawValue
        outFormatter.locale = Locale(identifier: "ru_RU")
        
        if let date = dateFormatter.date(from: stringWithDate) {
            return outFormatter.string(from: date)
        }
        
        return stringWithDate
    }
    
}

enum DateFormat: String {
    case dayMonthYearTime = "dd MMMM yyyy, HH:mm"
}
