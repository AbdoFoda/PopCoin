//
//  BitcoinPriceListViewModelProtocol.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//


import Foundation

@MainActor
protocol BitcoinPriceListViewModelProtocol: ObservableObject {
    var priceHistory: [CoinDayPrice] { get }
    var todayPrice: CoinDayPrice? { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var isLoadingTodayPrice: Bool { get }
    func fetchData() async
    func fetchData(days: Int) async
    /// Fetches  historical coin prices from the API.
    /// - Note: This function is **not** intended to be called from the UI layer. It's made `internal` for testability.
    /// - Returns: An array of `CoinDayPrice` objects.
    func fetchPrices(days: Int) async throws -> [CoinDayPrice]
    func refresh() async
}

extension BitcoinPriceListViewModelProtocol {
    func fetchData() async {
        await fetchData(days: AppConfig.defaultHistoricalDays)
    }
}
