//
//  RouterPresentVC.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/7/6.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

final class RouterPresentViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我是被 present 的"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "首页",
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(homeAction))
        let item1 = UIBarButtonItem.init(title: "关闭",
                                         style: .plain,
                                         target: self,
                                         action: #selector(closeAction))
        let item2 = UIBarButtonItem.init(title: "present",
                                         style: .plain,
                                         target: self,
                                         action: #selector(presentAction))
        self.navigationItem.rightBarButtonItems = [item1, item2]
    }
    
    @objc func closeAction() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func presentAction() {
        Router.performJump(routerPath: RouterJumpPath.debugPresentRouter,
                             animationType: .present,
                             query: ["title": "这是一个 present 过来的 VC"])
    }
    
    @objc func homeAction() {
//        DMRouter.performJump(routerPath: RouterJumpPath.home, animated: false, query: ["shopId": "12345678"])
    }
}

extension RouterPresentViewController: SpiderRouterJumpProtocol {
    static func registerJumpRouter() -> RouterType {
        return (RouterJumpPath.debugPresentRouter, NSStringFromClass(RouterPresentViewController.self))
    }
    
    static func isCanJumpRouter(path: String) -> Bool {
        return path == RouterJumpPath.debugPresentRouter
    }
    
    static func createJumpRouterTarget(routerModel: SpiderRouterModel) -> UIViewController? {
        DLog("\(routerModel.query)")
        let presentVC = RouterPresentViewController()
        let navigaitonVC = BaseNavigationController(rootViewController: presentVC)
        return navigaitonVC
    }
}
