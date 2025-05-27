//
//  CoinGeckoAPI.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 22.05.25.
//

import Foundation

final class CoinGeckoAPI: CoinGeckoAPIProtocol {
    internal let session: URLSession
    internal let coinID: String
    internal let currency: String
    private let apiKey: String
    private let apiKeyHeader: String

    static let shared = CoinGeckoAPI(
        session: .shared,
        coinID: AppConfig.defaultCoin,
        currency: AppConfig.defaultCurrency.rawValue,
        apiKey: APIKeys.coinGecko,
        apiKEyHeader: APIKeys.APIKeyHeader
    )
    
    internal init(session: URLSession,
                  coinID: String,
                  currency: String,
                  apiKey: String,
                  apiKEyHeader: String
    ) {
        self.session = session
        self.coinID = coinID
        self.currency = currency
        self.apiKey = apiKey
        self.apiKeyHeader = apiKEyHeader
    }
    
    func request<T: Decodable>(_ type: T.Type,
                               from url: URL,
                               maxRetries: Int = 2,
                               delay: TimeInterval = 1.0,
                               currentAttempt: Int = 0,
                               lastError: Error? = nil
    ) async throws -> T {
        if currentAttempt < maxRetries && isRetryable(lastError){
            do {
                let request = makeRequest(for: url)
                let (data, _) = try await session.data(for: request)
                return try JSONDecoder().decode(T.self, from: data)
            }catch {
                try await Task.sleep(nanoseconds: UInt64(delay) * 1_000_000_000)
                // exponential backoff.
                return try await request(type,
                        from: url,
                        delay: delay * pow(2.0, Double(currentAttempt)),
                        currentAttempt: currentAttempt + 1,
                        lastError: error
                )
            }
        }
        throw lastError ?? NetworkError.invalidResponse
    }

    private func isRetryable(_ error: Error?) -> Bool {
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

    private func makeRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        return authRequest(request: URLRequest(url: url))
    }
    
    private func authRequest(request: URLRequest) -> URLRequest {
        var request = request
        request.setValue(apiKey, forHTTPHeaderField: apiKeyHeader)
        return request
    }
}
