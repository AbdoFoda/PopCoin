//
//  PriceDetailsViewModel.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//

import Combine
import Foundation

@MainActor
final class PriceDetailsViewModel: PriceDetailsViewModelProtocol {
    @Published private(set) var prices: [CoinCurrencyPrice] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    let dateToShow: String

    private let date: Date
    private let coinID: String
    private let currencies: [CoinGeckoConstants.Currency]
    private let fetchService: FetchPriceServiceProtocol

    init(
        date: Date,
        coinID: String,
        currencies: [CoinGeckoConstants.Currency],
        fetchService: FetchPriceServiceProtocol
    ) {
        self.date = date
        self.dateToShow = DateFormatter.fullPresentationDate.string(from: date)
        self.coinID = coinID
        self.currencies = currencies
        self.fetchService = fetchService
    }

    // to be used in UI Layer.
    func fetch() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            prices = try await fetchPrice(for: date).prices
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // made an internal pure version for testing
    internal func fetchPrice(for date: Date) async throws -> CoinMultiCurrencyPrice {
        try await fetchService.fetchPrice(for: date)
    }
}
