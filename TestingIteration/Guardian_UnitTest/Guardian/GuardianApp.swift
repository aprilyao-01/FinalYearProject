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
    @StateObject var sessionService = SessionServiceImpl(authSignOut: FirebaseAuthWrapper())
    var body: some Scene {
        WindowGroup {
            NavigationView{
//                Contacts(contactVM: ContactVM())
                switch sessionService.state {
                case .loggedIn:
                    TabBar()
                        .environmentObject(sessionService)
                        .navigationBarHidden(true)
                case .loggedOut:
                    FirstPage()
                        .navigationBarHidden(true)
                }
//                FirstPage()
//                    .navigationBarHidden(true)
            }
        }
    }
}

// MARK: Initialising Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }

    // MARK: Phone Auth needs to intialise remote notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        return .noData
    }
}
