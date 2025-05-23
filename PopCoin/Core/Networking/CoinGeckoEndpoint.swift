//
//  CoinGeckoEndpoint.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//


import Foundation

enum CoinGeckoEndpoint {
    static func marketChartURL(
        coinID: String,
        currency: String,
        days: Int
    ) -> URL? {
        let path = "/coins/\(coinID)/market_chart?vs_currency=\(currency)&days=\(days)"
        return URL(string: CoinGeckoConstants.baseURL + path)
    }

    static func historicalPriceURL(
        date: Date,
        coinID: String
    ) -> URL? {
        let dateString = DateFormatter.coinGecko.string(from: date)
        let path = "/coins/\(coinID)/history?date=\(dateString)&localization=false"
        return URL(string: CoinGeckoConstants.baseURL + path)
    }
}
