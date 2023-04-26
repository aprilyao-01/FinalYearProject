//
//  HomeTests.swift
//  GuardianUnitTests
//
//  Created by Siyu Yao on 01/04/2023.
//

import XCTest
import CoreLocation

@testable import Guardian


final class HomeTests: XCTestCase {
    
    var sut: HomeVM!
    
    override func setUp() {
        super.setUp()
        sut = HomeVM()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testGetHelpButtonTapped() {
        let initialShowAlertCancelView = sut.showAlertCancelView
        let initialAlertCancelationViewType = sut.alertCancelationViewType
        
        sut.getHelpButtonTapped()
        
        XCTAssertFalse(sut.showAlertCancelView != initialShowAlertCancelView, "showAlertCancelView should be toggled")
        XCTAssertEqual(sut.alertCancelationViewType, .alertCancelationView, "alertCancelationViewType should be set to .alertCancelationView")
    }
    
    
    
    
    
    
    
    
    func testCancelTimerWithValidPIN() {
        sut.remainingRetryCount = 3
        sut.showAlertCancelView = true
        let userEnteredPIN = "1234"
        let actualPIN = "1234"
        
        sut.cancelTimer(userEnteredPIN: userEnteredPIN, actualPIN: actualPIN)
        
        XCTAssertFalse(sut.showAlertCancelView, "showAlertCancelView should be false after cancelTimer(userEnteredPIN:actualPIN:) is called with valid PIN")
    }
    
    
    
    func testCancelTimerWithInvalidPIN() {
        sut.remainingRetryCount = 3
        sut.showAlertCancelView = true
        let userEnteredPIN = "1234"
        let actualPIN = "5678"
        
        sut.cancelTimer(userEnteredPIN: userEnteredPIN, actualPIN: actualPIN)
        
        XCTAssertTrue(sut.showAlertCancelView, "showAlertCancelView should still be true after cancelTimer(userEnteredPIN:actualPIN:) is called with invalid PIN")
        XCTAssertEqual(sut.remainingRetryCount, 2, "remainingRetryCount should decrement by 1 after cancelTimer(userEnteredPIN:actualPIN:) is called with invalid PIN")
    }
    
    
    
    
    func testCancelButtonActionWithValidPIN() {
        let initialRemainingRetryCount = sut.remainingRetryCount
        let initialShowAlertCancelView = sut.showAlertCancelView
        let validUserEnteredPIN = "1234"
        let validActualPIN = "1234"
        
        sut.cancelTimer(userEnteredPIN: validUserEnteredPIN, actualPIN: validActualPIN)
        
        XCTAssertEqual(sut.remainingRetryCount, initialRemainingRetryCount, "remainingRetryCount should not change")
        XCTAssertTrue(sut.showAlertCancelView != initialShowAlertCancelView, "showAlertCancelView should be toggled")
    }
    
    func testCancelButtonActionWithInvalidPIN() {
        let initialRemainingRetryCount = sut.remainingRetryCount
        let initialShowAlertCancelView = sut.showAlertCancelView
        let invalidUserEnteredPIN = "1111"
        let validActualPIN = "1234"
        
        sut.cancelTimer(userEnteredPIN: invalidUserEnteredPIN, actualPIN: validActualPIN)
        
        XCTAssertLessThan(sut.remainingRetryCount, initialRemainingRetryCount, "remainingRetryCount should decrease")
        XCTAssertEqual(sut.alertCancelationViewType, .alertCancelationView, "alertCancelationViewType should remain as .alertCancelationView")
        XCTAssertFalse(sut.showAlertCancelView != initialShowAlertCancelView,"showAlertCancelView should be toggled")
    }
}
  




