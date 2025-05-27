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

    func test_fetchPrices_returnsNormalizedPricesIncludingToday() async throws {
        // Given
        let service = HistoricalPriceService(
            pricesNormalizer: PricesNormalizer(),
            priceRepository: CoinGeckoAPI.shared
        )

        // When
        let prices = try await service.fetchPrices(days: 14)

        // Then
        XCTAssertFalse(prices.isEmpty, "Expected non-empty price history")
        XCTAssertTrue(Calendar.current.isDateInToday(prices.first!.date), "First price should be for today")
    }

    func test_fetchPrices_throwsTodayNotAvailable_whenMissingToday() async {
        // Given
        let repo = StubMissingTodayRepo()
        let service = HistoricalPriceService(
            pricesNormalizer: PricesNormalizer(),
            priceRepository: repo
        )

        // When
        do {
            _ = try await service.fetchPrices(days: 14)
            XCTFail("Expected HistoricalPriceServiceError.todayNotAvailable")
        } catch let error as HistoricalPriceServiceError {
            XCTAssertEqual(error, .todayNotAvailable)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_fetchPrices_throwsNoData_whenEmpty() async {
        // Given
        let repo = StubEmptyRepo()
        let service = HistoricalPriceService(
            pricesNormalizer: PricesNormalizer(),
            priceRepository: repo
        )

        // When
        do {
            _ = try await service.fetchPrices(days: 14)
            XCTFail("Expected HistoricalPriceServiceError.noData")
        } catch let error as HistoricalPriceServiceError {
            XCTAssertEqual(error, .noData)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
