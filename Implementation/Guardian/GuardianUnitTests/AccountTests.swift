//
//  AccountTests.swift
//  GuardianUnitTests
//
//  Created by Siyu Yao on 01/04/2023.
//

import XCTest
@testable import Guardian

final class AccountVMTests: XCTestCase {
    var sut: AccountVM!
    var mockAuthHandler: MockAuthHandler!
    var mockDatabaseReference: MockDatabaseReference!
    var onHideCalled = false

    override func setUp() {
        super.setUp()
        mockAuthHandler = MockAuthHandler()
        mockDatabaseReference = MockDatabaseReference()
        let mockActivityIndicator = MockActivityIndicator { [weak self] in
            self?.onHideCalled = true
        }
        sut = AccountVM()
    }

    override func tearDown() {
        sut = nil
        mockAuthHandler = nil
        mockDatabaseReference = nil
        onHideCalled = false
        super.tearDown()
    }

    func testSaveUserDetails_callsSetValueOnDatabaseReference() {
        sut.saveUserDetails()
        XCTAssertTrue(mockDatabaseReference.calledStatus["setValue"] ?? false)
    }

    func testSaveUserDetails_callsHideActivityIndicator() {
        sut.saveUserDetails()
        XCTAssertTrue(onHideCalled)
    }

    func testChangePassword_callsShowAndHideActivityIndicator() {
        let expectation = self.expectation(description: "ActivityIndicatorExpectation")
        sut.activityIndicator.showActivityIndicator()
        sut.changePassword(oldPassword: "oldPassword", newPassword: "newPassword")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertTrue(self.onHideCalled)
            expectation.fulfill()
        }
//        waitForExpectations(timeout: 3, handler: nil)
    }

    func testChangePIN_callsShowAndHideActivityIndicator() {
        let expectation = self.expectation(description: "ActivityIndicatorExpectation")
        sut.activityIndicator.showActivityIndicator()
        sut.changePIN(oldPin: "oldPin", newPin: "newPin")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertTrue(self.onHideCalled)
            expectation.fulfill()
        }
//        waitForExpectations(timeout: 3, handler: nil)
    }
}
