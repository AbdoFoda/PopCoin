//
//  BitcoinPriceListViewModel.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//

import Combine

@MainActor
final class BitcoinPriceListViewModel: BitcoinPriceListViewModelProtocol {
    @Published private(set) var prices: [CoinDayPrice] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let api: CoinGeckoAPIProtocol
    private let numberOfDays: Int

    init(
        api: CoinGeckoAPIProtocol,
        numberOfDays: Int
    ) {
        self.api = api
        self.numberOfDays = numberOfDays
    }

    func fetchPrices() async {
        isLoading = true
        errorMessage = nil
        do {
            prices = try await api.fetchHistoricalPrices(days: numberOfDays)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
