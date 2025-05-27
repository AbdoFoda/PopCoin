//
//  ViewFactory.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 25.05.25.
//
import SwiftUI

@MainActor
final class ViewFactory: ViewFactoryProtocol {
    static let shared = ViewFactory()
    internal init() {}

    func makeBitcoinPriceListView() -> AnyView {
        let viewModel = BitcoinPriceListViewModel(
            historicalPriceService: HistoricalPriceService.shared,
            numberOfDays: AppConfig.defaultHistoricalDays
        )
        let view = BitcoinPriceListView(viewModel: viewModel)
        return AnyView(view)
    }
    
    func makePriceDetailsView(for date: Date) -> AnyView {
        let viewModel = PriceDetailsViewModel(
            date: date,
            coinID: AppConfig.defaultCoin,
            currencies: CoinGeckoConstants.Currency.allCurrencies,
            fetchService: FetchPriceService.shared
        )
        let view = PriceDetailsView(viewModel: viewModel)
        return AnyView(view)
    }
}
