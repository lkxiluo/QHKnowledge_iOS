//
//  NetworkingExampleVC.swift
//  networking 使用示例
//
//  Created by 罗坤 on 2021/6/15.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

class NetworkingExampleViewController: BaseViewController {
    let netVM = NetwokingViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "网络请求使用示例"
    }
}

extension NetworkingExampleViewController: SpiderRouterJumpProtocol {
    static func registerJumpRouter() -> RouterType {
        return (RouterJumpPath.debugNet, NSStringFromClass(NetworkingExampleViewController.self))
    }
    
    static func isCanJumpRouter(path: String) -> Bool {
        return path == RouterJumpPath.debugNet
    }
    
    static func createJumpRouterTarget(routerModel: SpiderRouterModel) -> UIViewController? {
        let networkVC = NetworkingExampleViewController()
        return networkVC
    }
}
