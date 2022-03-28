//
//  RouterPushVC.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/7/6.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import SwiftyJSON

final class RouterPushViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我是被 push 的"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "首页",
                                                                      style: .plain,
                                                                      target: self,
                                                                      action: #selector(homeAction))
    }
    
    @objc func homeAction() {
//        DMRouter.performJump(routerPath: RouterJumpPath.home, animated: false, query: ["shopId": "12345678"])
    }
}

extension RouterPushViewController: SpiderRouterJumpProtocol {
    static func registerJumpRouter() -> RouterType {
        return (RouterJumpPath.debugPushRouter, NSStringFromClass(RouterPushViewController.self))
    }
    
    static func isCanJumpRouter(path: String) -> Bool {
        return path == RouterJumpPath.debugPushRouter
    }
    
    static func createJumpRouterTarget(routerModel: SpiderRouterModel) -> UIViewController? {
        DLog("\(routerModel.query)")
        let pushVC = RouterPushViewController()
        guard let query = routerModel.query else {
            return pushVC
        }
        let params = JSON(query)
        let title: String = params["title"].stringValue
        print(title)
        return pushVC
    }
}
