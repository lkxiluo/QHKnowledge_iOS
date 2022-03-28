//
//  ParseModelUtil.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/6/2.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// Swift 数据解析辅助工具
struct ParseModelUtil {
    static func parseData <T: Codable> (json: [AnyHashable : Any]?) -> T? {
        let decoder = JSONDecoder()
        do {
            guard json != nil else {
                return nil
            }
            
            let jsonData: Data = try JSONSerialization.data(withJSONObject: json as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            let outModel: T = try decoder.decode(T.self, from: jsonData)
            return outModel
        } catch {
            DLog("解析失败 \(error)")
            return nil
        }
    }
    
    /// 结构体转json数据一般返回的是 dict
    /// - Parameter someStruct: 结构体类型实例
    /// - Returns: json
    static func structToJSONObject <T:Codable> (_ someStruct: T) -> Any? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(someStruct)
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return jsonObject
        } catch {
            DLog("转换失败 \(error)")
            return nil
        }
    }
    
    static func structToJSONString <T:Codable> (_ someStruct: T) -> String? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(someStruct)
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            let jsonData: Data? = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            guard let tmpJsonData = jsonData else {
                return nil
            }
            return String.init(data: tmpJsonData, encoding: .utf8)
        } catch {
            DLog("转换失败 \(error)")
            return nil
        }
    }
}
