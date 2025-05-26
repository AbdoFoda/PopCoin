//
//  Untitled.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 25.05.25.
//

import Foundation

extension CoinGeckoAPI: FetchPriceRepo {
    func fetchPrice(for date: Date) async throws -> HistoricalPriceResponse.MarketData {
        guard let url = CoinGeckoEndpoint.historicalPriceURL(
            date: date,
            coinID: coinID
        ) else {
            throw NetworkError.invalidURL
        }

        let (data, _) = try await session.data(from: url)
        let decoded = try JSONDecoder().decode(HistoricalPriceResponse.self, from: data)

        return  decoded.market_data
    }
}

