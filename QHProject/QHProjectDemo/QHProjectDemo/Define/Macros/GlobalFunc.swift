//
//  GlobalFunc.swift
//  全局通用方法
//
//  Created by 罗坤 on 2021/6/29.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// 调整路由
let Router = SpiderRouter.shared

/// 设置购物车数量
func setShopBagNumber(number: Int) {
    guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    appDelegate.tabBarController?.shopBagNumber(number: number)
}

/// 国际化字符串转换
///
/// - Parameter key: 要转换的键
/// - Returns: 转换后的字符串
func localizedString(_ key: String) -> String {
    return LocalizationMannager.share.localizedForKey(key)
}

