//
//  Untitled.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 25.05.25.
//

import Foundation

extension CoinGeckoAPI: FetchPriceRepo {
    func fetchPrice(for date: Date) async throws -> HistoricalPriceResponse {
        guard let url = CoinGeckoEndpoint.historicalPriceURL(
            date: date,
            coinID: coinID
        ) else {
            throw NetworkError.invalidURL
        }
        return try await request(HistoricalPriceResponse.self, from: url)
    }
}

