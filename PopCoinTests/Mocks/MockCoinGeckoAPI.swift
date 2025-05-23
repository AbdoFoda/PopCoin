//
//  MockCoinGeckoAPI.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//
@testable import PopCoin
import Foundation

final class MockCoinGeckoAPI: CoinGeckoAPIProtocol {
    var result: Result<[CoinDayPrice], Error> = .success([])

    func fetchHistoricalPrices(days: Int) async throws -> [CoinDayPrice] {
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }

    func fetchPrice(for date: Date) async throws -> CoinMultiCurrencyPrice {
        fatalError("....")
    }
}
