import SwiftUI
import FirebaseCore
import FirebaseCrashlytics


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    Crashlytics.crashlytics()
    return true
  }
}

@main
struct SignGeniusApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            SplashView(state: AppState())
                .preferredColorScheme(.light)
        }
    }
}
