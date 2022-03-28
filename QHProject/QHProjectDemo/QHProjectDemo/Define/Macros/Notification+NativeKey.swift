//
//  Notification+NativeKey.swift
//  自定义通知 key
//
//  Created by 罗坤 on 2021/6/28.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

extension Notification.Name {
    /// token失效
    static let tokenLoseEfficacyNotification = Notification.Name("tokenLoseEfficacyNotification")
    /// 登录成功通知
    static let loginSuccessNotification = Notification.Name("loginSuccessNotification")
    /// 登出
    static let logoutNotification = Notification.Name("logoutNotification")
    /// 微信登录回调
    static let wechatLoginCallback = Notification.Name("notificationNameWechatLoginCallback")
    
    /// 授权
    static let locationNotificationName = Notification.Name("locationNotificationName")
    static let pushNotificationName = Notification.Name("pushNotificationName")
}
