//
//  CoinGeckoAPI+Helpers.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 28.05.25.
//

import Foundation

// MARK: Helpers
extension CoinGeckoAPI {
    internal func isRetryable(_ error: Error?) -> Bool {
        if error == nil {
            return true
        }
        guard let urlError = error as? URLError else {
            return false
        }

        switch urlError.code {
        case .timedOut,
             .cannotFindHost,
             .cannotConnectToHost,
             .networkConnectionLost,
             .dnsLookupFailed,
             .notConnectedToInternet,
             .resourceUnavailable,
             .badServerResponse:
            return true
        default:
            return false
        }
    }

    internal func buildRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        return authRequest(request: URLRequest(url: url))
    }
    
    internal func authRequest(request: URLRequest) -> URLRequest {
        var request = request
        request.setValue(apiKey, forHTTPHeaderField: apiKeyHeader)
        return request
    }
}
