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
    @Published private(set) var isLoadingTodayPrice = false
    private let historicalPriceService: HistoricalPriceService
    
    private let numberOfDays: Int
    private var cancellables = Set<AnyCancellable>()

    init(
        historicalPriceService: HistoricalPriceService,
        numberOfDays: Int
    ) {
        self.historicalPriceService = historicalPriceService
        self.numberOfDays = numberOfDays
        self.setupAutoRefresh()
    }
    
    private func setupAutoRefresh() {
        Timer
            .publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                Task {
                    await self?.refresh()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchData(days: Int) async {
        guard isLoading == false else { return }
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        do {
            var prices: [CoinDayPrice] = try await fetchPrices(days: days)
            todayPrice = prices.removeFirst()
            priceHistory = prices
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    internal func fetchPrices(days: Int) async throws -> [CoinDayPrice] {
        try await historicalPriceService.fetchPrices(days: numberOfDays)
    }
    
    
    func refresh() async {
        guard isLoadingTodayPrice == false else { return }
        isLoadingTodayPrice = true
        defer { isLoadingTodayPrice = false }
        do {
            todayPrice = try await fetchPrices(days: 0).first
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
