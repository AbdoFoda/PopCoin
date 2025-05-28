//
//  CoinGeckoAPI.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 22.05.25.
//

import Foundation

final class CoinGeckoAPI {
    internal let session: URLSession
    internal let coinID: String
    internal let currency: String
    internal let apiKey: String
    internal let apiKeyHeader: String

    static let shared = CoinGeckoAPI(
        session: .shared,
        coinID: AppConfig.defaultCoin,
        currency: AppConfig.defaultCurrency.rawValue,
        apiKey: APIKeys.coinGecko,
        apiKeyHeader: APIKeys.APIKeyHeader
    )
    
    internal init(session: URLSession,
                  coinID: String,
                  currency: String,
                  apiKey: String,
                  apiKeyHeader: String
    ) {
        self.session = session
        self.coinID = coinID
        self.currency = currency
        self.apiKey = apiKey
        self.apiKeyHeader = apiKeyHeader
    }    
}
