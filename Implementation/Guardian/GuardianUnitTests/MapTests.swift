//
//  MapTests.swift
//  GuardianUnitTests
//
//  Created by Siyu Yao on 01/04/2023.
//

import XCTest
import CoreLocation

@testable import Guardian

final class MapVMTests: XCTestCase {
    var mapViewModel: MapVM!
    var mockLocationManager: MockLocationManager!
    var mockDatabaseReference: MockDatabaseReference!
    var mockAuthHandler: MockAuthHandler!
    var reportItem: ReportItem!

    // MARK: setUP
    override func setUp() {
        super.setUp()
        mockLocationManager = MockLocationManager()
        mockDatabaseReference = MockDatabaseReference()
        mockAuthHandler = MockAuthHandler()
        mapViewModel = MapVM(databaseReference: mockDatabaseReference)
        mapViewModel.locationManager = mockLocationManager
        
        reportItem = ReportItem(
            id: UUID().uuidString,
            reportType: 1,
            locLongitude: 10.0,
            locLatitude: 20.0,
            reportedTime: "2023-04-01",
            reportedBy: "testUser",
            deleteRequestedBy: [],
            // though not used in type==1
            missingPersonGender: "Male",
            missingPersonName: "John Doe",
            missingPersonAge: "30",
            missingPersonWornCloths: "Blue shirt, jeans",
            missingPersonImage: "image_url",
            reportingConfirmedByUsers: []
        )
    }

    // MARK: tearDown
    override func tearDown() {
        mapViewModel = nil
        mockAuthHandler = nil
        mockDatabaseReference = nil
        mockLocationManager = nil
        reportItem = nil
        super.tearDown()
    }

    func testReloadCurrentLocation() {
        // Given
        let mockLocation = CLLocation(latitude: 52.951082, longitude: -1.184445) // Some different location
        mapViewModel.userLocation = mockLocation
        
        // When
        let initialRegion = mapViewModel.region
        mapViewModel.reloadCurrentLocation()
        
        // Then
        XCTAssertEqual(mapViewModel.region.center.latitude, mockLocation.coordinate.latitude, accuracy: 0.0001)
        XCTAssertEqual(mapViewModel.region.center.longitude, mockLocation.coordinate.longitude, accuracy: 0.0001)
        XCTAssertNotEqual(initialRegion.center.latitude, mapViewModel.region.center.latitude)
        XCTAssertNotEqual(initialRegion.center.longitude, mapViewModel.region.center.longitude)
    }


    func testCheckLocationServicesIsEnable() {
        // When
        mapViewModel.checkLocationServicesisEnable()
        
        // Then
        XCTAssertNotNil(mapViewModel.locationManager)
        XCTAssertNotNil(mapViewModel.locationManager?.delegate)
    }
    
    func testAddReportItem() {
        // Given
        let childMockDatabaseReference = mockDatabaseReference.child("report_data")
        
        // When
        mapViewModel.addReportItem(reportType: reportItem.reportType, locLong: reportItem.locLongitude, locLat: reportItem.locLatitude, completion: {})
        
       // Then
        XCTAssertEqual(childMockDatabaseReference.key, "report_data", "The key path should be equal to 'report_data'")
        XCTAssertTrue(mockDatabaseReference.calledStatus["setValue"] ?? false, "setValue should be called")
    }

    func testDeleteReportItem() {
        // Given
        let childMockDatabaseReference = mockDatabaseReference.child("report_data").child(reportItem.id)
        let reportItemKeyPath = "report_data/\(reportItem.id)"
        
        // When
        mapViewModel.deleteReportItem(reportItem: reportItem, completion: {})
        
       // Then
        XCTAssertEqual(childMockDatabaseReference.key, reportItemKeyPath, "The key path should be equal to 'report_data/<item_id>'")
        XCTAssertTrue(mockDatabaseReference.calledStatus["removeValue"] ?? false, "removeValue should be called")

    }

    func testFetchReportedItems() {
        // Given
        let childMockDatabaseReference = mockDatabaseReference.child("report_data")
        
        // When
        mapViewModel.fetchReportedItems(completion: {})
        
        // Then
        XCTAssertEqual(childMockDatabaseReference.key, "report_data", "The key path should be equal to 'report_data'")
        XCTAssertTrue(mockDatabaseReference.calledStatus["observe"] ?? false, "observe should be called")
    }
}

