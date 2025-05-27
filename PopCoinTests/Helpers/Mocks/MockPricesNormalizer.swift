//
//  MockPricesNormalizer.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//

@testable import PopCoin

final class MockPricesNormalizer: PricesNormalizerProtocol {
    var normalizedOutput: [CoinDayPrice] = []
    func normalize(_ input: [CoinDayPrice]) -> [CoinDayPrice] {
        return normalizedOutput
    }
}
