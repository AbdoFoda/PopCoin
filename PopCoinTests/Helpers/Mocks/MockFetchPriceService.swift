//
//  MockFetchPriceService.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//

@testable import PopCoin
import Foundation

final class MockFetchPriceService: FetchPriceServiceProtocol {
    var result: Result<CoinMultiCurrencyPrice, Error> = .success(.init(date: Date(), prices: []))

    func fetchPrice(for date: Date) async throws -> CoinMultiCurrencyPrice {
        try result.get()
    }
}

