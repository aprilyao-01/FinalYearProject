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

    var sut_viewModel: LoginEmailVM!
    var mockService: MockLoginService!

    // MARK: setUP
    override func setUp() {
        super.setUp()
        mockService = MockLoginService()
        sut_viewModel = LoginEmailVM(service: mockService)
    }

    // MARK: tearDown
    override func tearDown() {
        sut_viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testSuccessfulLogin() {
        // Given
        mockService.loginResult = .success(())

        // When
        sut_viewModel.login()

        // Then
        XCTAssertEqual(sut_viewModel.state, .successful)
    }

    func testFailedLogin() {
        // Given
        mockService.loginResult = .failure(MockLoginError.sampleError)

        // When
        sut_viewModel.login()

        // Then
        XCTAssertEqual(sut_viewModel.state, .failed(error: MockLoginError.sampleError))
    }

    func testNotAvailableLogin() {
        // When
        sut_viewModel.login()

        // Then
        XCTAssertNotEqual(sut_viewModel.state, .successful)
        XCTAssertNotEqual(sut_viewModel.state, .failed(error: MockLoginError.sampleError))
        XCTAssertEqual(sut_viewModel.state, .failed(error: MockLoginError.notAvailableError))
    }
}
