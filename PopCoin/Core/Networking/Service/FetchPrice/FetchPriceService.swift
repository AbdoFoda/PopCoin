//
//  FetchPriceService.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//
import Foundation

final class FetchPriceService: FetchPriceServiceProtocol {
    var fetchPriceRepo: FetchPriceRepo

    static let shared = FetchPriceService(fetchPriceRepo: CoinGeckoAPI.shared)
    internal init(fetchPriceRepo: FetchPriceRepo) {
        self.fetchPriceRepo = fetchPriceRepo
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
