//
//  CurrencyManager.swift
//  币种管理
//
//  Created by 罗坤 on 2021/7/15.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// 币种管理
struct CurrencyManager {
    /// 币种符号
    private static var currencySymbol: String {
        // 根据需求写逻辑
        return "¥"
    }
    private static let numberFormatter = NumberFormatter()
    /// 价格会计计算法，每三位一个逗号隔开，保留两位有效小数
    /// - Parameters:
    ///   - moneyString: 价格字符串
    ///   - isShowSymbol: 是否显示单位
    /// - Returns: 价格值
    static func accountingMoneyValue(moneyString: String?, isShowSymbol: Bool = true) -> String {
        guard let moneyString = moneyString, !moneyString.isEmpty else {
            return currencySymbol + "0.0"
        }
        
        guard let dNum = Double(moneyString) else {
            return currencySymbol + "0.0"
        }
        numberFormatter.positiveFormat = "###,##0.00"
        numberFormatter.negativeFormat = "-#,##0.00"
        guard let result = numberFormatter.string(from: NSNumber(value: dNum)) else {
            return currencySymbol + "0.0"
        }
        
        return isShowSymbol ? currencySymbol + result : result
    }
}
