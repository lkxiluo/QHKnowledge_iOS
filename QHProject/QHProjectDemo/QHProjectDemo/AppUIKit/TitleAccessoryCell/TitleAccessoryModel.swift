//
//  TitleAccessoryModel.swift
//  带附视图的列表显示单元数据配置
//
//  Created by 罗坤 on 2021/7/22.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// 带附视图的列表显示单元数据配置
struct TitleAccessoryModel {
    /// 单元高度
    var height: CGFloat = 44.0
    /// 标题
    var title: String = ""
    /// 附标题
    var accessoryTitle: String = ""
    var accessoryTitleColor: UIColor?
    /// 附图片
    var accessoryImage: UIImage?
    /// 单元格类型
    var type: Any?
}
