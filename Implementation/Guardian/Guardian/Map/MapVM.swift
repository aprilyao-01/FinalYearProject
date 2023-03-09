//
//  MapVM.swift
//  Guardian
//
//  Created by Siyu Yao on 16/01/2023.
//

import MapKit

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 51.505554, longitude: -0.075278)
    static let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
}

protocol MapViewModel {
    var locationManager: CLLocationManager? { get }
    var userlocation: CLLocation? { get }
    var region: MKCoordinateRegion { get }
    
    func checkLocationServicesisEnable()
    func checkLocationAuthorisation()
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
}

final class MapVM: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation,span: MapDetails.span)
    
    //MARK
    @Published var annotations : [MKPointAnnotation] = []
    @Published var userLocation: CLLocation?
    
    private var hasSetRegion = false
    
    
    func checkLocationServicesisEnable() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self        // set and call the delegate
            
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.distanceFilter = kCLDistanceFilterNone
            locationManager!.startUpdatingLocation()
            
            locationManager!.requestLocation()  // request current location
        } else {
            // TODO: alart show error and let trun on
            print("show alart let user know this is f=off and to go turn it on")
        }
    }
    
    // MARK: check current location auth and handle each
    private func checkLocationAuthorisation(){
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted")
        case .denied:
            print("You have denied this app location permisiion. Go into settings to changt.")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate,
                                        span: MapDetails.span)
        @unknown default:
            break
        }
    }
    
    // whenever authorisation changed, run check again
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorisation()
    }
    
    
    // TODO: FIX annotations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.userLocation = location
            
            if annotations.isEmpty {        // TODO:  FIX annotations
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                annotations.append(annotation)
            }
            
            if !hasSetRegion {
                self.region = MKCoordinateRegion(center: location.coordinate,
                                                 span: MapDetails.span)
                hasSetRegion = true
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("MapVM: locationManager error: %s", error)
    }
}
