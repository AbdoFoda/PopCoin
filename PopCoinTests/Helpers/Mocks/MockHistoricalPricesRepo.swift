//
//  MockHistoricalPricesRepo.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//

@testable import PopCoin

final class MockHistoricalPricesRepo: HistoricalPricesRepo {
    var stubbedResponse: MarketChartResponse = .init(prices: [])
    func fetchHistoricalPrices(days: Int) async throws -> MarketChartResponse {
        return stubbedResponse
    }
}
