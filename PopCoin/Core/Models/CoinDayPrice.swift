//
//  CoinDayPrice.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 22.05.25.
//


import Foundation

struct CoinDayPrice: Identifiable {
    let id = UUID()
    let date: Date
    let priceEUR: Double
}

extension CoinDayPrice {
    var formattedDate: String {
        DateFormatter.recentDates.string(from: date)
    }

    var formattedPrice: String {
        "€\(priceEUR.formattedPrice)"
    }
    
    var formattedRelativeDate: String {
        let calendar = Calendar.current
        return calendar.isDateInToday(date) ? "Today" : formattedDate
    }
    
    var formattedTime: String {
        let calendar = Calendar.current
        
        let sameMinute = calendar.component(.minute, from: date) == calendar.component(.minute, from: .now)
        && calendar.isDate(date, equalTo: .now, toGranularity: .hour)
        
        return sameMinute ? "just now" : DateFormatter.recentTime.string(from: date)
    }
}

