//
//  ContactTests.swift
//  GuardianUnitTests
//
//  Created by Siyu Yao on 01/04/2023.
//

import XCTest


@testable import Guardian

import FirebaseAuth
import FirebaseDatabase
import Firebase

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
        FirebaseApp.configure()
    
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
        
        mockAuthHandler.mockCurrentUser = MockUser(uid: "9hGl3bIr1pcU4wVfzdhskL8HZ5M2")
        sut.authHandler = mockAuthHandler
        
        let mockContact = EmergencyContact(id:  "EA840A91-9C32-41C2-AF5C-8F7B5AFF0C45" , contactName: "Kate Bell", isEmergencyContact: false,   phoneNo: "(555) 564-8583", profileImage: "")
        
        sut.selectedContacts = [mockContact]
        

        sut.addContact { status in
            XCTAssertTrue(status)
            addContactExpectation.fulfill()
        }
        
        wait(for: [addContactExpectation], timeout: 25.0)

        
    }

    func testFetchContact(){
        let fetchContactExpectation = expectation(description: "fetchContact")

        mockAuthHandler.mockCurrentUser = MockUser(uid: "9hGl3bIr1pcU4wVfzdhskL8HZ5M2")
        sut.authHandler = mockAuthHandler
        sut.fetchContact(){ status in
            XCTAssertEqual(self.sut.fetchedContactList.count, 2)
            let product = self.sut.fetchedContactList.first!
            XCTAssertEqual(product.id, "8DE56025-E8A1-4F65-9A3D-E872454BDF93")
            XCTAssertEqual(product.contactName , "John Appleseed")
            fetchContactExpectation.fulfill()
            
        }
        wait(for: [fetchContactExpectation], timeout: 15.0)

       // XCTAssertTrue(mockDatabaseReference.calledStatus["observe"] ?? false)
    }

    func testDeleteContact() {
        let deleteContactExpectation = expectation(description: "Delete contact")
        
        mockAuthHandler.mockCurrentUser = MockUser(uid: "9hGl3bIr1pcU4wVfzdhskL8HZ5M2")
        sut.authHandler = mockAuthHandler

        let mockContact = EmergencyContact(id:  "EA840A91-9C32-41C2-AF5C-8F7B5AFF0C45" , contactName: "Kate Bell", isEmergencyContact: false,   phoneNo: "(555) 564-8583", profileImage: "")
        sut.deleteContact(item: mockContact) { status in
            XCTAssertTrue(status)
            deleteContactExpectation.fulfill()
        }
        wait(for: [deleteContactExpectation], timeout: 20.0)
    }

    func testUpdateContact() {
        let updateContactExpectation = expectation(description: "Update contact")
        mockAuthHandler.mockCurrentUser = MockUser(uid: "9hGl3bIr1pcU4wVfzdhskL8HZ5M2")
        sut.authHandler = mockAuthHandler

        
        let mockContact = EmergencyContact(id:  "EA840A91-9C32-41C2-AF5C-8F7B5AFF0C45" , contactName: "Abdul Moiz", isEmergencyContact: false,   phoneNo: "(555) 564-8583", profileImage: "")

        sut.updateContact(item: mockContact) { status in
            XCTAssertTrue(status)
            updateContactExpectation.fulfill()
        }

        wait(for: [updateContactExpectation], timeout: 20.0)
    }
 
      func testUpdateContactFailure() {
        let updateContactExpectation = expectation(description: "Update contact")
        mockAuthHandler.mockCurrentUser = MockUser(uid: "12245uywe")
        sut.authHandler = mockAuthHandler


        let mockContact = EmergencyContact(id:  "test" , contactName: "Abdul Moiz", isEmergencyContact: false,   phoneNo: "(555) 564-8583", profileImage: "")

        sut.updateContact(item: mockContact) { status in
             XCTAssertFalse(status)
            updateContactExpectation.fulfill()
        }

        wait(for: [updateContactExpectation], timeout: 20.0)
    }
}
