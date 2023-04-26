//
//  MapVM.swift
//  Guardian
//
//  Created by Siyu Yao on 16/01/2023.
//

import MapKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

enum Report: Int, CaseIterable {
    case Unsafe = 0
    case PoorLight = 1
    case Restricted = 2
    case Missing = 3
    
    var name: String{
        get{
            switch self{
            case .Unsafe:
                return "Unsafe"
            case .PoorLight:
                return "Poor Light"
            case .Restricted:
                return "Restricted"
            case .Missing:
                return "Missing"
            }
        }
    }
    
    var pinImage: String{
        get{
            switch self{
            case .Unsafe:
                return "xmark.shield.fill"
            case .PoorLight:
                return "lightbulb.fill"
            case .Restricted:
                return "hand.raised.slash.fill"
            case .Missing:
                return "person.fill.questionmark.rtl"
            }
        }
    }
}

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 52.952082, longitude: -1.185445)
    static let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
}

enum GenderType {
    case male
    case female
    
    var name: String{
        get{
            switch self{
            case .male:
                return "Male"
            case .female:
                return "Female"
            }
        }
        
    }
}


struct Place: Identifiable {
      let id = UUID()
      let name: String
      let coordinate: CLLocationCoordinate2D
}


final class MapVM: NSObject, ObservableObject, CLLocationManagerDelegate {
        
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation,span: MapDetails.span)
    
    
    @Published var annotations : [MKPointAnnotation] = []
    @Published var userLocation: CLLocation? = CLLocation(latitude: 52.952082, longitude: -1.185445)
    @Published var fetchedReportedItemList: [ReportItem]
    
    private var hasSetRegion = false
//    let activityIndicator = ActivityIndicator()
    @Published var missingPersonImage: UIImage?
    @Published var selectedReportType: Report
    
    // MARK: modified protocols for testing
    var locationManager: LocationManagerProtocol?
    let ref: DatabaseReferenceProtocol
    private let authHandler: AuthHandler
    private let activityIndicator: ActivityIndicatorProtocol = ActivityIndicatorWrapper(activityIndicator: UIActivityIndicatorView())

    
    init(databaseReference: DatabaseReferenceProtocol = DatabaseReferenceWrapper(Database.database().reference()), authHandler: AuthHandler = FirebaseAuthWrapper()) {
        self.ref = databaseReference
        self.selectedReportType = .Unsafe
        self.fetchedReportedItemList = []
        self.authHandler = authHandler
        super.init()
        self.checkLocationServicesisEnable()
        self.fetchReportedItems(completion: {})
    }


    
    func reloadCurrentLocation(){
        region = MKCoordinateRegion(center: userLocation?.coordinate ?? MapDetails.startingLocation,
                                         span: MapDetails.span)
    }
    
    func checkLocationServicesisEnable() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self        // set and call the delegate
            
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.distanceFilter = kCLDistanceFilterNone
            locationManager!.startUpdatingLocation()
            
            // request current location
            DispatchQueue.main.async {
                self.locationManager!.requestLocation()
           }
        } else {
            // TODO: alart show error and let trun on
            print("show alart let user know this is off and to go turn it on")
        }
    }
    
    // MARK: check current location auth and handle each
    private func checkLocationAuthorisation(){
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            SharedMethods().showSettingsAlertController(title: "Error", message: "Your location is restricted",onVC: UIApplication.topViewController())
            print("Your location is restricted")
        case .denied:
            SharedMethods().showSettingsAlertController(title: "Error", message: "You have denied this app location permision. Go into settings to change.",onVC: UIApplication.topViewController())
            print("You have denied this app location permisiion. Go into settings to changt.")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location?.coordinate ?? MapDetails.startingLocation,
                                        span: MapDetails.span)
        @unknown default:
            fatalError("Unexpected CLLocationManager.authorizationStatus() value")
        }
    }
    
    // whenever authorisation changed, run check again
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorisation()
    }
    
    // required delegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.userLocation = location

            if annotations.isEmpty {
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
    
    // required delegate method
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("MapVM: locationManager error: %s", error)
    }
    
    
    func addReportItem(reportType:Int,locLong: Double,locLat: Double,missingPersonGender: String = "", missingPersonName: String = "", missingPersonAge: String = "", missingPersonWornCloths: String = "", missingPersonImage: String = "", completion: @escaping () -> Void) {
        DispatchQueue.main.async{
            self.activityIndicator.showActivityIndicator()
        }
        let repTime = SharedMethods.dateToStringConverter(date: Date())
        var isReportDataUpdated: Bool = false
//        let currentUID = Auth.auth().currentUser!.uid
        
        var currentUID : String
        if authHandler.currentUser == nil {
            currentUID = "test"
        } else {
            currentUID = authHandler.currentUser!.uid
        }
            
        do{
            for item in fetchedReportedItemList{
                let distanceInMeters = CLLocation(latitude: locLat, longitude: locLong).distance(from: CLLocation(latitude: item.locLatitude, longitude: item.locLongitude))

                if((distanceInMeters < REPORT_LOCATION_MAX_RADIUS) && (item.reportType == reportType)){ //check whether this location inside a given radius was previously reported
                    if(!(item.reportingConfirmedByUsers.contains(currentUID) || item.reportedBy.contains(currentUID))){ //update the record to update confirmed by user
                        item.reportingConfirmedByUsers.append(currentUID)
                        let jsonData = try JSONEncoder().encode(item)
                        let jsonString = String(data: jsonData, encoding: .utf8)!
                        ref.child("report_data").child(item.id).setValue(SharedMethods().jsonToDictionary(from: jsonString),withCompletionBlock: { error,result in
                            if error == nil{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                    self.activityIndicator.hideActivityIndicator()
                                }
                            }else{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                    self.activityIndicator.hideActivityIndicator()
                                    SharedMethods.showMessage("Error", message: error?.localizedDescription, onVC: UIApplication.topViewController())
                                }
                            }
                            
                            completion() // Call the completion closure
                        })
                    }else{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                            self.activityIndicator.hideActivityIndicator()
                            SharedMethods.showMessage("Message", message: "This location is already reported by you.", onVC: UIApplication.topViewController())
                        }
                    }
                    isReportDataUpdated = true
                    break
                }
            }

            if(!isReportDataUpdated){   //insert as a new record
                let reportItem = ReportItem(reportType: reportType, locLongitude: locLong, locLatitude: locLat, reportedTime: repTime, reportedBy: currentUID, deleteRequestedBy: [], missingPersonGender: missingPersonGender, missingPersonName: missingPersonName, missingPersonAge: missingPersonAge, missingPersonWornCloths: missingPersonWornCloths, missingPersonImage: missingPersonImage, reportingConfirmedByUsers: [])

                //This block of code used to convert object models to json string
                let jsonData = try JSONEncoder().encode(reportItem)
                let jsonString = String(data: jsonData, encoding: .utf8)!
                ref.child("report_data").child(reportItem.id).setValue(SharedMethods().jsonToDictionary(from: jsonString),withCompletionBlock: { error,result in
                    if error == nil{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                            self.activityIndicator.hideActivityIndicator()
                        }
                    }else{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                            self.activityIndicator.hideActivityIndicator()
                            SharedMethods.showMessage("Error", message: error?.localizedDescription, onVC: UIApplication.topViewController())
                        }
                    }
                    
                    completion() // Call the completion closure
                })
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    self.activityIndicator.hideActivityIndicator()
                }
            }

        }catch{

        }

    }
    
    func deleteReportItem(reportItem:ReportItem, completion: @escaping () -> Void) {
        DispatchQueue.main.async{
            self.activityIndicator.showActivityIndicator()
        }
//        let currentUID = Auth.auth().currentUser!.uid
        var currentUID : String
        if authHandler.currentUser == nil {
            currentUID = "test"
        } else {
            currentUID = authHandler.currentUser!.uid
        }
        
        if(reportItem.reportedBy == currentUID){
            ref.child("report_data").child(reportItem.id).removeValue(completionBlock: { error, result in   //delete report if it is created by current user
                DispatchQueue.main.async{
                    self.activityIndicator.hideActivityIndicator()
                }
                if error != nil{
                    SharedMethods.showMessage("Error", message: error?.localizedDescription, onVC: UIApplication.topViewController())
                }
                completion() // Call the completion closure
            })
        }else{
            if(reportItem.deleteRequestedBy.count == (REPORT_MODIFY_MAX_USER_COUNT - 1)){
                if(reportItem.deleteRequestedBy.contains(currentUID)){
                    DispatchQueue.main.async{
                        self.activityIndicator.hideActivityIndicator()
                    }
                    SharedMethods.showMessage("Message", message: "You have already requested to remove this item.", onVC: UIApplication.topViewController())
                }else{
                    ref.child("report_data").child(reportItem.id).removeValue(completionBlock: { error, result in   //delete report if it is requested by REPORT_MODIFY_MAX_USER_COUNT
                        DispatchQueue.main.async{
                            self.activityIndicator.hideActivityIndicator()
                        }
                        if error != nil{
                            SharedMethods.showMessage("Error", message: error?.localizedDescription, onVC: UIApplication.topViewController())
                        }
                        completion() // Call the completion closure
                    })
                }
            }else{
                reportItem.deleteRequestedBy = [currentUID]
                do{
                    let jsonData = try JSONEncoder().encode(reportItem)
                    let jsonString = String(data: jsonData, encoding: .utf8)!
                    
                    //updating report item's delete requested by field to current user
                    ref.child("report_data").child(reportItem.id).setValue(SharedMethods().jsonToDictionary(from: jsonString)) {
                        (error: Error?, databaseReferenceProtocol: DatabaseReferenceProtocol) in
                        DispatchQueue.main.async{
                            self.activityIndicator.hideActivityIndicator()
                        }
                      if let error = error {
                          SharedMethods.showMessage("Error", message: error.localizedDescription, onVC: UIApplication.topViewController())
                      } else {
                          SharedMethods.showMessage("Message", message: "Your request to delete this item has been added.", onVC: UIApplication.topViewController())

                      }
                        completion() // Call the completion closure
                    }
                }catch{
                    DispatchQueue.main.async{
                        self.activityIndicator.hideActivityIndicator()
                    }
                }

            }
        }
        
    }
    
    func fetchReportedItems(completion: @escaping () -> Void) {
        DispatchQueue.main.async{
            self.activityIndicator.showActivityIndicator()
        }
        _ = ref.child("report_data").observe(DataEventType.value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            
            let reportDataList = value?.allValues
            do {
                let json = try JSONSerialization.data(withJSONObject: reportDataList ?? [])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedReportItems = try decoder.decode([ReportItem].self, from: json)
                self.fetchedReportedItemList = decodedReportItems
                
                print(self.fetchedReportedItemList)
                DispatchQueue.main.async{
                    self.activityIndicator.hideActivityIndicator()
                }
            } catch {
                print("MapVM: cannot fetch report data\n %s", error)
            }
            
            completion() // Call the completion closure
        })
        
    }
    
    
    
    
}
