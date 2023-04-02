//
//  SharedMethodsTests.swift
//  GuardianUnitTests
//
//  Created by Siyu Yao on 02/04/2023.
//

import XCTest
@testable import Guardian

final class SharedMethodsTests: XCTestCase {
    
    func testJsonToDictionary() {
        // Given
        let jsonString = "{\"key1\": \"value1\", \"key2\": \"value2\"}"
        let sharedMethods = SharedMethods()
        let expectedDictionary: [String: Any] = ["key1": "value1", "key2": "value2"]
        
        // When
        guard let resultDictionary = sharedMethods.jsonToDictionary(from: jsonString) else {
            XCTFail("Failed to convert JSON string to dictionary")
            return
        }
        
        // Then
        XCTAssertEqual(resultDictionary["key1"] as? String, expectedDictionary["key1"] as? String)
        XCTAssertEqual(resultDictionary["key2"] as? String, expectedDictionary["key2"] as? String)
    }
    
    func testDateToStringConverter() {
        // Given
        let date = Date(timeIntervalSince1970: 1680300000) // 2023-04-01 21:46:40 UTC

        // Convert the date to the local time zone
        let localTimeZone = TimeZone.current
        let localOffset = TimeInterval(localTimeZone.secondsFromGMT(for: date))
        let localDate = date.addingTimeInterval(localOffset)
        
        // Format the local date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US")
        let expectedDateString = dateFormatter.string(from: localDate)

        // When
        let resultDateString = SharedMethods.dateToStringConverter(date: date)

        // Then
        XCTAssertEqual(resultDateString, expectedDateString)
    }




}
