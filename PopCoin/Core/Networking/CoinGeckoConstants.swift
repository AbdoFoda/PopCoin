//
//  CoinGeckoConstants.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//


enum CoinGeckoConstants {
    static let baseURL = "https://api.coingecko.com/api/v3"

    enum Currency: String {
        case eur = "eur"
        case usd = "usd"
        case gbp = "gbp"
        static let allCurrencies: [Currency] = [
            eur,
            usd,
            gbp
        ]
        var symbol: String {
            switch self{
            case .eur:
                "€"
            case .usd:
                "$"
            case .gbp:
                "£"
            }
        }
        var presentationValue: String {
            switch self{
            case .eur:
                "Euro"
            case .usd:
                "US Dollar"
            case .gbp:
                "Pound Sterling"
            }
        }
    }

    enum Coin {
        static let bitcoin = "bitcoin"
    }
}

