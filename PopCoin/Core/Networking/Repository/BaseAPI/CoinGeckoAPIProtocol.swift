//
//  CoinGeckoAPIProtocol.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//

import Foundation

protocol CoinGeckoAPIProtocol {
    var session : URLSession { get }
    var coinID: String { get }
    var currency: String { get }
    
    func request<T: Decodable>(
        _ type: T.Type,
        from url: URL
    ) async throws -> T
}

