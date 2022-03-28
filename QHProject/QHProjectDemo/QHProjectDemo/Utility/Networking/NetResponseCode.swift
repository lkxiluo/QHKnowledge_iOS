//
//  NetResponseCode.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/6/17.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

struct NetResponseCode {
    typealias ResponseCode = (code: Int, message: String)
    static let error9999: ResponseCode = (9999, "网络似乎出现了问题")
    static let error10000: ResponseCode = (10000, "读取缓存失败")
    static let error10001: ResponseCode = (10001, "数据结构解析失败")
    static let error100031: ResponseCode = (100031, "当前登录失效，请重新登录")
    static let error100047: ResponseCode = (100047, "短信验证码错误")
    static let error100043: ResponseCode = (100043, "您还未登录，请先登录")
}
