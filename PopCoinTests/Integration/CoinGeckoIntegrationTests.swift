//
//  CoinGeckoIntegrationTests.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//


import XCTest
@testable import PopCoin

final class CoinGeckoAPIIntegrationTests: XCTestCase {

    func test_request_fetchesMarketChartResponse_successfully() async throws {
        // Given
        let api = CoinGeckoAPI.shared
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=eur&days=7")!

        // When
        let result: MarketChartResponse = try await api.request(MarketChartResponse.self, from: url)

        // Then
        XCTAssertFalse(result.prices.isEmpty, "Expected prices array to be non-empty")
        XCTAssertEqual(result.prices.first?.count, 2, "Expected each price entry to have [timestamp, value]")
    }

    func test_request_returnsFailure_forInvalidEndpoint() async {
        // Given
        let api = CoinGeckoAPI.shared
        let invalidURL = URL(string: "https://api.coingecko.com/api/v3/invalid_endpoint")!

        // When
        do {
            let _: MarketChartResponse = try await api.request(MarketChartResponse.self, from: invalidURL)
            XCTFail("Expected to throw, but request succeeded")
        } catch let error as NetworkError{
            guard case .invalidURL = error else {
                return
            }
            XCTFail("Expected Invalid URL error but got another NetworkError: \(error)")
        } catch {
            XCTFail("Unhandled error: \(error)")
        }
    }
}
