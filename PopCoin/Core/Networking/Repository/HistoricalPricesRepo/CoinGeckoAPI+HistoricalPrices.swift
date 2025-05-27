//
//  CoinGeckoAPI+HistoricalPrices.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 25.05.25.
//
import Foundation

extension CoinGeckoAPI: HistoricalPricesRepo {
    func fetchHistoricalPrices(days: Int) async throws -> MarketChartResponse {
        guard let url = CoinGeckoEndpoint.marketChartURL(
            coinID: coinID,
            currency: currency,
            days: days
        ) else {
            throw NetworkError.invalidURL
        }
        return try await request(MarketChartResponse.self, from: url)
    }
}
