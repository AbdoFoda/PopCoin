//
//  PriceDetailsViewModelTests.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//


import XCTest
@testable import PopCoin

@MainActor
final class PriceDetailsViewModelTests: XCTestCase {

    func test_fetch_success_setsPricesAndDateToShow() async {
        // Given
        let testDate = Date()
        let mockService = MockFetchPriceService()
        mockService.result = .success(
            CoinMultiCurrencyPrice(
                date: Date(),
                prices: [
                    CoinCurrencyPrice(currency: .eur, price: 30000.0),
                    CoinCurrencyPrice(currency: .usd, price: 32000.0)
        ]))

        let viewModel = PriceDetailsViewModel(
            date: testDate,
            coinID: "bitcoin",
            currencies: [.eur, .usd],
            fetchService: mockService
        )

        // When
        await viewModel.fetch()

        // Then
        XCTAssertEqual(viewModel.prices.count, 2)
        XCTAssertEqual(viewModel.prices.first?.currency, .eur)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.dateToShow, DateFormatter.fullPresentationDate.string(from: testDate))
    }

    func test_fetch_failure_setsErrorMessage() async {
        // Given
        let mockService = MockFetchPriceService()
        mockService.result = .failure(URLError(.notConnectedToInternet))

        let viewModel = PriceDetailsViewModel(
            date: Date(),
            coinID: "bitcoin",
            currencies: [.eur],
            fetchService: mockService
        )

        // When
        await viewModel.fetch()

        // Then
        XCTAssertTrue(viewModel.prices.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func test_fetchPrice_pure_internalMethod_returnsCorrectData() async throws {
        let mockService = MockFetchPriceService()
        let expected = CoinMultiCurrencyPrice(
            date: Date(),
            prices: [
                CoinCurrencyPrice(currency: .gbp, price: 1234)
            ]
        )
        mockService.result = .success(expected)

        let vm = PriceDetailsViewModel(
            date: Date(),
            coinID: "bitcoin",
            currencies: [.gbp],
            fetchService: mockService
        )

        let result = try await vm.fetchPrice(for: Date())

        XCTAssertEqual(result.prices.count, 1)
        XCTAssertEqual(result.prices.first?.currency, .gbp)
    }
}
