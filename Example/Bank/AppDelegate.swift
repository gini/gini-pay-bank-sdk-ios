//
//  AppDelegate.swift
//  Bank
//
//  Created by Nadya Karaban on 30.04.21.
//

import GiniPayApiLib
import GiniPayBank
import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var paymentRequestId: String = ""
    let apiLib = GiniApiLib.Builder(client: Client(id: "gini-mobile-test", secret: "wT4o4kXPAYtDknnOYwWf4w5s", domain: "gini.net")).build()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let paymentViewController = PaymentViewController.instantiate(with: apiLib)

        let navigationController = UINavigationController(rootViewController: paymentViewController)
        window?.rootViewController = navigationController

        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        receivePaymentRequestId(url: url) { result in
            switch result {
            case let .success(requestId):
                self.paymentRequestId = requestId
            case .failure:
                break
            }
        }
        return true
    }
}
