//
//  NetworkError.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 22.05.25.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case serverError(Int, Data)
    case unauthorized
    case forbidden
    case notFound
    case tooManyRequests(retryAfter: String?)
    case noData
    case retryLimitExceeded(Error?)
    case unhandledStatusCode(Int)

    var description: String {
        switch self {
        case .invalidURL: return "Invalid URL provided"
        case .invalidResponse: return "Invalid response from the server"
        case .decodingError(let error): return "Decoding failed: \(error.localizedDescription)"
        case .serverError(let code, _): return "Server error with status code: \(code)"
        case .unauthorized: return "Unauthorized (401)"
        case .forbidden: return "Forbidden (403)"
        case .notFound: return "Not found (404)"
        case .tooManyRequests(let retryAfter): return "Too many requests (429). Retry-After: \(retryAfter ?? "N/A")"
        case .noData: return "Empty response data"
        case .retryLimitExceeded(let error): return "Max retries reached: \(error?.localizedDescription ?? "No underlying error")"
        case .unhandledStatusCode(let code): return "Unhandled status code: \(code)"
        }
    }
}

