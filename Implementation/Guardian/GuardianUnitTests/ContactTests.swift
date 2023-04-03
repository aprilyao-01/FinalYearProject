//
//  ContactTests.swift
//  GuardianUnitTests
//
//  Created by Siyu Yao on 01/04/2023.
//

import XCTest
//import FirebaseAuth
//import FirebaseDatabase

@testable import Guardian

final class ContactVMTests: XCTestCase {

    var sut: ContactVM!
    var mockDatabaseReference: MockDatabaseReference!
    var mockAuthHandler: MockAuthHandler!
    var mockActivityIndicator: MockActivityIndicator!
    var contact: EmergencyContact!

    override func setUp() {
        super.setUp()
        
        mockDatabaseReference = MockDatabaseReference()
        mockAuthHandler = MockAuthHandler()
        mockActivityIndicator = MockActivityIndicator(onHide: { })
        sut = ContactVM()
        contact = EmergencyContact(contactName: "John Preview", isEmergencyContact: true, phoneNo: "23455678", profileImage: "")
    }

    override func tearDown() {
        sut = nil
        mockDatabaseReference = nil
        mockAuthHandler = nil
        mockActivityIndicator = nil
        contact = nil
        super.tearDown()
    }

    func testAddContact() {
        let addContactExpectation = expectation(description: "Add contact")
        
        mockAuthHandler.mockCurrentUser = MockUser(uid: "testUser")
        
        sut.selectedContacts = [contact]
        
        mockDatabaseReference.setValueCallback = { _ in
            return .success(())
        }

        sut.addContact {
            print("mockDatabaseReference.calledStatus['setValue']:", self.mockDatabaseReference.calledStatus["setValue"] ?? "nil")
            XCTAssertTrue(self.mockDatabaseReference.calledStatus["setValue"] ?? false)
            addContactExpectation.fulfill()
        }
        
//        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchContact() {
        sut.fetchContact()
        XCTAssertTrue(mockDatabaseReference.calledStatus["observe"] ?? false)
    }

    func testDeleteContact() {
        let deleteContactExpectation = expectation(description: "Delete contact")

        sut.deleteContact(item: contact) {
            XCTAssertTrue(self.mockDatabaseReference.calledStatus["removeValue"] ?? false)
            deleteContactExpectation.fulfill()
        }

//        waitForExpectations(timeout: 5, handler: nil)
    }

    func testUpdateContact() {
        let updateContactExpectation = expectation(description: "Update contact")

        sut.updateContact(item: contact) {
            XCTAssertTrue(self.mockDatabaseReference.calledStatus["updateChildValues"] ?? false)
            updateContactExpectation.fulfill()
        }

//        waitForExpectations(timeout: 5, handler: nil)
    }
}
