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

        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(MarketChartResponse.self, from: data)
    }
}
