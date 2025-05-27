//
//  CoinCurrencyPrice.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//


struct CoinCurrencyPrice: Identifiable {
    var id: String {currency.rawValue}
    let currency: CoinGeckoConstants.Currency
    let price: Double
    
    var formattedPrice: String {
        currency.symbol + price.formattedPrice
    }
}
