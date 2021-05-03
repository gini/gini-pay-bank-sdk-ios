//
//  AppDelegate.swift
//  Bank
//
//  Created by Nadya Karaban on 30.04.21.
//

import UIKit
import GiniPayBank

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var paymentRequestId: String = ""

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "paymentViewController") as! PaymentViewController
                let navigationController = UINavigationController.init(rootViewController: viewController)
                self.window?.rootViewController = navigationController

                self.window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        receivePaymentRequestId(url: url) { result in
            switch result {
            case .success(let requestId):
                self.paymentRequestId = requestId
            case .failure(_):
                print("failure")
            }
        }
        return true
    }

}

