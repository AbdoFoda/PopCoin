//
//  MockHistoricalPriceService.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//

@testable import PopCoin

final class MockHistoricalPriceService: HistoricalPriceServiceProtocol {
    var result: Result<[CoinDayPrice], Error> = .success([])

    func fetchPrices(days: Int) async throws -> [CoinDayPrice] {
        return try result.get()
    }
}
