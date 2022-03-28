//
//  SpiderRouterURLHelper.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/5/8.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

struct SpiderRouterURLHelper {
    /// 路由前缀
    static var scheme = "https:"
    /// 跳转 host
    static var jumpHost = "//jumpHost"
    /// 事件 host
    static var eventHost = "//eventHost"
    
    /// 适配 universal link
    static let https = "https"
    static let http = "http"
    
    /// 跳转路由 URL
    static func getJumpRouterURL() -> String {
        return scheme + jumpHost
    }
    
    /// 事件响应 URL
    static func getEventRouterURL() -> String {
        return scheme + eventHost
    }
    
    /// 解析 url 参数
    static func parseQueray(query: String) -> [String: Any] {
        var queryDic: [String: Any] = [:]
        
        let querys = query.components(separatedBy: "&")
        for item in querys {
            let queryItems = item.components(separatedBy: "=")
            if let key = queryItems.first, let value = queryItems.last {
                queryDic[key] = value
            }
        }
        
        return queryDic
    }
    
    /// 将参数转成字符串
    static func queryFromDic(queryDic: [String: Any]?) -> String {
        guard let queryDic = queryDic, !queryDic.isEmpty else {
            return ""
        }
        
        var query = "?"
        var index = 1
        for key in queryDic.keys {
            let value = "\(queryDic[key] ?? "")"
            query.append(key)
            query.append("=")
            query.append(value)
            if index < queryDic.count {
                query.append("&")
            }
            
            index += 1
        }
        
        return query
    }
}
