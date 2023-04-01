//
//  ResetPasswordTests.swift
//  GuardianUnitTests
//
//  Created by Siyu Yao on 01/04/2023.
//

import XCTest
import Combine

@testable import Guardian

// MARK: mock sercive class
// to isolate from external dependencies, i.e. network requests(Combine)
class ResetPasswordServiceMock: ResetPasswordServiceProtocol {
    var sendPasswordResetResult: Result<Void, Error>?

    func sendPasswordReset(to email: String) -> AnyPublisher<Void, Error> {
        if let result = sendPasswordResetResult {
            return Future { promise in
                switch result {
                case .success:
                    promise(.success(()))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
            .eraseToAnyPublisher()
        } else {
            let originalService = ResetPasswordService()
            return originalService.sendPasswordReset(to: email)
        }
    }
}

final class ResetPasswordVMTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    // MARK: setUP
    override func setUp() {
        super.setUp()
        cancellables = []
    }

    // MARK: tearDown
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

    func testSendPasswordReset_Success() {
        // Given
        let service = ResetPasswordServiceMock()
        service.sendPasswordResetResult = .success(())
        let viewModel = ResetPasswordVM(service: service)
        viewModel.email = "test@example.com"

        let expectation = XCTestExpectation(description: "Reset password successful")

        // When
        viewModel.$state
            .sink { state in
                if state == .successful {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.sendPasswordReset()

        // Then
        wait(for: [expectation], timeout: 1)
    }

    func testSendPasswordReset_Failure() {
        // Given
        let service = ResetPasswordServiceMock()
        let testError = NSError(domain: "TestError", code: 1, userInfo: nil)
        service.sendPasswordResetResult = .failure(testError)
        let viewModel = ResetPasswordVM(service: service)
        viewModel.email = "test@example.com"

        let expectation = XCTestExpectation(description: "Reset password failure")

        // When
        viewModel.$state
            .sink { state in
                if case .failed(let error) = state, error.localizedDescription == testError.localizedDescription {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.sendPasswordReset()

        // Then
        wait(for: [expectation], timeout: 1)
    }
}
