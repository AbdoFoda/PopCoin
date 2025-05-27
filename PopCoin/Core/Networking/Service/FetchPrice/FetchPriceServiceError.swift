//
//  FetchPriceServiceError.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//

enum FetchPriceServiceError: Error {
    case noData
    
    var errorDescription: String {
        switch self {
        case .noData:
            return "No data available for selected currencies"
        }
    }
}
