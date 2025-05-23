//
//  CoinGeckoAPIProtocol.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//

import Foundation

protocol CoinGeckoAPIProtocol {
    func fetchLast14DaysEUR() async throws -> [BitcoinDayPrice]
    func fetchPrice(for date: Date) async throws -> BitcoinMultiCurrencyPrice
}
