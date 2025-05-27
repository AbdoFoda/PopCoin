//
//  BitcoinPriceListViewModelTests.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//


import XCTest
@testable import PopCoin

import XCTest

@MainActor
final class BitcoinPriceListViewModelTests: XCTestCase {

    func test_fetchData_success_setsTodayAndHistory() async {
        // Given
        let today = CoinDayPrice(date: Date(), priceEUR: 100)
        let history = [CoinDayPrice(date: Date().addingTimeInterval(-86400), priceEUR: 90)] // 7 days back w
        let mockService = MockHistoricalPriceService()
        mockService.result = .success([today] + history)

        let viewModel = BitcoinPriceListViewModel(
            historicalPriceService: mockService,
            numberOfDays: 7
        )

        // When
        await viewModel.fetchData(days: 7)

        // Then
        XCTAssertEqual(viewModel.todayPrice?.priceEUR, 100)
        XCTAssertEqual(viewModel.priceHistory.count, 1)
        XCTAssertEqual(viewModel.priceHistory.first?.priceEUR, 90)
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_fetchData_failure_setsErrorMessage() async {
        // Given
        let mockService = MockHistoricalPriceService()
        mockService.result = .failure(URLError(.notConnectedToInternet))

        let viewModel = BitcoinPriceListViewModel(
            historicalPriceService: mockService,
            numberOfDays: 7
        )

        // When
        await viewModel.fetchData(days: 7)

        // Then
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.priceHistory.isEmpty)
        XCTAssertNil(viewModel.todayPrice)
    }

    func test_refresh_setsTodayPriceOnly() async {
        // Given
        let today = CoinDayPrice(date: Date(), priceEUR: 12345)
        let mockService = MockHistoricalPriceService()
        mockService.result = .success([today])

        let viewModel = BitcoinPriceListViewModel(
            historicalPriceService: mockService,
            numberOfDays: 0
        )

        // When
        await viewModel.refresh()

        // Then
        XCTAssertEqual(viewModel.todayPrice?.priceEUR, 12345)
        XCTAssertTrue(viewModel.priceHistory.isEmpty) // untouched
        XCTAssertNil(viewModel.errorMessage)
    }
}
