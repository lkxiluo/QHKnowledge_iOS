//
//  AppDelegate.swift
//  QHProjectDemo
//
//  Created by 罗坤 on 2021/10/26.
//

import UIKit
import Toast_Swift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var tabBarController: TabbarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        launchConfig()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        DLog("\(url) +++++ \(options)")
        
        return false
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

extension AppDelegate {
    /// 启动配置
    func launchConfig() {
        vendorsInstance()
        windowInstance()
        Router.configScheme(scheme: RouterConfig.scheme,
                              jumpHost: RouterConfig.jumpHost,
                              eventHost: RouterConfig.eventHost)
    }
    
    func windowInstance() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        rootViewControllerWithTabbarController()
    }
    
    /// 设置根 VC
    func rootViewControllerWithTabbarController() {
        tabBarController = TabbarController()
        window?.rootViewController = tabBarController
        tabBarController?.selectedIndex = 0
    }
}
