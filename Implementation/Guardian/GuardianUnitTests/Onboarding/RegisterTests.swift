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
    
    // MARK: mock RegisterService
    class MockRegisterService: RegisterService {
        var registerResult: Result<Void, Error> = .failure(MockError.notAvailableError)
        
        func register(with details: RegisterDetails) -> AnyPublisher<Void, Error> {
            return Result.Publisher(registerResult).eraseToAnyPublisher()
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
    
    var viewModel: RegisterVM!
    var mockService: MockRegisterService!
    
    // MARK: setUP
    override func setUp() {
        super.setUp()
        mockService = MockRegisterService()
        viewModel = RegisterVM(service: mockService)
    }
    
    // MARK: tearDown
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testSuccessfulRegister() {
        // Given
        mockService.registerResult = .success(())
        
        // When
        viewModel.register()
        
        // Then
        XCTAssertEqual(viewModel.state, .successful)
    }
    
    func testFailedRegister() {
        // Given
        mockService.registerResult = .failure(MockError.sampleError)
        
        // When
        viewModel.register()
        
        // Then
        XCTAssertEqual(viewModel.state, .failed(error: MockError.sampleError))
    }
    
    func testNotAvailableRegister() {
        // When
        viewModel.register()
        
        // Then
        XCTAssertNotEqual(viewModel.state, .successful)
        XCTAssertNotEqual(viewModel.state, .failed(error: MockError.sampleError))
        XCTAssertEqual(viewModel.state, .failed(error: MockError.notAvailableError))
    }
}
