//
//  FetchPriceServiceTests.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//


import XCTest
@testable import PopCoin
final class FetchPriceServiceTests: XCTestCase {

    func test_fetchPrice_returnsFilteredSupportedCurrencies() async throws {
        // Given
        let mock = MockFetchPriceRepo()
        let marketData: HistoricalPriceResponse.MarketData = .init(current_price: [
            "eur": 10000,
            "usd": 12000,
            "jpy": 1400000,
            "pepe": 1.23 // unsupported
        ])
        mock.stubbedPrice = HistoricalPriceResponse(market_data: marketData)

        let service = FetchPriceService(fetchPriceRepo: mock)

        // When
        let result = try await service.fetchPrice(for: Date())

        // Then
        let currencies = result.prices.map(\.currency)
        XCTAssertTrue(currencies.contains(.eur))
        XCTAssertTrue(currencies.contains(.usd))
        XCTAssertFalse(currencies.contains(where: { $0.rawValue == "pepe" }))
    }

    func test_fetchPrice_throwsNoData_ifNoSupportedCurrencyExists() async {
        // Given
        let mock = MockFetchPriceRepo()
        let marketData = HistoricalPriceResponse.MarketData(current_price: ["pepe": 9.9])
        mock.stubbedPrice = HistoricalPriceResponse(market_data: marketData)
        let service = FetchPriceService(fetchPriceRepo: mock)

        // When / Then
        do {
            _ = try await service.fetchPrice(for: Date())
            XCTFail("Expected FetchPriceServiceError.noData")
        } catch let error as FetchPriceServiceError {
            XCTAssertEqual(error, .noData)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_fetchPrice_parsesCorrectly() async throws {
        // Given
        let mock = MockFetchPriceRepo()
        let marketData = HistoricalPriceResponse.MarketData(current_price: ["usd": 12345.6])
        mock.stubbedPrice = HistoricalPriceResponse(
            market_data: marketData
        )
        let service = FetchPriceService(fetchPriceRepo: mock)

        // When
        let result = try await service.fetchPrice(for: Date())

        // Then
        XCTAssertEqual(result.prices.count, 1)
        XCTAssertEqual(result.prices.first?.currency, .usd)
        XCTAssertEqual(result.prices.first?.price, 12345.6)
    }
}
