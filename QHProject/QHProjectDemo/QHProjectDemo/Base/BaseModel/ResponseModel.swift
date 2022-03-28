//
//  ResponseCommonModel.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/7/9.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// 网络返回的数据结构
let responseCodeKey = "code"
let responseMessageKey = "message"
let responseDataKey = "data"

struct ResponseModel: Codable {
    var code: Int?
    var message: String?
    var data: String?
}
