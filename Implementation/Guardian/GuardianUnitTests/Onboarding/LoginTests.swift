//
//  LoginTests.swift
//  GuardianTests
//
//  Created by Siyu Yao on 29/03/2023.
//

import XCTest
import Combine

@testable import Guardian

class LoginTests: XCTestCase {

    // MARK: mock LoginService
    class MockLoginService: LoginService {
        var loginResult: Result<Void, Error> = .failure(MockError.notAvailableError)

        func login(with credentials: LoginCredentials) -> AnyPublisher<Void, Error> {
            return Result.Publisher(loginResult).eraseToAnyPublisher()
        }
    }

    // MARK: mock Error
    enum MockError: Error, LocalizedError {
        case sampleError
        case notAvailableError

        var errorDescription: String? {
            switch self {
            case .sampleError:
                return "Sample Error Description"
            case .notAvailableError:
                return "Not Available Error Description"
            }
        }
    }

    var viewModel: LoginEmailVM!
    var mockService: MockLoginService!

    // MARK: setUP
    override func setUp() {
        super.setUp()
        mockService = MockLoginService()
        viewModel = LoginEmailVM(service: mockService)
    }

    // MARK: tearDown
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testSuccessfulLogin() {
        // Given
        mockService.loginResult = .success(())

        // When
        viewModel.login()

        // Then
        XCTAssertEqual(viewModel.state, .successful)
    }

    func testFailedLogin() {
        // Given
        mockService.loginResult = .failure(MockError.sampleError)

        // When
        viewModel.login()

        // Then
        XCTAssertEqual(viewModel.state, .failed(error: MockError.sampleError))
    }

    func testNotAvailableLogin() {
        // When
        viewModel.login()

        // Then
        XCTAssertNotEqual(viewModel.state, .successful)
        XCTAssertNotEqual(viewModel.state, .failed(error: MockError.sampleError))
        XCTAssertEqual(viewModel.state, .failed(error: MockError.notAvailableError))
    }
}
