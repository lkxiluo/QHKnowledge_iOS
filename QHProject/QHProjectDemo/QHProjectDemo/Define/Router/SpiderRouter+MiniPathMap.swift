//
//  SpiderRouter+MiniPathMap.swift
//  跳转路由映射
//  因各端对模块的划分不一致，各端需做映射
//  服务器返回的路由，移动客户端做本地映射
//         服务器 URL
//       /     |    \
//      /      |     \
//    iOS   Android  miniApp
//
//  Created by 罗坤 on 2021/7/8.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

extension SpiderRouter {
    /// 将小程序路由的参数转为本地的路由参数，
    private func getNativeURLQuery(nativeRouterPath: String, miniQuery: String) -> String {
        var query = miniQuery
        #warning("特殊情况: 如果参数不一样，需求特殊处理")
        /** 示例
        if nativeRouterPath == RouterJumpPath.home {
            
        }*/
        
        if !query.isEmpty {
            query = "?" + query
        }
        return query
    }
    
    /// 执行网络加载的路由路径跳转
    /// - Parameter miniPath: 小程序路由表的路径
    func performMiniJump(path: String?) {
        guard let miniPath = path, !miniPath.isEmpty else {
            return
        }
        
        var routerURL = RouterConfig.scheme + RouterConfig.jumpHost
        /// 最终跳转的路由路径
        var routerPath = ""
        /// 最终跳转的路由参数
        var routerQuery = ""
        
        /// 小程序路由路径
        var mPath = ""
        /// 小程序路由参数
        var miniQuery = ""
        
        mPath = miniPath
        if miniPath.isValidHttpUrl || miniPath.isValidHttpsUrl {
            let newURL = miniPath.trimmingCharacters(in: .whitespaces).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let url = URL(string: newURL)
            mPath = url?.path ?? ""
            miniQuery = url?.query?.removingPercentEncoding ?? ""
        }
        
        if mPath.prefix(1) == "/" {
            let startIndex = mPath.index(mPath.startIndex, offsetBy:0)
            let endIndex = mPath.index(mPath.startIndex, offsetBy:0)
            let range = startIndex...endIndex
            mPath.replaceSubrange(range, with: "")
        }
        
        let pathContents = mPath.components(separatedBy: "?")
        if let path = pathContents.first, pathContents.count > 0 {
            mPath = path
        }
        
        if let query = pathContents.last, pathContents.count > 1 {
            miniQuery = query
        }
        
        guard let nativePath = RouterPathMap().nativeRouterPath(serverPath: mPath) else {
            return
        }
        
        routerPath = nativePath
        routerQuery = getNativeURLQuery(nativeRouterPath: routerPath, miniQuery: miniQuery)
        routerURL += routerPath + routerQuery
        DLog("小程序: \(miniPath) ##### 本地：\(routerURL)")
        perFormURL(url: routerURL)
    }
}
