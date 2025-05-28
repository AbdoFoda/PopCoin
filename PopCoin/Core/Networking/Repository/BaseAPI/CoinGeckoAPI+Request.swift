//
//  CoinGeckoAPI+rRequest.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 28.05.25.
//
import Foundation
// MARK: Request
extension CoinGeckoAPI: CoinGeckoAPIProtocol{
    func request<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        do {
            return try await handleRequest(type, from: url)
        }catch {
            return try await retryRequest(type, from: url)
        }
    }

    internal func handleRequest<T: Decodable>(_ : T.Type, from url: URL) async throws -> T {
        let request = buildRequest(for: url)
        let (data, response) = try await session.data(for: request)
        try handleResponseErrorIfAny(response,data: data)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error as DecodingError {
            throw NetworkError.decodingError(error)
        }
    }
    
    internal func handleResponseErrorIfAny(_ response: URLResponse,data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidURL
        }
        switch httpResponse.statusCode {
        case 200..<300:
            return
        case 401: throw NetworkError.unauthorized
        case 403: throw NetworkError.forbidden
        case 404: throw NetworkError.notFound
        case 429:
            let retryAfter = httpResponse.value(forHTTPHeaderField: NetworkConstants.retryAfterString)
            throw NetworkError.tooManyRequests(retryAfter: retryAfter)
        case 500..<600:
            throw NetworkError.serverError(httpResponse.statusCode, data)
        default:
            throw NetworkError.unhandledStatusCode(httpResponse.statusCode)
        }
    }
    
    internal func retryRequest<T: Decodable>(
        _ type: T.Type,
        from url: URL,
        delay: TimeInterval = NetworkConstants.defaultDelay,
        maxRetries: Int = NetworkConstants.maxRetries,
        currentAttempt: Int = 0,
        lastError: Error? = nil
    ) async throws -> T {
        guard currentAttempt < maxRetries else {
            throw NetworkError.retryLimitExceeded(lastError)
        }
        guard isRetryable(lastError) else {
            throw lastError ?? NetworkError.noData
        }
        // retry logic
        try await Task.sleep(nanoseconds: UInt64(delay) * 1_000_000_000)
        do {
            return try await handleRequest(type, from: url)
        } catch {
            return try await retryRequest(
                type,
                from: url,
                delay: delay * 2, // exponential backoff
                currentAttempt: currentAttempt + 1,
                lastError: error
            )
        }
    }
}
