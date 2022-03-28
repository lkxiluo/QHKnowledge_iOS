//
//  RequestApiConfig.swift
//  网络请求 URL 配置
//
//  Created by 罗坤 on 2021/5/6.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// UserDefaults 保存渠道的 key
fileprivate let requestChannel = "requestChannel"
/// UserDefaults 保存服务器环境的 key
fileprivate let requestDevEnrironment = "requestDevEnrironment"

fileprivate let gateway = "app/"

enum RequestDevEnrironment: Int {
    case test = 0       // 测试环境
    case dev            // 开发环境
    case distribute     // 线上环境
}

/// 网络请求配置
final class RequestApiConfig {
    static let shared: RequestApiConfig = RequestApiConfig()
    /// 请求签名 key
    var requestSignKey: String {
        switch getDevEnrironment() {
        case .test: return "l94JPYM08ltlkDZ00TjK68Tyavx2VqwL"
        case .dev: return "l94JPYM08ltlkDZ00TjK68Tyavx2VqwL"
        case .distribute: return "l94JPYM08ltlkDZ00TjK68Tyavx2VqwL"
        }
    }
    private var userdefault: UserDefaults = UserDefaults.standard
    
    #if RELEASE
    var devEnrironment: RequestDevEnrironment = .distribute
    #endif
    
    #if DEBUG
    var devEnrironment: RequestDevEnrironment = .test {
        didSet {
            userdefault.setValue(devEnrironment.rawValue, forKey: requestDevEnrironment)
            userdefault.synchronize()
        }
    }
    #endif
    
    /// 网络请求地址
    var mainURL: String {
        var urlString = "https://nextmall.gree.com/"
        #if DEBUG
        switch getDevEnrironment() {
        case .test:
            urlString = "https://testingmall.gree.com/"
        case .dev:
            urlString = "https://devmall.gree.com/"
        case .distribute:
            break
        }
        #endif
        return urlString + gateway
    }
    
    func getDevEnrironment() -> RequestDevEnrironment {
        #if DEBUG
        let userDevEnrironment = userdefault.value(forKey: requestDevEnrironment)
        if let tmpDevEnrironment = userDevEnrironment as? Int,
           let type = RequestDevEnrironment.init(rawValue: tmpDevEnrironment) {
            return type
        }
        #endif
        return devEnrironment
    }
}
