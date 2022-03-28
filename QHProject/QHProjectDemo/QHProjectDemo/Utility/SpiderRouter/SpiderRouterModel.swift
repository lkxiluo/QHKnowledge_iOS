//
//  SpiderRouterModel.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/5/8.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// 跳转模式
enum TranslateMode {
    case push
    case present
}

/// 路由对象配置的数据模型
final class SpiderRouterModel {
    /// 路由路径
    var path: String = ""
    /// 目标名
    var targetName: String = ""
    /// 是否是事件响应
    var isEvent: Bool = false
    /// 路由 URL
    var url: String = ""
    /// 转场模式
    var translateMode: TranslateMode = .push
    /// present模式
    var presentMode: UIModalPresentationStyle?
    /// 路由参数，key 和路由对象的属性名一致
    var query: [String: Any]?
    /// 转场动画
    var animation: Bool = true
    
    convenience init(path: String, query: [String: Any]?) {
        self.init()
        self.path = path
        self.query = query
    }
    
    /// 将 url 转成配置模型
    class func routerModelFromURL(url: String) -> SpiderRouterModel {
        let routerModel = SpiderRouterModel()

        // 去除空格
        let newURL = url.trimmingCharacters(in: .whitespaces).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let routerURL = URL(string: newURL)
        let query = routerURL?.query?.removingPercentEncoding
        guard routerURL?.scheme != nil,
              routerURL?.host != nil,
              let path = routerURL?.path else {
            assert(false, "这是一个无效路由···")
            return routerModel
        }
        
        if newURL.hasPrefix(SpiderRouterURLHelper.getJumpRouterURL()) ||
            newURL.hasPrefix(SpiderRouterURLHelper.https) ||
            newURL.hasPrefix(SpiderRouterURLHelper.http) {
            // 是否是跳转路由
        } else if newURL.hasPrefix(SpiderRouterURLHelper.getEventRouterURL()) ||
                    newURL.hasPrefix(SpiderRouterURLHelper.https) ||
                    newURL.hasPrefix(SpiderRouterURLHelper.http) {
            // 是否是事件路由
            routerModel.isEvent = true
        } else {
            assert(false, "这是一个无效路由···")
        }
        routerModel.path = path
        routerModel.query = SpiderRouterURLHelper.parseQueray(query: query ?? "")
        routerModel.url = url
        return routerModel
    }
    
    /// 将跳转数据源转成模型
    class func modelFromJumpPath(path: String, queryDic: [String: Any]?) -> SpiderRouterModel {
        let url = SpiderRouterURLHelper.getJumpRouterURL()
            + path
            + SpiderRouterURLHelper.queryFromDic(queryDic: queryDic)
        return SpiderRouterModel.routerModelFromURL(url: url)
    }
    
    /// 将事件数据源转成模型
    class func modelFromEventPath(path: String, queryDic: [String: Any]?) -> SpiderRouterModel {
        let url = SpiderRouterURLHelper.getEventRouterURL()
            + path
            + SpiderRouterURLHelper.queryFromDic(queryDic: queryDic)
        return SpiderRouterModel.routerModelFromURL(url: url)
    }
    
    class func urlFromPath(path: String, queryDic: [String: Any]?) -> String {
        let url = SpiderRouterURLHelper.getJumpRouterURL()
            + path
            + SpiderRouterURLHelper.queryFromDic(queryDic: queryDic)
        return url
    }
}
