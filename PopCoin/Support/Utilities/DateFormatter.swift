//
//  DateFormatter.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//

import Foundation

extension DateFormatter {
    static let coinGeckoAPIDateString: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    static let fullPresentationDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    static let recentDates: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    static let recentTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
