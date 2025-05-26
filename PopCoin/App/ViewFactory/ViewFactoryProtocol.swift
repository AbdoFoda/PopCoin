//
//  ViewFactoryProtocol.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 25.05.25.
//


import SwiftUI

@MainActor
protocol ViewFactoryProtocol {
    func makeBitcoinPriceListView() -> AnyView
}
