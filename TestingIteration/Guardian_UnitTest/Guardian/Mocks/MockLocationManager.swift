//
//  MockLocationManager.swift
//  Guardian
//
//  Created by Siyu Yao on 02/04/2023.
//

import Foundation
import CoreLocation

/// protocol to isolate and control location manager for testing related to MapVM()
protocol LocationManagerProtocol: AnyObject {
    var delegate: CLLocationManagerDelegate? { get set }
    var location: CLLocation? { get }
    var desiredAccuracy: CLLocationAccuracy { get set }
    var distanceFilter: CLLocationDistance { get set }
    var authorizationStatus: CLAuthorizationStatus { get }
    
    func requestWhenInUseAuthorization()
    func requestLocation()
    func startUpdatingLocation()
}

/// mock class to isolate and control location manager for testing related to MapVM()
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

extension CLLocationManager: LocationManagerProtocol {
    var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
}
