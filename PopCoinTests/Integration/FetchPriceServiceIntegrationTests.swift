//
//  FetchPriceServiceIntegrationTests.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//


import XCTest
@testable import PopCoin

final class FetchPriceServiceIntegrationTests: XCTestCase {

    func test_fetchPrice_returnsAtLeastOneSupportedCurrency() async throws {
        let service = FetchPriceService(fetchPriceRepo: CoinGeckoAPI.shared)
        let date = Date()

        let result = try await service.fetchPrice(for: date)

        XCTAssertFalse(result.prices.isEmpty, "Expected at least one supported currency")
        XCTAssertTrue(result.prices.allSatisfy {
            CoinGeckoConstants.Currency.allCurrencies.contains($0.currency)
        })
    }

    func test_fetchPrice_throwsNoData_forFutureUnavailableDate() async {
        let service = FetchPriceService(fetchPriceRepo: CoinGeckoAPI.shared)

        let futureDate = Calendar.current.date(byAdding: .day, value: 3, to: Date())!

        do {
            _ = try await service.fetchPrice(for: futureDate)
            XCTFail("Expected FetchPriceServiceError.noData")
        } catch let error as FetchPriceServiceError {
            XCTAssertEqual(error, .noData)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
