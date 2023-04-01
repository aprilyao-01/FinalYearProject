//
//  MapTests.swift
//  GuardianUnitTests
//
//  Created by Siyu Yao on 01/04/2023.
//

import XCTest
@testable import Guardian
import CoreLocation

class MockLocationManager: LocationManagerProtocol {
    weak var delegate: CLLocationManagerDelegate?
    var location: CLLocation?
    var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest
    var distanceFilter: CLLocationDistance = kCLDistanceFilterNone
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    func requestWhenInUseAuthorization() {}
    func requestLocation() {}
    func startUpdatingLocation() {}
}

final class MapVMTests: XCTestCase {
    var mapViewModel: MapVM!
    var mockLocationManager: MockLocationManager!

    // MARK: setUP
    override func setUp() {
        super.setUp()
        mockLocationManager = MockLocationManager()
        mapViewModel = MapVM()
        mapViewModel.locationManager = mockLocationManager
    }

    // MARK: tearDown
    override func tearDown() {
        mapViewModel = nil
        mockLocationManager = nil
        super.tearDown()
    }

    func testReloadCurrentLocation() {
        // Given
        let locationManager = MockLocationManager()
        let mapViewModel = MapVM()
        mapViewModel.locationManager = locationManager

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

}

