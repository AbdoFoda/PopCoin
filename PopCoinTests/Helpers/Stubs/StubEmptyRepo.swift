//
//  StubEmptyRepo.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//

@testable import PopCoin

struct StubEmptyRepo: HistoricalPricesRepo {
    func fetchHistoricalPrices(days: Int) async throws -> MarketChartResponse {
        return MarketChartResponse(prices: [])
    }
}
