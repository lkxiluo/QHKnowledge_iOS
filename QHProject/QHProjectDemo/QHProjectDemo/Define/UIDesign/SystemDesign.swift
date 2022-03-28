//
//  SystemStyle.swift
//  系统设计规范
//
//  Created by 罗坤 on 2021/6/28.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

/// 系统设计规范
struct SystemDesign {
    /// 是否是刘海屏
    static let isIphoneX = Config.Device.isIphneXSeries
    /// 屏幕宽度
    static let screenWidth: CGFloat = Config.Screen.width
    /// 屏幕高度
    static let screenHeight: CGFloat = Config.Screen.height
    /// 刘海屏顶部安全高度(状态栏高度)
    static let iPhoneXTopHeight: CGFloat = Config.Screen.safeAreaTopMargin
    /// 刘海屏底部安全高度
    static let iPhoneXBottomHeihgt: CGFloat = Config.Screen.safeAreaBottomMargin
    /// 导航栏高度
    static let navigationBarHeight: CGFloat = iPhoneXTopHeight + 44.0
    /// 状态栏高度
    static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
}

