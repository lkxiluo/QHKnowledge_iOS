//
//  RouterJumpPath.swift
//  QHProjectECMall
//
//  Created by QHProject on 2021/5/7.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/**
 * 跳转路由注册表
 */
/// 跳转路径，定义格式为：模块名+页面功能名，例如订单模块的订单详情页面，/order/orderDetail
struct RouterJumpPath {
    /// 斜杠
    private static let slash = "/"
    // MARK: - 模块划分，对应 Modules 下文件夹名
    /// 调试模块
    private static let kDebug = "debug"
    /// 登录、注册模块，一键登录、微信登录、验证码登录、苹果登录、支付宝登录、找回密码等
    private static let kLogin = "login"
    /// 商品模块，首页、分类列表、商品列表、商品搜索、商品详情等
    private static let kGoods = "Goods"
    /// 支付模块，购物车、支付结算流程、账单等
    private static let kPay = "pay"
    /// 用户模块，个人中心，个人信息、地址管理(与个人信息相关的)、会员/积分体系、优惠券体系、分享、通知中心等
    private static let kUser = "user"
    /// 订单模块，订单列表、订单详情、售后、评价等
    private static let kOrder = "order"
    /// 门店模块，门店列表
    private static let kStore = "store"
    
    // MARK: - 路由定义
    // MARK: - 调试模块
    static let debugApi     = slash + kDebug + "/debug"
    /// AlertView 弹窗使用示例
    static let testApi      = slash + kDebug + "/testApi"
    /// 提示框
    static let alert    = slash + kDebug + "/alert"
    /// 提示弹窗使用示例
    static let debugToastView = slash + kDebug + "/debugToastView"
    /// 空白页使用示例
    static let debugEmptyView = slash + kDebug + "/debugEmptyView"
    /// 加载框使用示例
    static let debugHud = slash + kDebug + "/debugHud"
    /// 网络请求使用示例
    static let debugNet = slash + kDebug + "/debugNet"
    /// 路由使用示例
    static let debugRouter = slash + kDebug + "/debugRouter"
    static let debugPushRouter = slash + kDebug + "/debugPushRouter"
    static let debugPresentRouter = slash + kDebug + "/debugPresentRouter"
    /// 上下拉刷新使用示例
    static let debugRefresh = slash + kDebug + "/debugRefresh"
    /// 事件回调路由示例
    static let debugEventRouter = slash + kDebug + "/degugEventRouter"
    /// flutter 混编使用示例
    static let debugFlutter = slash + kDebug + "/debugFlutter"
    
    // MARK: - 业务模块
}
