
import UIKit
import Backendless

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let HOST_URL = "https://api.backendless.com"
    private let APP_ID = "2572F312-6EB9-CA21-FF89-15662D181F00"
    private let API_KEY = "DDE11615-EDD9-430F-A47B-F027DA265AEA"
    
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
