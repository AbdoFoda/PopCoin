//
//  AppConfig.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//
import Foundation

enum AppConfig {
    static let defaultHistoricalDays = 14
    static let defaultRefreshInterval: TimeInterval = 60
    static let defaultCurrency: CoinGeckoConstants.Currency = CoinGeckoConstants.Currency.eur
    static let defaultCoin: String = CoinGeckoConstants.Coin.bitcoin
}
