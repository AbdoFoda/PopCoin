//
//  Untitled.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//

@testable import PopCoin
import Foundation

extension MarketChartResponse {
    static func fromDates(_ dates: [Date], price: Double = 100) -> MarketChartResponse {
        return MarketChartResponse(
            prices: dates.map { [$0.timeIntervalSince1970 * 1000, price] }
        )
    }
}
