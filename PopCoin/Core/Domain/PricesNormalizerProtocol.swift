//
//  PricesNormalizer 2.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 26.05.25.
//


internal protocol PricesNormalizerProtocol {
    func normalize(_ prices: [CoinDayPrice]) -> [CoinDayPrice]
}
