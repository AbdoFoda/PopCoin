//
//  BitcoinPriceListViewModelProtocol.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//


import Foundation

@MainActor
protocol BitcoinPriceListViewModelProtocol: ObservableObject {
    var prices: [CoinDayPrice] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }

    func fetchPrices() async
}
