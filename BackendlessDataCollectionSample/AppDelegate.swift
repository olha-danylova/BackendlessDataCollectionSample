
import UIKit
import Backendless

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func initBackendless() {
        Backendless.shared.hostUrl = "https://api.backendless.com"
        Backendless.shared.initApp(applicationId: "YOUR APPLICATION ID", apiKey: "YOUR IOS API KEY")
        return
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initBackendless()
        return true
    }
}
