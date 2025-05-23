//
//  CoinGeckoAPI.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 22.05.25.
//

import Foundation

final class CoinGeckoAPI: CoinGeckoAPIProtocol {
    private let session: URLSession
    private let coinID: String
    private let currency: String

    init(session: URLSession = .shared,
         coinID: String,
         currency: String) {
        self.session = session
        self.coinID = coinID
        self.currency = currency
    }

    func fetchLast14DaysEUR() async throws -> [BitcoinDayPrice] {
        guard let url = CoinGeckoEndpoint.marketChartURL(
            coinID: coinID,
            currency: currency,
            days: 14
        ) else {
            throw NetworkError.invalidURL
        }

        let (data, _) = try await session.data(from: url)
        let decoded = try JSONDecoder().decode(MarketChartResponse.self, from: data)
        return decoded.toDayPriceList()
    }

    func fetchPrice(for date: Date) async throws -> BitcoinMultiCurrencyPrice {
        guard let url = CoinGeckoEndpoint.historicalPriceURL(
            date: date,
            coinID: coinID
        ) else {
            throw NetworkError.invalidURL
        }

        let (data, _) = try await session.data(from: url)
        let decoded = try JSONDecoder().decode(HistoricalPriceResponse.self, from: data)

        let current = decoded.market_data.current_price
        return BitcoinMultiCurrencyPrice(
            date: date,
            eur: current[CoinGeckoConstants.Currency.eur] ?? 0,
            usd: current[CoinGeckoConstants.Currency.usd] ?? 0,
            gbp: current[CoinGeckoConstants.Currency.gbp] ?? 0
        )
    }
}
