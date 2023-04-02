//
//  SessionServiceTests.swift
//  GuardianUnitTests
//
//  Created by Siyu Yao on 01/04/2023.
//

import XCTest
@testable import Guardian

final class SessionServiceTests: XCTestCase {
    
    var sut_sessionService: SessionServiceImpl!
    var mockAuthSignOut: MockAuthSignOut!
    
    override func setUp() {
        super.setUp()
        mockAuthSignOut = MockAuthSignOut()
        sut_sessionService = SessionServiceImpl(authSignOut: mockAuthSignOut)
    }
    
    override func tearDown() {
        sut_sessionService = nil
        mockAuthSignOut = nil
        super.tearDown()
    }
    
    func testLogout() {
        // When
        sut_sessionService.logout()
        
        // Then
        XCTAssertTrue(mockAuthSignOut.signOutCalled)
    }
}

