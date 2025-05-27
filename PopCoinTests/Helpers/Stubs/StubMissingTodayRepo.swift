//
//  StubMissingTodayRepo.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//

@testable import PopCoin
import Foundation

struct StubMissingTodayRepo: HistoricalPricesRepo {
    func fetchHistoricalPrices(days: Int) async throws -> MarketChartResponse {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        return MarketChartResponse(
            prices: [[yesterday.timeIntervalSince1970 * 1000, 100.0]]
        )
    }
}



