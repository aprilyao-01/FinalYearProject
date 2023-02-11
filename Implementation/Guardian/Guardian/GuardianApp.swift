//
//  GuardianApp.swift
//  Guardian
//
//  Created by Siyu Yao on 04/12/2022.
//

import SwiftUI
import Firebase

@main
struct GuardianApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // MARK: propotie handle login logout
    @StateObject var sessionService = SessionServiceImpl()
    var body: some Scene {
        WindowGroup {
            NavigationView{
                MapView()
//                switch sessionService.state {
//                case .loggedIn:
//                    Home().environmentObject(sessionService)
//                case .loggedOut:
//                    FirstPage()
//                }
//                FirstPage()
//                    .navigationBarHidden(true)
//                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

// MARK: Initialising Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }

    // MARK: Phone Auth needs to intialise remote notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        return .noData
    }
}
