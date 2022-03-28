//
//  ResponseCacheProtocol.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/6/12.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import Moya

/// 接口对象插件协议
protocol TargetPluginProtocol: TargetType {
    // MARK: - 缓存配置
    /// 缓存策略设置
    var responseCachExpiry: CacheExpiry {get}
    /// 请求结果缓存键
    var cacheKey: String {get}
    /// 网络请求标识
    var requestKey: String {get}
    /// 请求参数
    var parameters: [String: String] {get}
    
    // MARK: - 方法
    /// 网络请求模型
    func responseModel(dataDic: [String: Any]?) -> Codable?
}
