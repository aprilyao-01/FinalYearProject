//
//  AccountTests.swift
//  GuardianUnitTests
//
//  Created by Siyu Yao on 01/04/2023.
//

import XCTest
@testable import Guardian

final class AccountVMTests: XCTestCase {
    var accountVM: AccountVM!
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
        accountVM = AccountVM()
    }

    override func tearDown() {
        accountVM = nil
        mockAuthHandler = nil
        mockDatabaseReference = nil
        onHideCalled = false
        super.tearDown()
    }
    
    
    func testSaveUserDetails() {
        let expectation = XCTestExpectation(description: "Save user details completion expectation")
        
        // Set up the necessary data for saving user details
        let user = User(userId: "testUserId", userName: "testUserName", fullName: "testFullName", phoneNo: "testPhoneNo", PIN: "testPIN", userImage: "testUserImage")
        accountVM.currentUser = user
       // accountVM.isProfilePictureChanged = true
       // accountVM.fetchedImage = UIImage(named: "testImage") // Replace with an actual test image
        
        accountVM.saveUserDetails { success in
            XCTAssertTrue(success, "Failed to save user details")
            XCTAssertEqual(self.accountVM.currentUser.userId, "testUserId", "User ID does not match")
            XCTAssertEqual(self.accountVM.currentUser.userName, "testUserName", "User name does not match")
            XCTAssertEqual(self.accountVM.currentUser.fullName, "testFullName", "Full name does not match")
            XCTAssertEqual(self.accountVM.currentUser.phoneNo, "testPhoneNo", "Phone number does not match")
            XCTAssertEqual(self.accountVM.currentUser.PIN, "testPIN", "PIN does not match")
            XCTAssertNotNil(self.accountVM.currentUser.userImage, "User image is nil")

            
            // Clean up the test data
            self.accountVM.isProfilePictureChanged = false
            self.accountVM.fetchedImage = nil
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 15.0) // Adjust timeout value as needed
    }


    
    
    func  testfetchCurrentUser() {
        let expectation = XCTestExpectation(description: "Fetch current user expectation")
        
        accountVM.fetchCurrentUser(){ status in
            XCTAssertNotNil(self.accountVM.currentUser, "Current user is nil")
            XCTAssertNil(self.accountVM.fetchedImage, "Fetched image is nil")
            expectation.fulfill()

        }
        
        wait(for: [expectation], timeout: 5.0) // Adjust timeout value as needed
    }
    
    
    
    
    
    
    

    func testChangePassword_callsShowAndHideActivityIndicator() {
        let expectation = self.expectation(description: "ActivityIndicatorExpectation")
        accountVM.activityIndicator.showActivityIndicator()
        accountVM.changePassword(oldPassword: "oldPassword", newPassword: "newPassword")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertTrue(self.onHideCalled)
            expectation.fulfill()
        }
//        waitForExpectations(timeout: 3, handler: nil)
    }

    func testChangePIN_callsShowAndHideActivityIndicator() {
        let expectation = self.expectation(description: "ActivityIndicatorExpectation")
        accountVM.activityIndicator.showActivityIndicator()
        accountVM.changePIN(oldPin: "oldPin", newPin: "newPin")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertTrue(self.onHideCalled)
            expectation.fulfill()
        }
//        waitForExpectations(timeout: 3, handler: nil)
    }
}
