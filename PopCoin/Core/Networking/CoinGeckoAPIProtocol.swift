//
//  CoinGeckoAPIProtocol.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//

import Foundation

protocol CoinGeckoAPIProtocol {
    func fetchHistoricalPrices(days: Int) async throws -> [CoinDayPrice]
    func fetchPrice(for date: Date) async throws -> CoinMultiCurrencyPrice
}

