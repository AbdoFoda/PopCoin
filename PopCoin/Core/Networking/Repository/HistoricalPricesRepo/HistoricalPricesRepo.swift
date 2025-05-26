//
//  HistoricalPricesRepo.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 26.05.25.
//

protocol HistoricalPricesRepo {
    func fetchHistoricalPrices(days: Int) async throws -> MarketChartResponse
}
