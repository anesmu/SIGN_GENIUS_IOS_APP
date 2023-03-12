//
//  SIGN_GENIUSApp.swift
//  SIGN_GENIUS
//
//  Created by Antonio Espino Muñoz on 12/3/23.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct SIGN_GENIUSApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var dataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
