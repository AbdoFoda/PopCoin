//
//  HistoricalPriceServiceProtocol.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 26.05.25.
//


internal protocol HistoricalPriceServiceProtocol {
    func fetchPrices(days: Int) async throws -> [CoinDayPrice]
}
