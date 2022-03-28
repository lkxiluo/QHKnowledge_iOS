//
//  ColorStyle.swift
//  颜色设计规范
//
//  Created by 罗坤 on 2021/4/26.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// UI 颜色设计规范
extension UIColor {
    // MARK: - View 颜色
    /// 背景颜色
    static var backgroud: UIColor {
        return UIColor.init(named: "cF2F2F2") ?? .color(hexColor: 0xF2F2F2)
    }
    
    /// 主调色
    static var main: UIColor {
        return UIColor.init(named: "cEF2F2F") ?? .color(hexColor: 0xEF2F2F)
    }
    
    /// tabbarItem 默认颜色
    static var tabbarItem: UIColor {
        return UIColor.init(named: "cFF4D4F") ?? .color(hexColor: 0xFF4D4F)
    }
    
    /// 渐变起始色
    static var cEF2B2B: UIColor {
        return UIColor.init(named: "cEF2B2B") ?? .color(hexColor: 0xEF2B2B)
    }
    
    /// 渐变结束色
    static var cEF2F2F: UIColor {
        return UIColor.init(named: "cEF2F2F") ?? .color(hexColor: 0xEF2F2F)
    }
    
    /// 灰色背景分割线
    static var cE5E5E5: UIColor {
        return UIColor.init(named: "cE5E5E5") ?? .color(hexColor: 0xE5E5E5)
    }
    
    /// 白色背景分割线
    static var cF2F2F2: UIColor {
        return UIColor.init(named: "cF2F2F2") ?? .color(hexColor: 0xF2F2F2)
    }
    
    // MARK: - 字体颜色
    /// 字体主色
    static var c1A1A1A: UIColor {
        return UIColor.init(named: "c1A1A1A") ?? .color(hexColor: 0x1A1A1A)
    }
    
    /// 常规字体
    static var c333333: UIColor {
        return UIColor.init(named: "c333333") ?? .color(hexColor: 0x333333)
    }
    
    /// 副字体
    static var c666666: UIColor {
        return UIColor.init(named: "c666666") ?? .color(hexColor: 0x666666)
    }
    
    /// 占位字体
    static var c999999: UIColor {
        return UIColor.init(named: "c999999") ?? .color(hexColor: 0x999999)
    }
}
