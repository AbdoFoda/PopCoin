//
//  PriceFormatter.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//

extension Double {
    var formattedPrice: String {
        String(format: "%.2f", self)
    }
}
