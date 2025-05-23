//
//  MarketChartResponse.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 22.05.25.
//
import Foundation

struct MarketChartResponse: Decodable {
    let prices: [[Double]]
    
    func toDayPriceList() -> [CoinDayPrice] {
        prices.compactMap { pair in
            guard pair.count == 2 else { return nil }
            // convert ms to seconds
            let date = Date(timeIntervalSince1970: pair[0] / 1000)
            return CoinDayPrice(date: date, priceEUR: pair[1])
        }
    }
}
