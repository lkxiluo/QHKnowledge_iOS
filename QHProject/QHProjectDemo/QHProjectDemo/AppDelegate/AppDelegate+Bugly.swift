//
//  AppDelegate+Bugly.swift
//  Bugly 异常上报配置
//
//  Created by 罗坤 on 2021/11/4.
//

import Foundation
import UIKit
import Bugly

fileprivate let buglyCrashReporterInfoKey = Notification.Name("buglyCrashReporterInfo")
// MARK: - Bugly
extension AppDelegate: BuglyDelegate {
    func setupBugly() {
        let buglyConfig = BuglyConfig()
        buglyConfig.blockMonitorEnable = true
        buglyConfig.reportLogLevel = .warn
        buglyConfig.blockMonitorTimeout = 5
        buglyConfig.delegate = self
        #if DEBUG
        Bugly.start(withAppId: VendorKey.buglyAppId, developmentDevice: true, config: buglyConfig)
        #else
        Bugly.start(withAppId: VendorKey.buglyAppId, config: buglyConfig)
        #endif
        BuglyLog.initLogger(BuglyLogLevel.error, consolePrint: true)
        
        addBuglyNotification()
    }
    
    private func addBuglyNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reportBulgyError(notify:)),
                                               name: buglyCrashReporterInfoKey,
                                               object: nil)
    }
    
    @objc private func reportBulgyError(notify: Notification) {
        let name = notify.object
        let crashVC = UIViewController.current()
        let crashInfo = String(describing: crashVC.self)
        let exception: NSException = NSException(name: NSExceptionName(rawValue: "crashError"),
                                                 reason: name as? String ?? "",
                                                 userInfo: ["pageInfo": crashInfo])
        Bugly.report(exception)
    }
    
    // MARK: - BuglyDelegate
    func attachment(for exception: NSException?) -> String? {
        DLog("\(NSString.init(utf8String: #file)?.lastPathComponent ?? ""): \(#line) \(#function) \(String(describing: exception))")
        let crashVC = UIViewController.current()
        return String(describing: crashVC.self)
    }
}
