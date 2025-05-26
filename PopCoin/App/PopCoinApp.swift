//
//  PopCoinApp.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 22.05.25.
//

import SwiftUI

@main
struct PopCoinApp: App {
    private let viewFactory: ViewFactory = .init()
    var body: some Scene {
        WindowGroup {
            viewFactory.makeBitcoinPriceListView()
        }
    }
}
