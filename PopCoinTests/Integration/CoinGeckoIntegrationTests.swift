//
//  CoinGeckoIntegrationTests.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//


import XCTest
@testable import PopCoin

final class CoinGeckoIntegrationTests: XCTestCase {

    var api: CoinGeckoAPI!

    override func setUp() {
        super.setUp()
        api = CoinGeckoAPI(
            session: .shared,
            coinID: CoinGeckoConstants.Coin.bitcoin,
            currency: CoinGeckoConstants.Currency.eur
        )
    }

    func testFetchHistoricalPrices_liveAPI_returnsValidPrices() async throws {
        let result = try await api.fetchHistoricalPrices(days: 14)

        XCTAssertFalse(result.isEmpty, "Expected non-empty price list")
        XCTAssertTrue(result.allSatisfy { $0.priceEUR > 0 }, "Prices should be greater than 0")
    }

    func testFetchPriceOnSpecificDate_liveAPI_returnsValidPrice() async throws {
        // Use a valid past date (Coingecko requires past data)
        let formatter = DateFormatter.coinGecko
        guard let date = formatter.date(from: "20-05-2025") else {
            XCTFail("Failed to create test date")
            return
        }

        let result = try await api.fetchPrice(for: date)

        XCTAssertGreaterThan(result.eur, 0)
        XCTAssertGreaterThan(result.usd, 0)
        XCTAssertGreaterThan(result.gbp, 0)
    }
}
