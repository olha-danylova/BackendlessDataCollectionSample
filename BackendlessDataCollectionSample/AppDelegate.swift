
import UIKit
import Backendless

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let HOST_URL = "https://api.backendless.com"
    private let APP_ID = "YOUR_APP_ID"
    private let API_KEY = "YOUR_APP_IOS_API_KEY"
    
    func initBackendless() {
        Backendless.shared.hostUrl = HOST_URL
        Backendless.shared.initApp(applicationId: APP_ID, apiKey: API_KEY)
        return
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initBackendless()
        return true
    }
}
