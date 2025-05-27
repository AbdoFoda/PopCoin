//
//  FetchPriceServiceProtocol.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//
import Foundation

internal protocol FetchPriceServiceProtocol {
    func fetchPrice(for: Date) async throws -> CoinMultiCurrencyPrice
}
