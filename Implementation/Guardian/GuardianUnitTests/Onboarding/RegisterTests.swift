//
//  RegisterTests.swift
//  GuardianUnitTests
//
//  Created by Siyu Yao on 29/03/2023.
//

import XCTest
import Combine

@testable import Guardian

final class RegisterTests: XCTestCase {
    
    var sut_viewModel: RegisterVM!
    var mockService: MockRegisterService!
    
    // MARK: setUP
    override func setUp() {
        super.setUp()
        mockService = MockRegisterService()
        sut_viewModel = RegisterVM(service: mockService)
    }
    
    // MARK: tearDown
    override func tearDown() {
        sut_viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testSuccessfulRegister() {
        // Given
        mockService.registerResult = .success(())
        
        // When
        sut_viewModel.register()
        
        // Then
        XCTAssertEqual(sut_viewModel.state, .successful)
    }
    
    func testFailedRegister() {
        // Given
        mockService.registerResult = .failure(MockRegisterError.sampleError)
        
        // When
        sut_viewModel.register()
        
        // Then
        XCTAssertEqual(sut_viewModel.state, .failed(error: MockRegisterError.sampleError))
    }
    
    func testNotAvailableRegister() {
        // When
        sut_viewModel.register()
        
        // Then
        XCTAssertNotEqual(sut_viewModel.state, .successful)
        XCTAssertNotEqual(sut_viewModel.state, .failed(error: MockRegisterError.sampleError))
        XCTAssertEqual(sut_viewModel.state, .failed(error: MockRegisterError.notAvailableError))
    }
}
