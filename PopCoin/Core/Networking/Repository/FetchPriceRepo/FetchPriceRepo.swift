//
//  FetchPriceRepo.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 25.05.25.
//
import Foundation

protocol FetchPriceRepo {
    func fetchPrice(for date: Date) async throws -> HistoricalPriceResponse
}
