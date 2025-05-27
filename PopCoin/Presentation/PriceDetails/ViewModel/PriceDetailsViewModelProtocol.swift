//
//  PriceDetailsViewModelProtocol.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//

import Combine
import Foundation
@MainActor
protocol PriceDetailsViewModelProtocol: ObservableObject {
    var dateToShow: String { get }
    var prices: [CoinCurrencyPrice] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    
    func fetch() async
}
