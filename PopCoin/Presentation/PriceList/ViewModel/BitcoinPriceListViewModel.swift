//
//  BitcoinPriceListViewModel.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//

import Combine
import Foundation

@MainActor
final class BitcoinPriceListViewModel: BitcoinPriceListViewModelProtocol {
    
    @Published private(set) var priceHistory: [CoinDayPrice] = []
    @Published private(set) var todayPrice: CoinDayPrice?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    
    private let historicalPriceService: HistoricalPriceService
    private let numberOfDays: Int

    init(
        historicalPriceService: HistoricalPriceService,
        numberOfDays: Int
    ) {
        self.historicalPriceService = historicalPriceService
        self.numberOfDays = numberOfDays
    }
    
    func fetchData(days: Int) async {
        isLoading = true
        errorMessage = nil
        do {
            var prices: [CoinDayPrice] = try await fetchPricesInBackground(days: days)
            todayPrice = prices.removeFirst()
            priceHistory = prices
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    internal func fetchPricesInBackground(days: Int) async throws-> [CoinDayPrice] {
        try await Task.detached(priority: .userInitiated) {
            try await self.fetchPrices(days: days)
        }.value
    }
    
    internal func fetchPrices(days: Int) async throws -> [CoinDayPrice] {
        try await historicalPriceService.fetchPrices(days: numberOfDays)
    }
    
    
    func refresh() async {
        isLoading = true
        do {
            todayPrice = try await fetchPricesInBackground(days: 0).first
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
