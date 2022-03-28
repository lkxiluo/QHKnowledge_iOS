//
//  SizeStyle.swift
//  尺寸设计规范
//
//  Created by 罗坤 on 2021/4/26.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// UI 尺寸设计规范
struct SizeDesign {
    // MARK: - 布局
    /// 边距
    static let margin: CGFloat = 16.0
    static let margin12: CGFloat = 12.0
    /// 间距
    static let spacing: CGFloat = 8.0
    /// 常规圆角
    static let cornerRadius: CGFloat = 8.0
    /// 分割线高度
    static let splitLineHeight: CGFloat = 1.0 * UIScreen.main.scale / 3.0
    /// 边框宽度
    static let borderWidth: CGFloat = 1.0 * UIScreen.main.scale / 3.0
}
