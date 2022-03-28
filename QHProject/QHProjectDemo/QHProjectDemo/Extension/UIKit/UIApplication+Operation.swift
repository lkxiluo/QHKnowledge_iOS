//
//  UIApplication+Operation.swift
//  UIApplication 的相关操作
//
//  Created by 罗坤 on 2021/7/31.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    /// 跳转至手机设置页面
    static func openSetting() {
        let application = UIApplication.shared
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if application.canOpenURL(url) {
            if application.responds(to: #selector(UIApplication.open(_:options:completionHandler:))) {
                application.open(url, options: [:]) { (_) in
                }
            }
        }
    }
}
