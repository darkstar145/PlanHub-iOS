
import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    UIApplication.shared.statusBarStyle = .lightContent
    FirebaseApp.configure()
    Database.database().isPersistenceEnabled = true
    IQKeyboardManager.sharedManager().enable = true

    return true
  }

}

