//
//  RouterPathMap.swift
//  因各端对模块的划分不一致，各端需做映射
//  服务器返回的路由，移动客户端做本地映射
//         服务器 URL
//       /     |    \
//      /      |     \
//    iOS   Android  miniApp
//  Created by 罗坤 on 2021/7/8.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

struct RouterPathMap {
    // key 为服务器路由路径， value 为 iOS 端路由路径，映射表
//    private let mapTable = [
//        "pages/home/main": RouterJumpPath.home
//    ]
    
    private let mapTable = [
        "pages/home/main": ""
    ]
    
    /// 通过服务器路径获取本机路由路径
    func nativeRouterPath(serverPath: String) -> String? {
        return mapTable[serverPath]
    }
}
