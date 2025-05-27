//
//  MockFetchPriceRepo.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//

@testable import PopCoin
import Foundation

final class MockFetchPriceRepo: FetchPriceRepo {
    var stubbedPrice: HistoricalPriceResponse? = nil

    func fetchPrice(for date: Date) async throws -> HistoricalPriceResponse {
        guard let price = stubbedPrice else {
            throw NetworkError.invalidResponse
        }
        return price
    }
}
