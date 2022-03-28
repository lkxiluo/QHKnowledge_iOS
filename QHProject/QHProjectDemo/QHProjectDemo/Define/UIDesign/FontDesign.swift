//
//  FontStyle.swift
//  字体设计规范
//
//  Created by 罗坤 on 2021/4/26.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// UI 字体设计规范
struct FontDesign {
    // MARK: - 主字样，苹方-简
    /// 重体
    static let fontBoldName = "PingFangSC-Bold"
    /// 粗体
    static let fontMediumName = "PingFangSC-Medium"
    /// 常规
    static let fontRegularName = "PingFangSC-Regular"
    /// 细体
    static let fontLightName = "PingFangSC-Light"
    
    // MARK: - 通用字体
    /// 24 号重体
    static let b24 = boldFont(size: CGFloat(24.0)~)
    /// 24 号粗体
    static let m24 = mediumFont(size: CGFloat(24.0)~)
    /// 24 号常规
    static let r24 = regularFont(size: CGFloat(24.0)~)
    /// 24 号细体
    static let l24 = lightFont(size: CGFloat(24.0)~)
    
    /// 22 号重体
    static let b22 = boldFont(size: CGFloat(22.0)~)
    /// 22 号粗体
    static let m22 = mediumFont(size: CGFloat(22.0)~)
    /// 22 号常规
    static let r22 = regularFont(size: CGFloat(22.0)~)
    /// 22 号细体
    static let l22 = lightFont(size: CGFloat(22.0)~)
    
    /// 18 号重体
    static let b18 = boldFont(size: CGFloat(18.0)~)
    /// 18 号粗体
    static let m18 = mediumFont(size: CGFloat(18.0)~)
    /// 18 号常规
    static let r18 = regularFont(size: CGFloat(18.0)~)
    /// 18 号细体
    static let l18 = lightFont(size: CGFloat(18.0)~)
    
    /// 17 号重体
    static let b17 = boldFont(size: CGFloat(17.0)~)
    /// 17 号粗体
    static let m17 = mediumFont(size: CGFloat(17.0)~)
    /// 17 号常规
    static let r17 = regularFont(size: CGFloat(17.0)~)
    /// 17 号细体
    static let l17 = lightFont(size: CGFloat(17.0)~)
    
    /// 16 号重体
    static let b16 = boldFont(size: CGFloat(16.0)~)
    /// 16 号粗体
    static let m16 = mediumFont(size: CGFloat(16.0)~)
    /// 16 号常规
    static let r16 = regularFont(size: CGFloat(16.0)~)
    /// 16 号细体
    static let l16 = lightFont(size: CGFloat(16.0)~)
    
    /// 15 号重体
    static let b15 = boldFont(size: CGFloat(15.0)~)
    /// 15 号粗体
    static let m15 = mediumFont(size: CGFloat(15.0)~)
    /// 15 号常规
    static let r15 = regularFont(size: CGFloat(15.0)~)
    /// 15 号细体
    static let l15 = lightFont(size: CGFloat(15.0)~)
    
    /// 14 号重体
    static let b14 = boldFont(size: CGFloat(14.0)~)
    /// 14 号粗体
    static let m14 = mediumFont(size: CGFloat(14.0)~)
    /// 14 号常规
    static let r14 = regularFont(size: CGFloat(14.0)~)
    /// 14 号细体
    static let l14 = lightFont(size: CGFloat(14.0)~)
    
    /// 13 号重体
    static let b13 = boldFont(size: CGFloat(13.0)~)
    /// 13 号粗体
    static let m13 = mediumFont(size: CGFloat(13.0)~)
    /// 13 号常规
    static let r13 = regularFont(size: CGFloat(13.0)~)
    /// 13 号细体
    static let l13 = lightFont(size: CGFloat(13.0)~)
    
    /// 12 号重体
    static let b12 = boldFont(size: CGFloat(12.0)~)
    /// 12 号粗体
    static let m12 = mediumFont(size: CGFloat(12.0)~)
    /// 12 号常规
    static let r12 = regularFont(size: CGFloat(12.0)~)
    /// 12 号细体
    static let l12 = lightFont(size: CGFloat(12.0)~)
    
    /// 11 号重体
    static let b11 = boldFont(size: CGFloat(11.0)~)
    /// 11 号粗体
    static let m11 = mediumFont(size: CGFloat(11.0)~)
    /// 11 号常规
    static let r11 = regularFont(size: CGFloat(11.0)~)
    /// 11 号细体
    static let l11 = lightFont(size: CGFloat(11.0)~)
    
    /// 10 号重体
    static let b10 = boldFont(size: CGFloat(10.0)~)
    /// 10 号粗体
    static let m10 = mediumFont(size: CGFloat(10.0)~)
    /// 10 号常规
    static let r10 = regularFont(size: CGFloat(10.0)~)
    /// 10 号细体
    static let l10 = lightFont(size: CGFloat(10.0)~)
    
    // MARK: - Private
    private static func boldFont(size: CGFloat) -> UIFont {
        return UIFont(name: fontBoldName, size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    private static func mediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: fontMediumName, size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    private static func regularFont(size: CGFloat) -> UIFont {
        return UIFont(name: fontRegularName, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    private static func lightFont(size: CGFloat) -> UIFont {
        return UIFont(name: fontLightName, size: size) ?? UIFont.systemFont(ofSize: size, weight: .light)
    }
}
