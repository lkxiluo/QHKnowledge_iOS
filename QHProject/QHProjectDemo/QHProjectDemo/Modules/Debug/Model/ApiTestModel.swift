//
//  ExampleModel.swift
//  QHProjectECMall
//
//  Created by kimbo on 2021/4/30.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/**
 数据模型使用示例
 */
struct ApiTestModel: Codable {
    /**
     * 属性需要声明为可选类型
     */
    var title: String?
    var gaPrefix: String?
    var images: String?
    var multipic: String?
    var type: Int?
    var id: Int?
    
    /// 当定义的属性名和返回的字段不一致时需要映射(所有字段都要做)
    enum CodingKeys: String, CodingKey {
        case gaPrefix = "ga_prefix"
    }
}
