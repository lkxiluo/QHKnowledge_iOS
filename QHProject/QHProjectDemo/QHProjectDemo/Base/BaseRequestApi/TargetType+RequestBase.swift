//
//  BaseRequestApi.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/4/26.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import Moya
import Cache

// MARK: - 请求配置
/// 默认配置
extension TargetType {
    
    var baseURL: URL {
        return URL.init(string:(RequestApiConfig.shared.mainURL))!
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
        return [:]
    }
}

// MARK: - 网络缓存
extension TargetPluginProtocol {
    var task: Task {
        let encoding: ParameterEncoding
        switch self.method {
        case .post:
            encoding = JSONEncoding.default
        default:
            encoding = URLEncoding.default
        }
        
        if !parameters.isEmpty {
            return .requestParameters(parameters: parameters, encoding: encoding)
        }
        return .requestPlain
    }
    
    /// 默认为没有缓存
    var responseCachExpiry: CacheExpiry {
        return .none
    }
    
    /// 请求结果缓存键
    var cacheKey: String {
        let urlString = requestURL().url?.absoluteString ?? ""
        let endPoint = Endpoint(url: baseURL.absoluteString,
                                sampleResponseClosure: {.networkResponse(200, sampleData)},
                                method: method,
                                task: task,
                                httpHeaderFields: headers)
        var key = urlString
        do {
            let request = try endPoint.urlRequest()
            if let requestData = request.httpBody {
                let paramsString = String(data: requestData,
                                          encoding: String.Encoding.utf8) ?? ""
                let paramsDic = paramsString.toDictionary()
                key = CacheKey.cacheKey(url: urlString,
                                        parameters: paramsDic,
                                        commomParameters: nil)
            }
        } catch {
            key = CacheKey.cacheKey(url: urlString, parameters: nil, commomParameters: nil)
        }
        return key
    }
    
    /// 网络请求标识
    var requestKey: String {
        let urlString = requestURL().url?.absoluteString ?? ""
        let key = CacheKey.cacheKey(url: urlString, parameters: nil, commomParameters: nil)
        return key
    }
    
    /// 请求链接
    private func requestURL() -> URLRequest {
        guard let url = try? baseURL.asURL() else {
            return URLRequest(url: URL(string: "")!)
        }
        if !path.isEmpty {
            let urlRequest = URLRequest(url: url.appendingPathComponent(path))
            return urlRequest
        }
        return URLRequest(url: url)
    }
}

// MARK: - 请求签名
//extension RequestSignPlugin {
//    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
//    }
//}
