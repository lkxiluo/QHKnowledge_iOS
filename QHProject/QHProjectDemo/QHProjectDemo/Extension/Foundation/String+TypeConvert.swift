//
//  String+TypeConvert.swift
//  类型转化
//
//  Created by 罗坤 on 2021/6/12.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// 类型转化
extension String {
    /// 转为字典
    func toDictionary() -> [String : Any] {
        var result = [String : Any]()
        guard !self.isEmpty else { return result }
        
        guard let dataSelf = self.data(using: .utf8) else {
            return result
        }
        
        if let dic = try? JSONSerialization.jsonObject(with: dataSelf,
                                                       options: .mutableContainers) as? [String : Any] {
            result = dic
        }
        return result
    }
    
    /// 生成条形码
    /// - Returns: 条形码图片
    func toBarCodeImage() -> UIImage? {
        let data = self.data(using: .ascii)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        return UIImage(ciImage: (filter?.outputImage)!)
    }
    
    /// 手机号转为带 * 号的手机号
    func toPhoneStarNumber() -> String {
        var iphoneNumber: String = self
        if !iphoneNumber.isEmpty, iphoneNumber.count > 7 {
            for index in 3..<7 {
                let iphoneStartIndex = iphoneNumber.index(iphoneNumber.startIndex, offsetBy: index)
                let iphoneEndIndex = iphoneNumber.index(iphoneNumber.startIndex, offsetBy: index + 1)
                let range = iphoneStartIndex..<iphoneEndIndex
                iphoneNumber.replaceSubrange(range, with: "*")
            }
        }
        return iphoneNumber
    }
}
