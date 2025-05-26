//
//  CoinGeckoAPI.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 22.05.25.
//

import Foundation

final class CoinGeckoAPI: CoinGeckoAPIProtocol {
    internal let session: URLSession
    internal let coinID: String
    internal let currency: String
    
    static let shared = CoinGeckoAPI(
        session: .shared,
        coinID: AppConfig.defaultCoin,
        currency: AppConfig.defaultCurrency
    )
    internal init(session: URLSession,
         coinID: String,
         currency: String) {
        self.session = session
        self.coinID = coinID
        self.currency = currency
    }
}
