//
//  CoinGeckoAPITests.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 28.05.25.
//


import XCTest
@testable import PopCoin

final class CoinGeckoAPITests: XCTestCase {
    
    private var api: CoinGeckoAPI!
    private var testURL: URL!
    
    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        api = CoinGeckoAPI(
            session: session,
            coinID: "bitcoin",
            currency: "usd",
            apiKey: "fake-key",
            apiKeyHeader: "x-api-key"
        )
        
        testURL = URL(string: "https://api.coingecko.com/api/v3/mock")!
    }

    override func tearDown() {
        api = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
    
    struct MockModel: Codable, Equatable {
        let id: String
    }

    func test_successfulResponse_decodesModel() async throws {
        let expectedModel = MockModel(id: "btc")
        let data = try JSONEncoder().encode(expectedModel)

        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: self.testURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        let result: MockModel = try await api.request(MockModel.self, from: testURL)
        XCTAssertEqual(result, expectedModel)
    }

    func test_unauthorizedResponse_throwsUnauthorizedError() async {
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: self.testURL, statusCode: 401, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }

        do {
            _ = try await api.request(MockModel.self, from: testURL)
            XCTFail("Expected to throw .unauthorized error")
        } catch let error as NetworkError {
            guard case .unauthorized = error else {
                XCTFail("different network error returned: \(error)")
                return
            }
        } catch {
            XCTFail("Unexpected error returned: \(error)")
        }
    }

    func test_notFoundResponse_throwsNotFoundError() async {
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: self.testURL, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }

        do {
            _ = try await api.request(MockModel.self, from: testURL)
            XCTFail("Expected to throw .notFound error")
        } catch let error as NetworkError {
            guard case .notFound = error else {
                XCTFail("different network error returned: \(error)")
                return
            }
        }  catch {
            XCTFail("Unexpected error returned: \(error)")
        }
    }

    func test_retryOnTooManyRequests_withRetryAfterHeader() async {
        var callCount = 0
        MockURLProtocol.requestHandler = { _ in
            callCount += 1
            if callCount == 1 {
                let response = HTTPURLResponse(
                    url: self.testURL,
                    statusCode: 429,
                    httpVersion: nil,
                    headerFields: ["Retry-After": "0.1"]
                )!
                return (response, Data())
            } else {
                let model = MockModel(id: "btc")
                let data = try! JSONEncoder().encode(model)
                let response = HTTPURLResponse(url: self.testURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, data)
            }
        }
        
        do {
            let result: MockModel = try await api.request(
                MockModel.self,
                from: testURL
            )
            XCTAssertEqual(result, MockModel(id: "btc"))
            XCTAssertEqual(callCount, 2)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_decodingError_throwsDecodingError() async {
        let invalidData = Data("invalid-json".utf8)

        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: self.testURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, invalidData)
        }

        do {
            _ = try await api.request(MockModel.self, from: testURL)
            XCTFail("Expected decoding error")
        } catch let error as NetworkError {
            guard case .decodingError = error else {
                XCTFail("Expected decodingError, got: \(error)")
                return
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_maxRetriesExceeded_throwsRetryLimitExceeded() async {
        MockURLProtocol.requestHandler = { _ in
            throw URLError(.timedOut)
        }

        do {
            _ = try await api.request(MockModel.self, from: testURL)
            XCTFail("Expected retry limit exceeded")
        } catch let error as NetworkError {
            guard case .retryLimitExceeded = error else {
                XCTFail("Expected retryLimitExceeded, got: \(error)")
                return
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
