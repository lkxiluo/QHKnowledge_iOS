//
//  NetworkManager.swift
//  QHProjectECMall
//
//  Created by kimbo on 2021/4/29.
//  Copyright © 2021 QHProject. All rights reserved.
//
//  网络层管理

import Foundation
import Alamofire
import Moya
import SwiftyJSON

/// 默认请求超时时间
private var requestTimeOut: Double = 20.0
/// 单个模型的成功回调 包括：模型，网络请求的模型(code,message,data等)
typealias RequestModelSuccessCallback = (([String : Any]) -> Void)
/// 失败回调 包括：网络请求的模型(code,message,data等)
typealias RequestFailureCallback = (([String : Any]) -> Void)
/// 网络错误的回调
typealias ErrorCallback = (() -> Void)
/// 请求响应回调
typealias ResponseHandle = () -> Void

let dataKey = "data"
let messageKey = "message"
let codeKey = "code"
let successCode: Int = 200

/// 网络请求的基本设置，这里可以拿到是具体的哪个网络请求，可以在这里做一些设置（比如某个请求的特殊超时时间等等）
private let myEndpointClosure = { (target: TargetType) -> Endpoint in
    /// 这里把endpoint重新构造一遍主要为了解决网络请求地址里面含有? 时无法解析的bug https://github.com/Moya/Moya/issues/1198
    let url = target.baseURL.absoluteString + target.path
    var task = target.task

    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
    return endpoint
}

/// 网络请求的设置
private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = requestTimeOut
        // 打印请求参数
        #if DEBUG
        if let requestData = request.httpBody {
            print("RequestUrl：\(request.url!)" + "\n" + "\(request.httpMethod ?? "")" + "\n" + "Parameters:" + "\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        } else {
            print("RequestUrl：\(request.url!)" + "\(String(describing: request.httpMethod))")
        }
        
        if let header = request.allHTTPHeaderFields {
            print("RequestHeader：\(header)")
        }
        #endif
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

// MARK: - 网络请求
/// 网络请求发送的核心初始化方法，创建网络请求对象
fileprivate let provider = MoyaProvider<MultiTarget>(endpointClosure: myEndpointClosure,
                                                     requestClosure: requestClosure,
                                                     plugins: [RequestSignPlugin(), RequestTokenPlugin()],
                                                     trackInflights: false)

/// 网络请求，当模型为dict类型
/// - Parameters:
///   - target: 接口
///   - modelType: 要转换成的model模型
///   - successCallback: 成功的回调
///   - failureCallback: 失败的回调
/// - Returns: 取消当前网络请求Cancellable实例
@discardableResult
func netWorkRequest(_ target: TargetType,
                    successCallback: @escaping RequestModelSuccessCallback,
                    failureCallback: RequestFailureCallback? = nil) -> Cancellable? {
    let isNetworkConnect = NetworkReachabilityManager()?.isReachable ?? true
    if !isNetworkConnect {
        errorHandler(code: NetResponseCode.error9999.code,
                     message: NetResponseCode.error9999.message,
                     failure: failureCallback)
        return nil
    }
    
    return provider.request(MultiTarget(target)) { result in
        switch result {
        case let .success(response):
            do {
                guard let jsonDic = try response.mapJSON() as? [String : Any] else {
                    errorHandler(code: NetResponseCode.error10001.code,
                                 message: NetResponseCode.error10001.message,
                                 failure: failureCallback)
                    return
                }
                successCallback(jsonDic)
                #if DEBUG
                print("url：\(String(describing: response.request?.url)) \n Response：\(jsonDic)")
                #endif
            } catch {
                // code = 1000000 代表JSON解析失败  这里根据具体业务来自定义
                errorHandler(code: 1000000,
                             message: String(data: response.data,
                                             encoding: String.Encoding.utf8)!,
                             failure: failureCallback)
            }
        case let .failure(error as NSError):
            #if DEBUG
            print("Error Response：\(error)")
            #endif
            errorHandler(code: error.code, message: "网络连接失败", failure: failureCallback)
        }
    }
}

/// 错误处理
private func errorHandler(code: Int, message: String, failure: RequestFailureCallback?) {
    let responseDic = [
        "code":  code,
        "message": message,
        "data": ""
    ] as [String : Any]
    failure?(responseDic)
}
