//
//  SessionServiceTests.swift
//  GuardianUnitTests
//
//  Created by Siyu Yao on 01/04/2023.
//

import XCTest
@testable import Guardian

final class SessionServiceTests: XCTestCase {
    
    // MARK: mock authetication
    class MockAuthSignOut: AuthSignOut {
        var signOutCalled = false
        
        func signOut() throws {
            signOutCalled = true
        }
    }
    
    var sessionService: SessionServiceImpl!
    var mockAuthSignOut: MockAuthSignOut!
    
    override func setUp() {
        super.setUp()
        mockAuthSignOut = MockAuthSignOut()
        sessionService = SessionServiceImpl(authSignOut: mockAuthSignOut)
    }
    
    override func tearDown() {
        sessionService = nil
        mockAuthSignOut = nil
        super.tearDown()
    }
    
    func testLogout() {
        // When
        sessionService.logout()
        
        // Then
        XCTAssertTrue(mockAuthSignOut.signOutCalled)
    }
}

