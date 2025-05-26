//
//  Untitled.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 26.05.25.
//
import Foundation
internal struct PricesNormalizer: PricesNormalizerProtocol {
    /// Normalizes an array of `CoinDayPrice` objects by:
    /// 1. Removing duplicates for the same calendar day (keeping the most recent timestamp per day)
    /// 2. Sorting the result by date descending (today → past)
    /// 3. Ensuring today's price is first if present
    func normalize(_ prices: [CoinDayPrice]) -> [CoinDayPrice] {
        let calendar = Calendar.current

        // Group prices by day
        var latestPerDay: [Date: CoinDayPrice] = [:]

        for price in prices {
            let day = calendar.startOfDay(for: price.date)

            if let existing = latestPerDay[day] {
                // Keep the one with the later timestamp
                if price.date > existing.date {
                    latestPerDay[day] = price
                }
            } else {
                latestPerDay[day] = price
            }
        }

        // Sort by full date descending (most recent first)
        let sorted = latestPerDay
            .values
            .sorted { $0.date > $1.date }

        return sorted
    }
}
