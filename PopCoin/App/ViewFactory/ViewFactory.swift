//
//  ViewFactory.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 25.05.25.
//
import SwiftUI

@MainActor
final class ViewFactory: ViewFactoryProtocol {
    func makeBitcoinPriceListView() -> AnyView {
        let viewModel = BitcoinPriceListViewModel(
            historicalPriceService: HistoricalPriceService(
                pricesNormalizer: PricesNormalizer(),
                priceRepository: CoinGeckoAPI.shared
            ), numberOfDays: AppConfig.defaultHistoricalDays
        )
        let view = BitcoinPriceListView(viewModel: viewModel)
        return AnyView(view)
    }
}
