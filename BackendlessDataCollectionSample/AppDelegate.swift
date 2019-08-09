
import UIKit
import Backendless

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let hostUrl = "https://api.backendless.com"
    private let appId = "" // your Application ID
    private let apiKey = "" // your iOS API key

    var window: UIWindow?
    
    func initBackendless() {
        if !appId.isEmpty, !apiKey.isEmpty {
            Backendless.shared.hostUrl = hostUrl
            Backendless.shared.initApp(applicationId: "APP ID", apiKey: "API KEY")
            return
        }
        print("Please make sure you've set the appId and apiKey properties")
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initBackendless()
        return true
    }
}
