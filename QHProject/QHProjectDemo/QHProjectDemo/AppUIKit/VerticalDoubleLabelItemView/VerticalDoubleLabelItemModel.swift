//
//  VerticalDoubleLabelItemModel.swift
//  竖向双行文字数据模型
//
//  Created by 罗坤 on 2021/7/14.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// 竖向双行文字数据模型
struct VerticalDoubleLabelItemModel {
    /// 上行文字配置
    var upTitle: String?
    var upTitleColor: UIColor = .c1A1A1A
    var upTitleFont: UIFont = FontDesign.r16
    var upAttributText: NSAttributedString?
    
    /// 间距
    var spacing: CGFloat = 5.0
    /// 索引标识
    var tag: Int = 0
    
    /// 下行文字配置
    var downTitle: String?
    var downTitleColor: UIColor = .c1A1A1A
    var downTitleFont: UIFont = FontDesign.r12
    var downAttributText: NSAttributedString?
}
