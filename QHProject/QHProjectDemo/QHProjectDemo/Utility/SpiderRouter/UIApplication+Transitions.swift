//
//  UIApplication+Transitions.swift
//  Application 转场
//
//  Created by 罗坤 on 2021/7/10.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

extension UIApplication {
    /// 获取当前窗口
    var inWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            if let window = connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows
                .filter({ $0.isKeyWindow }).first {
                return window
            } else if let window = UIApplication.shared.delegate?.window {
                return window
            } else {
                return nil
            }
        } else {
            if let window = UIApplication.shared.delegate?.window {
                return window
            } else {
                return nil
            }
        }
    }
}
