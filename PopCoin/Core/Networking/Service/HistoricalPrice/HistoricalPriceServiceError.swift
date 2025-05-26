//
//  HistoricalPriceServiceError.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 26.05.25.
//

import Foundation

enum HistoricalPriceServiceError: LocalizedError {
    case noData
    case todayNotAvailable
    
    var errorDescription: String {
        switch self {
        case .noData:
            return "No data available."
        case .todayNotAvailable:
            return "Today's data is not available."
        }
    }
}
