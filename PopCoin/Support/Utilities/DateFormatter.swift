//
//  DateFormatter.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//

import Foundation

extension DateFormatter {
    static let coinGecko: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
