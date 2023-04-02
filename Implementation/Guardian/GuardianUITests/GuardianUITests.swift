//
//  GuardianUITests.swift
//  GuardianUITests
//
//  Created by Siyu Yao on 02/04/2023.
//

import XCTest

class SharedMethodsUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testShowMessage() {
        // Replace "yourButtonIdentifier" with the accessibility identifier of a button or UI element in your app that triggers the showMessage function
        let button = app.buttons["yourButtonIdentifier"]
        button.tap()
        
        let alert = app.alerts["Message"]
        XCTAssert(alert.exists)
        
        let okButton = alert.buttons["OK"]
        XCTAssert(okButton.exists)
        
        okButton.tap()
        XCTAssert(alert.waitForExistence(timeout: 1) == false)
    }

    // Similarly, create UI tests for other functions like showMessageWithOKActionBtn, showMessageWith2Buttons, and showSettingsAlertController
}
