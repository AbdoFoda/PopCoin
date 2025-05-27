//
//  HistoricalPriceResponse.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 22.05.25.
//


struct HistoricalPriceResponse: Decodable {
    struct MarketData: Decodable {
        let current_price: [String: Double]
    }
    let market_data: MarketData?
}
