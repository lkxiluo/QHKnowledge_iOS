//
//  NetworkRequest.swift
//  发起网络请求
//
//  Created by 罗坤 on 2021/6/12.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

/// 发起网络请求
public struct NetworkRequest {
    typealias ResponseModelHandle = ((Codable?) -> Void)
    private static var requestObj: [String: Any] = [:]
    
    /// 发起网络请求
    static func request(_ target: TargetPluginProtocol,
                        cacheResponseHandle: ResponseModelHandle? = nil,
                        successHandle: @escaping ResponseModelHandle,
                        failureHandle: ResponseModelHandle? = nil) {
        /// 相同的请求，先取消在请求
        cancelRequest(target: target)
        
        /// 缓存是否过期，是否实现缓存回调
        let cacheKey = target.cacheKey
        if !ResponseCache.default.isExpiry(for: cacheKey),
           let cacheCallback = cacheResponseHandle {
            /// 获取缓存并触发缓存回调
            let cachResponseDic = getCacheResponse(cacheKey: cacheKey, cacheResponseHandle: cacheCallback)
            
            switch target.responseCachExpiry {
            /// 只读缓存，不发请求
            case .onlyResponseCache(_):
                guard let responseDic = cachResponseDic else {
                    /// 取不到缓存触发请求失败回调
                    let responseDic = [
                        "code":  NetResponseCode.error10001.code,
                        "message": NetResponseCode.error10001.message,
                        "data": ""
                    ] as [String : Any]
                    failureHandle?(target.responseModel(dataDic: responseDic))
                    return
                }
                /// 取到缓存则触发请求成功回调
                successHandle(target.responseModel(dataDic: responseDic))
                return
            default:
                break
            }
        }
        
        /// 如果过期移除缓存
        if ResponseCache.default.isExpiry(for: cacheKey) {
            switch target.responseCachExpiry {
            case .none: break
            default:
                ResponseCache.default.removeObject(for: cacheKey) { (isSuccess) in
                    DLog("移除缓存成功 \(isSuccess)")
                }
            }
        }
        
        let request = netWorkRequest(target) { responseDic in
            switch target.responseCachExpiry {
            case .none: break
            default:
                cacheResponse(cacheKey: target.cacheKey,
                              responseDic: responseDic,
                              cacheExpiry: target.responseCachExpiry)
            }
            successHandle(target.responseModel(dataDic: responseDic))
            requestObj.removeValue(forKey: target.requestKey)
        } failureCallback: { responseDic in
            requestObj.removeValue(forKey: target.requestKey)
            guard let failedCallback = failureHandle else {
                return
            }
            failedCallback(target.responseModel(dataDic: responseDic))
        }
        /// 保存当前请求对象
        requestObj[target.requestKey] = request
    }
    
    /// 取消请求
    static func cancelRequest(target: TargetPluginProtocol) {
        guard let requestCancel: Cancellable = requestObj[target.requestKey] as? Cancellable else {
            return
        }
        requestCancel.cancel()
        requestObj.removeValue(forKey: target.requestKey)
    }
    
    /// 取消所有请求
    static func cancelAllRequest() {
        for requestCancel in requestObj {
            let requestKey = requestCancel.key
            guard let requestCancel: Cancellable = requestObj[requestKey] as? Cancellable else {
                return
            }
            requestCancel.cancel()
            requestObj.removeValue(forKey: requestKey)
        }
    }
    
    /// 读取请求缓存数据
    private static func getCacheResponse(cacheKey: String,
                                         cacheResponseHandle: ResponseModelHandle) ->
    [String: Any]? {
        let cacheModel = ResponseCache.default.cacheObject(for: cacheKey)
        guard let jsonDic = dataToDic(data: cacheModel?.data ?? Data()) else {
            return nil
        }
        DLog("读取缓存：\(jsonDic)")
        return jsonDic
    }
    
    /// 缓存请求返回数据
    private static func cacheResponse(cacheKey: String,
                                      responseDic: [String: Any]?,
                                      cacheExpiry: CacheExpiry) {
        guard let dataDic = responseDic else {
            return
        }
        
        let responseData = dataDic.toData()
        var cacheModel = CacheModel()
        cacheModel.data = responseData
        ResponseCache.default.addCacheModel(object: cacheModel,
                                            for: cacheKey,
                                            expiry: cacheExpiry.expired)
    }
    
    private static func dataToDic(data: Data) -> [String: Any]? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            guard let dic = json as? [String: Any]? else {
                return nil
            }
            return dic
        } catch {
            return nil
        }
    }

}
