//
//  AsynKronosTests.swift
//  AsynKronosTests
//
//  Created by Luis David Goyes Garces on 7/10/19.
//  Copyright © 2019 Condor Labs S.A.S. All rights reserved.
//

import XCTest
@testable import AsynKronos

class AsynKronosTests: XCTestCase {

    func testSimpleAsyncCall() {

        let expectationSuccess = XCTestExpectation(description: "expectationSuccess")
        let expectationDoFinally = XCTestExpectation(description: "expectationDoFinally")

        Async.await(
            {
                let result1 = try self.request1()
                let result2 = self.request2(input: result1)

                DispatchQueue.main.async {
                    print(result1)
                    print(result2)
                }

                XCTAssert(result1 == "response 1")
                XCTAssert(result2 == "response 2 after response 1")

                expectationSuccess.fulfill()
            },
            onError: {
                debugPrint($0)
            }, doFinally: {
                expectationDoFinally.fulfill()
            })

        wait(for: [expectationSuccess, expectationDoFinally], timeout: 10.0)
    }

    func testTwoNestedAsyncCalls() {

        let expectationSuccess = XCTestExpectation(description: "expectationSuccess")
        let expectationDoFinally = XCTestExpectation(description: "expectationDoFinally")

        Async.await(
            {
                let result1 = try self.request1()
                let result2 = self.request2(input: result1)

                DispatchQueue.main.async {
                    print(result1)
                    print(result2)
                }

                XCTAssert(result1 == "response 1")
                XCTAssert(result2 == "response 2 after response 1")

                self.anotherCall(expectation: expectationSuccess)
            },
            onError: {
                debugPrint($0)
            }, doFinally: {
                expectationDoFinally.fulfill()
            })

        wait(for: [expectationSuccess, expectationDoFinally], timeout: 10.0)
    }

    func testRequestWithError() {

        let expectation = XCTestExpectation(description: "async")

        Async.await(
            {
                let _ = try self.request4()
            },
            onError: {
                XCTAssert($0.localizedDescription == "Unexpected result")
                expectation.fulfill()
            })

        wait(for: [expectation], timeout: 10.0)
    }

    private func anotherCall(expectation: XCTestExpectation) {
        Async.await(
            {
                let result1 = try self.request1()
                let result2 = self.request2(input: result1)

                DispatchQueue.main.async {
                    print(result1)
                    print(result2)
                }

                XCTAssert(result1 == "response 1")
                XCTAssert(result2 == "response 2 after response 1")

                expectation.fulfill()
            },
            onError: {
                debugPrint($0)
            })
    }

    private func request1() throws -> String {
        sleep(2)
        return "response 1"
    }

    private func request2(input: String) -> String {
        sleep(3)
        return "response 2 after \(input)"
    }

    private func request3() -> String {
        sleep(1)
        return "response 3"
    }

    private func request4() throws -> String {
        sleep(1)
        throw AsyncError.unexpectedResult
    }
}

enum AsyncError: Error {
    case unexpectedResult
}

extension AsyncError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unexpectedResult:
            return NSLocalizedString("Unexpected result", comment: "Unexpected result")
        }
    }
}
