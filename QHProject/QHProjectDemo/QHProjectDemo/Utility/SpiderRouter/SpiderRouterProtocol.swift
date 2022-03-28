//
//  SpiderRouterProtocol.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/5/8.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// 跳转转协议
protocol SpiderRouterJumpProtocol {
    /// 注册跳转路由
    static func registerJumpRouter() -> RouterType
    /// 是否可以跳转
    /// - Parameter path: 路由路径
    static func isCanJumpRouter(path: String) -> Bool
    /// 创建跳转路由对象
    /// - Parameter routerModel: 跳转路由数据
    static func createJumpRouterTarget(routerModel: SpiderRouterModel) -> UIViewController?
    
    /// 是否跳转到(回到)栈低
    /// - Parameter path: 路由路径
    static func isRootRouter(path: String) -> Bool
    /// 跳转回调
    /// - Parameter routerModel: 跳转路由数据
    func rootHandle(routerModel: SpiderRouterModel)
}

extension SpiderRouterJumpProtocol {
    static func isRootRouter(path: String) -> Bool {
        return false
    }
    
    func rootHandle(routerModel: SpiderRouterModel) {
        
    }
}

/// 事件响应协议
protocol SpiderRouterEventProtocol {
    /// 是否可以响应事件
    /// - Parameter path: 路由路径
    func isCanEventHandle(path: String) -> Bool
    /// 响应事件回调
    /// - Parameter routerModel: 跳转路由数据
    func eventHandleWithRouterModel(routerModel: SpiderRouterModel)
}
