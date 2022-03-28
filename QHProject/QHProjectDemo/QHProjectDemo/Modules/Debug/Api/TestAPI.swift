//
//  ExampleLoginAPI.swift
//  API 使用示例
//
//  Created by kimbo on 2021/4/30.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import Moya

/// API 使用示例 (商品详情)
struct TestAPI: TargetPluginProtocol {
    
    private(set) var productNo: String
    private(set) var skuID: String
    private(set) var userId: String
    private(set) var shopId: String
    
    var parameters: [String: String] {
        return [ "productNo": productNo,
                 "skuNo": skuID,
                 "userId": userId,
                 "shopId": shopId
        ]
    }
    var path: String {
        return "/mallv2/classify/user_center/commodity_detail_v212"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        return .requestParameters(parameters: parameters,
                                  encoding: JSONEncoding.default)
    }
    
    func responseModel(dataDic: [String : Any]?) -> Codable? {
        guard let dic = dataDic else {
            return nil
        }
        
        #warning("/** 根据自己的需求来解析数据 */")
        if let code = dic[responseCodeKey] as? Int,
           code == 0,
           let dataDic = dic[responseDataKey] as? [String: Any] {
            guard let testModel: ApiTestModel = ParseModelUtil.parseData(json: dataDic) else {
                return nil
            }
            return testModel
        } else {
            guard let responseModel: ResponseModel = ParseModelUtil.parseData(json: dic) else {
                return nil
            }
            return responseModel
        }
    }
}
