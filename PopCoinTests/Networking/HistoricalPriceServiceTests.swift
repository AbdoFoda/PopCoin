//
//  HistoricalPriceServiceTests.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//


import XCTest
@testable import PopCoin

@MainActor
final class HistoricalPriceServiceTests: XCTestCase {

    func test_fetchPrices_returnsNormalizedPrices_whenValid() async throws {
        // Given
        let mockRepo = MockHistoricalPricesRepo()
        let today = Date()
        let dayPrices = [CoinDayPrice(date: today, priceEUR: 100)]

        mockRepo.stubbedResponse = MarketChartResponse(
            prices: [[today.timeIntervalSince1970 * 1000, 100.0]]
        )

        let mockNormalizer = MockPricesNormalizer()
        mockNormalizer.normalizedOutput = dayPrices

        let service = HistoricalPriceService(
            pricesNormalizer: mockNormalizer,
            priceRepository: mockRepo
        )

        // When
        let result = try await service.fetchPrices(days: 1)

        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.priceEUR, 100)
    }

    func test_fetchPrices_throwsNoData_whenNormalizerReturnsEmpty() async {
        let mockRepo = MockHistoricalPricesRepo()
        mockRepo.stubbedResponse = MarketChartResponse(
            prices: [[Date().timeIntervalSince1970 * 1000, 100.0]]
        )

        let mockNormalizer = MockPricesNormalizer()
        mockNormalizer.normalizedOutput = []

        let service = HistoricalPriceService(
            pricesNormalizer: mockNormalizer,
            priceRepository: mockRepo
        )

        do {
            _ = try await service.fetchPrices(days: 1)
            XCTFail("Expected HistoricalPriceServiceError.noData")
        } catch let error as HistoricalPriceServiceError {
            XCTAssertEqual(error, .noData)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_fetchPrices_throwsTodayNotAvailable_whenFirstDateIsNotToday() async {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!

        let mockRepo = MockHistoricalPricesRepo()
        mockRepo.stubbedResponse = MarketChartResponse(
            prices: [[yesterday.timeIntervalSince1970 * 1000, 88.0]]
        )

        let mockNormalizer = MockPricesNormalizer()
        mockNormalizer.normalizedOutput = [
            CoinDayPrice(date: yesterday, priceEUR: 88.0)
        ]

        let service = HistoricalPriceService(
            pricesNormalizer: mockNormalizer,
            priceRepository: mockRepo
        )

        do {
            _ = try await service.fetchPrices(days: 1)
            XCTFail("Expected HistoricalPriceServiceError.todayNotAvailable")
        } catch let error as HistoricalPriceServiceError {
            XCTAssertEqual(error, .todayNotAvailable)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
