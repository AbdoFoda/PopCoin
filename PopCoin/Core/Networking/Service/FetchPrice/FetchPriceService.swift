//
//  FetchPriceService.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//
import Foundation

final class FetchPriceService: FetchPriceServiceProtocol {
    var apiClient: CoinGeckoAPIProtocol

    static let shared = FetchPriceService(apiClient: CoinGeckoAPI.shared)
    internal init(apiClient: CoinGeckoAPIProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchPrice(for date: Date) async throws -> CoinMultiCurrencyPrice {
        let prices = try await CoinGeckoAPI.shared.fetchPrice(for: date)
        let filterdPrices = prices.current_price.filter{ CoinGeckoConstants.Currency.allCurrencies.map{$0.rawValue}.contains($0.key)
        }
        if filterdPrices.count == 0 {
            throw FetchPriceServiceError.noData
        }
        return CoinMultiCurrencyPrice(
            date: date,
            prices: filterdPrices.compactMap({ currency, price in
                if let currency = CoinGeckoConstants.Currency(rawValue: currency) {
                    return CoinCurrencyPrice(currency: currency, price: price)
                }else {
                    return nil
                }
            })
        )
    }
}
