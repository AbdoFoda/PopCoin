//
//  BitcoinPriceListViewModelTests.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//


import XCTest
@testable import PopCoin

@MainActor
final class BitcoinPriceListViewModelTests: XCTestCase {
    func test_initialState() {
        let mockAPI = MockCoinGeckoAPI()
        let viewModel = BitcoinPriceListViewModel(api: mockAPI, numberOfDays: 14)

        XCTAssertTrue(viewModel.prices.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_fetchPrices_success() async {
        let mockAPI = MockCoinGeckoAPI()
        mockAPI.result = .success([
            CoinDayPrice(date: Date(), priceEUR: 30000)
        ])
        let viewModel = BitcoinPriceListViewModel(api: mockAPI, numberOfDays: 14)

        await viewModel.fetchPrices()

        XCTAssertEqual(viewModel.prices.count, 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_fetchPrices_failure() async {
        let mockAPI = MockCoinGeckoAPI()
        mockAPI.result = .failure(NSError(domain: "Test", code: 1, userInfo: nil))
        let viewModel = BitcoinPriceListViewModel(api: mockAPI, numberOfDays: 14)

        await viewModel.fetchPrices()

        XCTAssertTrue(viewModel.prices.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
    }
}
