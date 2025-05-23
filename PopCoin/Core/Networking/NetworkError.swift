//
//  NetworkError.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 22.05.25.
//


enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed
    case invalidResponse
}
