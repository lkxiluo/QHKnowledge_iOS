//
//  RequestTokenPlugin+TimeOut.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/7/26.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import Moya

/// token 失效
extension RequestTokenPlugin {
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response): break
        default: break
        }
    }
}
