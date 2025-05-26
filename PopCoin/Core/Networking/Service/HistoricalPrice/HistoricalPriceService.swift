//
//  FetchPriceService.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 26.05.25.
//

import Foundation

internal final class HistoricalPriceService: HistoricalPriceServiceProtocol {
    var pricesNormalizer: PricesNormalizerProtocol
    var priceRepository: HistoricalPricesRepo
    
    init(
        pricesNormalizer: PricesNormalizer,
        priceRepository: HistoricalPricesRepo
    ) {
        self.pricesNormalizer = pricesNormalizer
        self.priceRepository = priceRepository
    }
    
    func fetchPrices(days: Int) async throws -> [CoinDayPrice] {
        let rawPrices = try await priceRepository.fetchHistoricalPrices(days: days)
        let prices = rawPrices.toDayPriceList()
        let normalizedPrices = pricesNormalizer.normalize(prices)
        let calendar = Calendar.current
        if normalizedPrices.isEmpty {
            throw HistoricalPriceServiceError.noData
        }else if !calendar.isDateInToday(normalizedPrices.first!.date){
            throw HistoricalPriceServiceError.todayNotAvailable
        }
        return normalizedPrices
    }
}
