//
//  CoinGeckoAPITests.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//


import XCTest
@testable import PopCoin

final class CoinGeckoAPITests: XCTestCase {

    var sut: CoinGeckoAPI!
    var session: URLSession!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)

        sut = CoinGeckoAPI(session: session,
                           coinID: CoinGeckoConstants.Coin.bitcoin,
                           currency: CoinGeckoConstants.Currency.eur
        ) // Injected session for testing
    }

    override func tearDown() {
        sut = nil
        session = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }

    func testFetchLast14DaysEUR_returnsDecodedPrices() async throws {
        // Given
        let json = """
        {
          "prices": [
            [1716153600000, 64312.12],
            [1716067200000, 63700.98]
          ]
        }
        """
        let data = Data(json.utf8)
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(
                url: URL(string: CoinGeckoConstants.baseURL)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }

        // When
        let result = try await sut.fetchHistoricalPrices(days: 14)
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.priceEUR, 64312.12)
    }

    func testFetchLast14DaysEUR_throwsOnInvalidData() async {
        let badJSON = """
        { "wrong_key": [] }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(
                url: URL(string: "https://example.com")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, badJSON)
        }

        do {
            _ = try await sut.fetchHistoricalPrices(days: 14)
            XCTFail("Expected decoding error")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }

    func testFetchLast14DaysEUR_throwsOnNetworkError() async {
        MockURLProtocol.requestHandler = { _ in
            throw URLError(.notConnectedToInternet)
        }

        do {
            _ = try await sut.fetchHistoricalPrices(days: 14)
            XCTFail("Expected network error")
        } catch {
            XCTAssertTrue((error as? URLError)?.code == .notConnectedToInternet)
        }
    }
}
