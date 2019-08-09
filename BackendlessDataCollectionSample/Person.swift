
import Foundation
import Backendless

@objcMembers class Person: NSObject, Identifiable {
    
    var objectId: String?
    var name: String?
    var age: Int = 0
}
