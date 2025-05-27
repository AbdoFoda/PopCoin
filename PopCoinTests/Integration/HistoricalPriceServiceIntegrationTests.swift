//
//  CoinGeckoIntegrationTests.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//


import XCTest
@testable import PopCoin

@MainActor
final class HistoricalPriceServiceIntegrationTests: XCTestCase {

    func test_fetchPrices_returnsValidTodayPrice() async throws {
        // Step 1: Use real CoinGeckoAPI as repo
        let api = CoinGeckoAPI(
            session: URLSession.shared,
            coinID: "bitcoin",
            currency: "eur"
        )

        // Step 2: Inject real service dependencies
        let priceNormalizer = PricesNormalizer() // Assuming this is a simple struct
        let service = HistoricalPriceService(
            pricesNormalizer: priceNormalizer,
            priceRepository: api
        )

        // Step 3: Act
        let prices = try await service.fetchPrices(days: 14)

        // Step 4: Assert
        XCTAssertFalse(prices.isEmpty, "Price history should not be empty")
        XCTAssertTrue(Calendar.current.isDateInToday(prices.first!.date), "First price should be for today")
    }
}
