import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window              : UIWindow?
    var navigationController: UINavigationController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool{
        let viewController: HomeViewController = HomeViewController()
        navigationController                   = UINavigationController(rootViewController: viewController)
        self.window                            = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController        = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }
}

